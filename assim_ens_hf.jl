using Base.Test
using NetCDF
using MAT
using divand
using Interpolations
using Base
using GeoMapping
using PyPlot

rms(a,b) = sqrt(mean((a - b).^2))


"""
Ensemble Transform Kalman Filter
"""
function ETKF_HXf(Xf,HXf,y,R)


    # ensemble size
    N = size(Xf,2)

    # number of observations
    m = size(y,1)

    xf = mean(Xf,2)[:,1]
    Xfp = Xf - repmat(xf,1,N)

    Hxf = mean(HXf,2)[:,1]
    S = HXf - repmat(Hxf,1,N)

    F = S*S' + (N-1) * R

    # ETKF with square-root of invTTt (e.g. Hunt et al., 2007)

    invR_S = R \ S
    invTTt = (N-1) * eye(N) + S' * invR_S

    e = eigfact(Symmetric(invTTt))
    U_T = e.vectors
    Sigma_T = Diagonal(e.values)

    T = U_T * (sqrt.(Sigma_T) \ U_T')
    Xap = sqrt(N-1) * Xfp * T
    xa = xf + Xfp * (U_T * (inv(Sigma_T) * U_T' * (invR_S' * (y - Hxf))))

    Xa = Xap + repmat(xa,1,N)

    return Xa,xa

end

datadir = joinpath(dirname(@__FILE__),"data")

fname = joinpath(datadir,"ensemble_surface.mat")
f = matopen(fname)
u = read(f,"Us");
v = read(f,"Vs");
close(f)


km2deg(x) = 180 * x / (pi * 6371)


function radarobsloc(lon0,lat0,r,bearing)

    R,Bearing = divand.ndgrid(r,bearing);
    
    latobs2 = zeros(size(R))
    lonobs2 = zeros(size(R))
    
    for j = 1:length(bearing)
        for i = 1:length(r)
            
            latobs2[i,j],lonobs2[i,j] = reckon(lat0, lon0, 
                                               km2deg(r[i]), -bearing[j])
        end
    end

    return lonobs2,latobs2,Bearing
end

lonobs1,latobs1,bearingobs1 = radarobsloc(9.84361,44.04167,20:50,69:5:179)

lonobs2,latobs2,bearingobs2 = radarobsloc(10,43,20:50,69:5:179)

bearingobs = bearingobs1[:]
lonobs = lonobs1[:]
latobs = latobs1[:]

bearingobs = [bearingobs1[:]; bearingobs2[:]]
lonobs = [lonobs1[:]; lonobs2[:]]
latobs = [latobs1[:]; latobs2[:]]



gridname = joinpath(datadir,"LigurianSea.nc")
nc = NetCDF.open(gridname); 
lon_u = nc["lon_u"][:,:]
lat_u = nc["lat_u"][:,:]
lon_v = nc["lon_v"][:,:]
lat_v = nc["lat_v"][:,:]
lon = nc["lon_rho"][:,:]
lat = nc["lat_rho"][:,:]
mask = nc["mask_rho"][:,:]
ncclose(gridname)


#contourf(lon,lat,mask,levels = [0.,0.5],colors = [[.5,.5,.5]])
#plot(lonobs[:],latobs[:],".")

mask_u = .!isnan.(u[:,:,1,1]);
mask_v = .!isnan.(v[:,:,1,1]);

sv = divand.statevector_init((BitArray(mask_u),BitArray(mask_v)));
allX = divand.packens(sv,(squeeze(u,3),squeeze(v,3)));



Xf = allX[:,1:end-1];



Hu,out,outbox = divand.sparse_interp_g((lon_u,lat_u),mask_u,(lonobs,latobs))

function spobsoper_radvel(sv,modelgrid,Xobs,varindexu,varindexv,bearing)
    Hu,outu,outboxu = divand.sparse_interp_g(modelgrid[varindexu],sv.mask[varindexu],Xobs)
    Hv,outv,outboxv = divand.sparse_interp_g(modelgrid[varindexv],sv.mask[varindexv],Xobs)

    b = bearing[:]*pi/180

    Hgridu = spzeros(length(Xobs[1]),sv.n)
    Hgridu[:,sv.ind[varindexu]+1:sv.ind[varindexu+1]] = spdiagm(sin.(b)) * Hu * sparse_pack(sv.mask[varindexu])'

    Hgridv = spzeros(length(Xobs[1]),sv.n)
    Hgridv[:,sv.ind[varindexv]+1:sv.ind[varindexv+1]] = spdiagm(-cos.(b)) * Hv * sparse_pack(sv.mask[varindexv])'
    
    valid = .!outu .& .!outv
    H = sparse_pack(valid) * (Hgridu + Hgridv)
    return H,valid
end


modelgrid = ((lon_u,lat_u),(lon_v,lat_v))

varindex = 1

function interp_radvel(lon_u,lat_u,lon_v,lat_v,us,vs,lonobs,latobs,bearingobs)
    itpu = interpolate((lon_u[:,1],lat_u[1,:]),us,Gridded(Linear()));
    itpv = interpolate((lon_v[:,1],lat_v[1,:]),vs,Gridded(Linear()));
    b = bearingobs[:]*pi/180
#    lonobs = lonobs[:]
#    latobs = latobs[:]

    ur3 = [sin(b[i]) * itpu[lonobs[i],latobs[i]] - cos(b[i]) * itpv[lonobs[i],latobs[i]] for i = 1:length(b)];
    return ur3[.!isnan.(ur3)]
end



H,valid = spobsoper_radvel(sv,modelgrid,(lonobs,latobs),1,2,bearingobs)
ur2 = H * allX[:,end]

ur3 = interp_radvel(lon_u,lat_u,lon_v,lat_v,u[:,:,1,end],v[:,:,1,end],lonobs,latobs,bearingobs)
@show rms(ur3,ur2)


xt = allX[:,end]
xf = mean(Xf,2)

const m = sum(valid)



Hx = H*xt

#yo = H * xt + alpha * randn(m) + beta * SE * randn(Neof)
#yo = matread(joinpath(datadir,"yo.mat"))["yo"];

yo = H*xt

Rd = Diagonal([0.2 for i = 1:m])

HXf = H*Xf

ur4 = zeros(length(ur3),size(u,4)-1)

for i = 1:size(u,4)-1
    ur4[:,i] = interp_radvel(lon_u,lat_u,lon_v,lat_v,u[:,:,1,i],v[:,:,1,i],lonobs,latobs,bearingobs)
end



Xa,xa = ETKF_HXf(Xf,HXf,yo,Rd)


@show rms(xf,xt)
@show rms(xa,xt)
