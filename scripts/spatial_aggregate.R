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
  tayan_shp <-readShapePoly(fn="input//tayan-shp//tayan-shp.shp", proj4string=projection)
  sekayam_shp <-readShapePoly(fn="input//sekayam-shp//sekayam-shp.shp", proj4string=projection)
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
str(catchment_shp)
plot(catchment_shp[1])
# mask with shape of catchment
  sek.cmorph=mask(da.cmorph, sekayam_shp)
  tay.cmorph=mask(da.cmorph, tayan_shp)
#   plot(mask.cmorph[[4]])
#   plot(catchment_shp, add=TRUE)
#   str(mask.cmorph)
rm(crop.cmorph, da.cmorph)

#### Convert to raster time series and aggregate####
# CMORPH
  sek.cmorph.d_ts=rts(sek.cmorph, time=time.d)
  sek.cmorph.m_ts=apply.monthly(sek.cmorph.d_ts,mean)
  sek.cmorph.y_ts=apply.yearly(sek.cmorph.d_ts,mean)

  tay.cmorph.d_ts=rts(tay.cmorph, time=time.d)
  tay.cmorph.m_ts=apply.monthly(tay.cmorph.d_ts,mean)
  tay.cmorph.y_ts=apply.yearly(tay.cmorph.d_ts,mean)

# PERSIANN
# TRMM

#### Make time series of catchment wide means values ####
## They can be compared to IDW spatial interpolations of mean values for the whole catchment
library("zoo")
  sek.cmorph.sp_d=zoo(cellStats(sek.cmorph.d_ts@raster,stat=mean), order.by=time.d)
  sek.cmorph.sp_m=zoo(cellStats(sek.cmorph.m_ts@raster,stat=mean), order.by=time.m)
  sek.cmorph.sp_y=zoo(cellStats(sek.cmorph.y_ts@raster,stat=mean), order.by=time.y)

  tay.cmorph.sp_d=zoo(cellStats(tay.cmorph.d_ts@raster,stat=mean), order.by=time.d)
  tay.cmorph.sp_m=zoo(cellStats(tay.cmorph.m_ts@raster,stat=mean), order.by=time.m)
  tay.cmorph.sp_y=zoo(cellStats(tay.cmorph.y_ts@raster,stat=mean), order.by=time.y)
###
#### COMPARE WITH INTERPOLATED DATA ####
## Read in interpolated data
# so far only monthly
  idw=read.csv("input/sek_tay_m_idw.csv")
  tay.idw=zoo(idw$PTayan, order.by=time.m)
  sek.idw=zoo(idw$PSekayam, order.by=time.m)
## Comparative plots
par(mfrow=c(1,2))
  plot(tay.cmorph.sp_m~tay.idw, xlim=c(0,20), ylim=c(0,20), xlab="IDW (mm/day)", ylab="CMORPH (mm/day)", main="Comparison of monthly values for Tayan subbasin")
  abline(0,1,col="red")
  plot(sek.cmorph.sp_m~sek.idw, xlim=c(0,20), ylim=c(0,20), xlab="IDW (mm/day)", ylab="CMORPH (mm/day)", main="Comparison of monthly values for Sekayam subbasin")
  abline(0,1,col="red")
#### END ####
