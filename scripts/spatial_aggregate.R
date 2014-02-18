#### Spatial Aggregation of raster time series ####

#### SET UP ####
  library("sp")
  library("maptools")
  library("raster")
  library("zoo")
  library("rts")
###

#### Spatial Subsetting ####
  projection=CRS(projection(cmorph))
  shps=list(
      tayan_shp <-readShapePoly(fn="input//gis//tayan-shp//tayan-shp.shp", proj4string=projection),
      sekayam_shp <-readShapePoly(fn="input//gis//sekayam-shp//sekayam-shp.shp", proj4string=projection),
        belitang_shp <-readShapePoly(fn="input//gis//belitang-shp/belitang.shp", proj4string=projection)
        )

  extents=lapply(shps, function(x) extent(x)+0.3)
  crop.cmorph=list()
  for (i in 1:length(extents)){
  crop.cmorph[[i]]=crop(cmorph, extents[[i]])}
  names(crop.cmorph)=c("Tayan", "Sekayam", "Belitang")
  rm(cmorph)
# divide each cell into 25 cells so as to go from 0.25° to 0.05°
  da.cmorph=lapply(crop.cmorph, disaggregate, fact=5) 
  rm(crop.cmorph)

# mask with shape of catchment
  mask.cmorph=list()
  for (i in 1:length(shps)){mask.cmorph[[i]]=mask(da.cmorph[[i]],shps[[i]])}
  rm(da.cmorph)

#### Convert to raster time series and aggregate####
# CMORPH
  cmorph.d_ts=lapply(mask.cmorph, rts, time=time.d)
  cmorph.m_ts=lapply(cmorph.d_ts, apply.monthly, mean)
  cmorph.y_ts=lapply(cmorph.d_ts, apply.yearly, mean)

# PERSIANN
# TRMM

#### Make time series of catchment wide means values ####
## They can be compared to IDW spatial interpolations of mean values for the whole catchment
#CMORPH
  cmorph.sp_d=lapply(cmorph.d_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.d))
  cmorph.sp_m=lapply(cmorph.m_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.m))
  sek.cmorph.sp_y=lapply(cmorph.y_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.y))
# PERSIANN
# TRMM
###

#### END ####
