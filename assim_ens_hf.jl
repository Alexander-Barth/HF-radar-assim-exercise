using NetCDF
using Interpolations
using GeoMapping
using PyPlot


"""
Compute the RMS difference between a and b
"""

rms(a,b) = sqrt(mean((a - b).^2))


"""
Ensemble Transform Kalman Filter where Xf is the forecast ensemble, HXf the observed part of the forecast ensemble, y the observations and R the observation error covariance.
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

"""
x = packsv(mask_u,mask_v,u,v)
combine the velocity field with the component u and v
in a single state vector where the corresponding elements of
the masks mask_u and mask_v are true"""
function packsv(mask_u,mask_v,u,v)
    return [u[mask_u]; v[mask_v]]
end

"""
u,v = unpacksv(mask_u,mask_v,x)
Extract from a state vector x the compoennts u and v. It is the reverse operation of packsv.
"""
function unpacksv(mask_u,mask_v,x)
    n = sum(mask_u)
    u = fill(NaN,size(mask_u))
    v = fill(NaN,size(mask_v))
    u[mask_u] = x[1:n]
    v[mask_v] = x[n+1:end]
    return u,v
end

"convert km to arc degree on the surface of the Earth"
km2deg(x) = 180 * x / (pi * 6371)


"""
lonobs,latobs,Bearing = radarobsloc(lon0,lat0,r,bearing)
Compute the location of the radial velocities covered by an HF radar site located at lon0,lat0. The vector r are the ranges (in km) and bearing are the angles (in degree). It also returns the matrix Bearing which has the same size as the matrices lonobs and latobs where the bearing angle is repeated for the different ranges.
"""

function radarobsloc(lon0,lat0,r,bearing)

    sz = (length(r),length(bearing))
    latobs = zeros(sz)
    lonobs = zeros(sz)
    Bearing = zeros(sz)

    for j = 1:length(bearing)
        for i = 1:length(r)
            Bearing[i,j] = bearing[j]
            latobs[i,j],lonobs[i,j] = reckon(lat0, lon0,
                                             km2deg(r[i]), bearing[j])
        end
    end

    return lonobs,latobs,Bearing
end



"""
plotvel(u,v; legendvec = 1)
Plot the vector field with the comonents u and v. The parameter legendvec is an optional argument representing the length of the legend vector
"""

function plotvel(u,v; legendvec = 1)
    us = (u[1:end-1,2:end-1] + u[2:end,2:end-1]) / 2.
    vs = (v[2:end-1,1:end-1] + v[2:end-1,2:end]) / 2.
    r = 5

    ur = us[1:r:end,1:r:end]
    vr = vs[1:r:end,1:r:end]
    lonr = lon[2:end-1,2:end-1][1:r:end,1:r:end]
    latr = lat[2:end-1,2:end-1][1:r:end,1:r:end]

    ur[end-7,end-3] = legendvec
    vr[end-7,end-3] = 0
    contourf(lon,lat,mask,levels = [0.,0.5],colors = [[.5,.5,.5]])
    quiver(lonr,latr,ur,vr)
end

"""
ur = interp_radvel(lon_u,lat_u,lon_v,lat_v,us,vs,lonobs,latobs,bearingobs)
Interpolate and rotate the velocity vertors to compute the radial velcity `ur`.
"""
function interp_radvel(lon_u,lat_u,lon_v,lat_v,us,vs,lonobs,latobs,bearingobs)
    itpu = interpolate((lon_u[:,1],lat_u[1,:]),us,Gridded(Linear()));
    itpv = interpolate((lon_v[:,1],lat_v[1,:]),vs,Gridded(Linear()));
    b = bearingobs[:]*pi/180
    ur = [sin(b[i]) * itpu[lonobs[i],latobs[i]] - cos(b[i]) * itpv[lonobs[i],latobs[i]] for i = 1:length(b)];
    return ur[.!isnan.(ur)]
end

"""
submit_results(groupname,sitelon1,sitelat1,siteorientation1,sitelon2,sitelat2,siteorientation2)

