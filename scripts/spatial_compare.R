#### Spatial Comparison ####
library("sp")
library("maptools")
library("rgeos")
library("raster")
projection=CRS(projection(cmorph))
catchment_shp  <-readShapePoly(fn="input/Kapuas_catchment//Kapuas-catchment2.shp", proj4string=projection)
extent=extent(catchment_shp)
crop.cmorph=crop(cmorph, extent)
    plot(crop.cmorph[[4]])
    ncol(crop.cmorph[[4]])
    nrow(crop.cmorph[[4]])
# divide each cell into 25 cells so as to go from 0.25° to 0.05°
da.cmorph=disaggregate(crop.cmorph, fact=5) 
    plot(da.cmorph[[4]])
    ncol(da.cmorph[[4]])
    nrow(da.cmorph[[4]])
masked.cmorph=mask(da.cmorph, catchment_shp)
    plot(masked.cmorph[[10]])
    plot(catchment_shp, add=TRUE)
    str(masked.cmorph)

s1=cellStats(masked.cmorph[[4]],stat=sum)
s2=sum(masked.cmorph[[4:5]])
plot(s2-masked.cmorph[[4]])
s3=cellStats(masked.cmorph[[5]],stat=sum)
s4=cellStats(s2,stat=sum)
s1+s3
s4
