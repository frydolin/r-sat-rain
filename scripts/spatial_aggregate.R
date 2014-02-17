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

#### Convert to raster time series and aggregate####
# CMORPH
  cmorph.d_ts=rts(mask.cmorph, time=time.d)
  cmorph.m_ts=apply.monthly(cmorph.d_ts,mean)
  cmorph.b.m_ts=as.raster(cmorph.m_ts)
  cmorph.y_ts=apply.yearly(cmorph.d_ts,mean)
class(cmorph.y_ts@raster)

#   plot(cmorph.m_ts, y=c(1:12))
#   str(cmorph)

# PERSIANN
# TRMM

#### Make time series of catchment wide means values ####
## They can be compared to IDW spatial interpolations of mean values for the whole catchment
library("zoo")
cmorph.sp_d=zoo(cellStats(cmorph.d_ts@raster,stat=mean), order.by=time.d)
cmorph.sp_m=zoo(cellStats(cmorph.m_ts@raster,stat=mean), order.by=time.m)
cmorph.sp_y=zoo(cellStats(cmorph.y_ts@raster,stat=mean), order.by=time.y)
###
plot(cmorph.sp_y)
#### END ####