Submit the results
"""

function submit_results(groupname,
                        sitelon1,sitelat1,siteorientation1,
                        sitelon2,sitelat2,siteorientation2)

    withenv("LD_LIBRARY_PATH" => "$(ENV["HOME"])/.julia/v0.6/Conda/deps/usr/lib/") do
        run(`$(ENV["HOME"])/HF-radar-assim-caen/bin/submit-result.exe $(groupname) $(sitelon1) $(sitelat1) $(siteorientation1) $(sitelon2) $(sitelat2) $(siteorientation2)`)
    end
end


# location of the data
# @__FILE__is the path of the current file assim_ens_hf.jl
datadir = joinpath(dirname(@__FILE__),"data")

# load the NetCDF varibles u and v
fname = joinpath(datadir,"ensemble_surface.nc")
nc = NetCDF.open(fname)
u = nc["u"][:,:,:]
v = nc["v"][:,:,:]
ncclose(fname)


# load the model grid

gridname = joinpath(datadir,"LS2v.nc")
nc = NetCDF.open(gridname);
lon_u = nc["lon_u"][:,:]
lat_u = nc["lat_u"][:,:]
lon_v = nc["lon_v"][:,:]
lat_v = nc["lat_v"][:,:]
lon = nc["lon_rho"][:,:]
lat = nc["lat_rho"][:,:]
mask = nc["mask_rho"][:,:]
ncclose(gridname)

# location of the observations

# sitelon1 = 9.84361
# sitelat1 = 44.04167
# siteorientation1 = 240

# # NC
# sitelon2 = 8.11
# sitelat2 = 43.95
# siteorientation2 = 140


# sitelon1 = 8.49
# sitelat1 = 44.33
# siteorientation1 = 150
# # NC
# sitelon2 = 8.11
# sitelat2 = 43.95
# siteorientation2 = 140


sitelon1 = 9.397
sitelat1 = 43
siteorientation1 = -20


sitelon2 = 8.73
sitelat2 = 42.57
siteorientation2 = 0

# location of the observations

ranges = 10:5:100

lonobs1,latobs1,bearingobs1 = radarobsloc(sitelon1,sitelat1,ranges,siteorientation1 + (-60:5:60))
lonobs2,latobs2,bearingobs2 = radarobsloc(sitelon2,sitelat2,ranges,siteorientation2 + (-60:5:60))

bearingobs = bearingobs1[:]
lonobs = lonobs1[:]
latobs = latobs1[:]

bearingobs = [bearingobs1[:]; bearingobs2[:]]
lonobs = [lonobs1[:]; lonobs2[:]]
latobs = [latobs1[:]; latobs2[:]]




clf()
figure(1)

contourf(lon,lat,mask,levels = [0.,0.5],colors = [[.5,.5,.5]])

plot(sitelon1,sitelat1,"x")
plot(lonobs1[:],latobs1[:],".")
plot(sitelon2,sitelat2,"x")
plot(lonobs2[:],latobs2[:],".")

mask_u = .!isnan.(u[:,:,1]);
mask_v = .!isnan.(v[:,:,1]);



xt = packsv(mask_u,mask_v,u[:,:,end],v[:,:,end])

n = sum(mask_u) + sum(mask_v)
Nens = size(u,3)-1

Xf = zeros(n,Nens)
for n = 1:Nens
    Xf[:,n] = packsv(mask_u,mask_v,u[:,:,n],v[:,:,n])
end

xf = mean(Xf,2)


u3,v3 = unpacksv(mask_u,mask_v,xt)

#yo = H * xt + alpha * randn(m) + beta * SE * randn(Neof)

yo = interp_radvel(lon_u,lat_u,lon_v,lat_v,u[:,:,end],v[:,:,end],lonobs,latobs,bearingobs)
# add noise to yo

Rd = Diagonal([0.2 for i = 1:length(yo)])


HXf = zeros(length(yo),size(u,3)-1)

for i = 1:size(u,3)-1
    HXf[:,i] = interp_radvel(lon_u,lat_u,lon_v,lat_v,u[:,:,i],v[:,:,i],lonobs,latobs,bearingobs)
end



Xa,xa = ETKF_HXf(Xf,HXf,yo,Rd)

uf,vf = unpacksv(mask_u,mask_v,xf)
ua,va = unpacksv(mask_u,mask_v,xa)

@show rms(xf,xt)
@show rms(xa,xt)

# groupname = "mygroup"

# us = (u[1:end-1,2:end-1,:] + u[2:end,2:end-1,:]) / 2.
# vs = (v[2:end-1,1:end-1,:] + v[2:end-1,2:end,:]) / 2.


# varvel = var(us,3) + var(vs,3)
# varvel = varvel[:,:,1]
# figure()
# varvel[mask[2:end-1,2:end-1] .== 0] = NaN
# pcolor(lon[2:end-1,2:end-1],lat[2:end-1,2:end-1],varvel)
# colorbar()

# normvel = sqrt.(us.^2 + vs.^2);
# prob = mean(normvel .> 0.2,3)
# prob = prob[:,:,1]
# prob[mask[2:end-1,2:end-1] .== 0] = NaN

# figure()
# pcolor(lon[2:end-1,2:end-1],lat[2:end-1,2:end-1],prob)
# colorbar()


# figure(),plotvel(uf,vf; legendvec = 1)
# figure(),plotvel(ua,va; legendvec = 1)
