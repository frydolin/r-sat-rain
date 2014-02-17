#### Spatial Aggregation of raster time series ####

#### SET UP ####
  library("sp")
  library("maptools")
  library("rgeos")
  library("raster")
  library("rts")
###

#### Spatial Subsetting ####
  projection=CRS(projection(cmorph))
  catchment_shp  <-readShapePoly(fn="input//tayan-sekayam//tayan-sekayam.shp", proj4string=projection)
  extent=extent(catchment_shp)+0.2

  crop.cmorph=crop(cmorph, extent)
#   plot(crop.cmorph[[4]])
#   plot(catchment_shp, add=TRUE)
#   ncol(crop.cmorph[[4]])
#   nrow(crop.cmorph[[4]])

# divide each cell into 25 cells so as to go from 0.25° to 0.05°
da.cmorph=disaggregate(crop.cmorph, fact=5) 
#   plot(da.cmorph[[4]])
#   plot(catchment_shp, add=TRUE)
#   ncol(da.cmorph[[4]])
#   nrow(da.cmorph[[4]])

# mask with shape of catchment
  mask.cmorph=mask(da.cmorph, catchment_shp)
#   plot(mask.cmorph[[4]])
#   plot(catchment_shp, add=TRUE)
#   str(mask.cmorph)
rm(crop.cmorph, da.cmorph)

#### Make time series of mean values ####
s1=cellStats(mask.cmorph[[4]],stat=mean)

#### Convert to raster time series and aggregate####
# CMORPH
  cmorph.d_ts=rts(masked.cmorph, time=time.d)
  #str(cmorph.rts@time)
  cmorph.m_ts=apply.monthly(cmorph.d_ts,mean)
  cmorph.y_ts=apply.yearly(cmorph.d_ts,mean)

#   plot(cmorph.m_ts, y=c(1:12))
#   str(cmorph)

# PERSIANN
# TRMM

#### Catchment wide means ####


# Correlation between rasters
plot(cmorph.rts, y=1)
str(cmorph[[1]])
cor(values(cmorph[[1]]), values(cmorph[[3]]))

(mean(cmorph.rts, na.rm=TRUE))
endpoints(cmorph.rts)
test=period.apply(cmorph.rts, 4383, mean)
plot(test)
plot(cmorph.y_ts)
plot(catchment_shp, add=TRUE)
str(test)
