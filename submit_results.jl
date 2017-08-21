
function submit_results2(groupname,
                        sitelon1,sitelat1,siteorientation1,
                        sitelon2,sitelat2,siteorientation2,rms_velocity)

    game = "Caen"
    data = JSON.json(Dict(
                          "sitelon1" => sitelon1,
                          "sitelat1" => sitelat1,
                          "siteorientation1" => siteorientation1,
                          "sitelon2" => sitelon2,
                          "sitelat2" => sitelat2,
                          "siteorientation2" => siteorientation2))

    groupname_esc = URIParser.escape(groupname)
    data_esc = URIParser.escape(data)      

    baseurl = "http://data-assimilation.net/scores"
    URL = "$(baseurl)/new?game=$(game)&name=$(groupname_esc)&value=$(rms_velocity)&data=$(data_esc)"
    
    #rm(download("$(baseurl)/new?game=$(game)&name=$(groupname)&value=$(rms_velocity)"))
    #readstring(`curl --data name=$(groupname)\&game=$(game)\&value=$(rms_velocity) $(baseurl)/new`)

    const libcurl = "/usr/lib/x86_64-linux-gnu/libcurl.so"
    const CURLOPT_URL = 10002
    const CURLE_OK = 0

    curl = ccall((:curl_easy_init,libcurl),Ptr{Void},())
    
    if curl == C_NULL
        error("curl_easy_init failed");
    end
    
    ccall((:curl_easy_setopt,libcurl),Void,(Ptr{Void},Int32,Ptr{UInt8}),curl,CURLOPT_URL,URL)
CURLcode = ccall((:curl_easy_perform,libcurl),Cint,(Ptr{Void},),curl)
    
    if CURLcode != CURLE_OK
        error("unable to reach $(baseurl)")
    end
    
    print("Check scores at: $(baseurl)/?game=$(game)\n")
    println("")    
end

