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
      readShapePoly(fn="input//gis//tayan-shp//tayan-shp.shp", proj4string=projection),
      readShapePoly(fn="input//gis//sekayam-shp//sekayam-shp.shp", proj4string=projection),
        readShapePoly(fn="input//gis//belitang-shp/belitang.shp", proj4string=projection)
        )
  extents=lapply(shps, function(x) extent(x)+0.3)

# 1.Crop area
  crop.area=function(x){
    crop=list()
    for (i in 1:length(extents)){
      crop[[i]]=crop(x, extents[[i]])}
    names(crop)=c("Tayan", "Sekayam", "Belitang")
    return(crop)
  }
  crop.persiann=crop.area(persiann)
  crop.cmorph=crop.area(cmorph)
  crop.trmm=crop.area(trmm)
  rm(persiann, cmorph, trmm)

# 2. divide each cell into 25 cells so as to go from 0.25° to 0.05°
  da.persiann=lapply(crop.persiann, disaggregate, fact=5) 
  da.cmorph=lapply(crop.cmorph, disaggregate, fact=5) 
  da.trmm=lapply(crop.trmm, disaggregate, fact=5) 
  rm(crop.persiann, crop.cmorph, crop.trmm)

# 3. mask with shape of catchment
  mask.area=function(x, shp){
    masked=list()
    for (i in 1:length(shp)){
      masked[[i]]=raster::mask(x[[i]], shp[[i]])
    }
    names(masked)=c("Tayan", "Sekayam", "Belitang")
    return(masked)
  }
  mask.persiann <-mask.area(da.persiann, shp=shps)
  mask.cmorph   <-mask.area(da.cmorph, shp=shps)
  mask.trmm     <-mask.area(da.trmm, shp=shps)
  rm(da.persiann, da.cmorph, da.trmm)

#### Convert to raster time series and aggregate####
# PERSIANN
  persiann.d_ts=lapply(mask.persiann, rts, time=time.d)
  persiann.m_ts=lapply(persiann.d_ts, apply.monthly, mean)
  persiann.y_ts=lapply(persiann.d_ts, apply.yearly, mean)
# CMORPH
  cmorph.d_ts=lapply(mask.cmorph, rts, time=time.d)
  cmorph.m_ts=lapply(cmorph.d_ts, apply.monthly, mean)
  cmorph.y_ts=lapply(cmorph.d_ts, apply.yearly, mean)
# TRMM
  trmm.d_ts=lapply(mask.trmm, rts, time=time.d)
  trmm.m_ts=lapply(trmm.d_ts, apply.monthly, mean)
  trmm.y_ts=lapply(trmm.d_ts, apply.yearly, mean)

  rm(mask.persiann, mask.cmorph, mask.trmm )

#### Make time series of catchment wide means values ####
## They can be compared to IDW spatial interpolations of mean values for the whole catchment
# PERSIANN
  persiann.sp_d=lapply(persiann.d_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.d))
  persiann.sp_m=lapply(persiann.m_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.m))
  sek.persiann.sp_y=lapply(persiann.y_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.y))
#CMORPH
  cmorph.sp_d=lapply(cmorph.d_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.d))
  cmorph.sp_m=lapply(cmorph.m_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.m))
  sek.cmorph.sp_y=lapply(cmorph.y_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.y))
# TRMM
  trmm.sp_d=lapply(trmm.d_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.d))
  trmm.sp_m=lapply(trmm.m_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.m))
  sek.trmm.sp_y=lapply(trmm.y_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.y))
###

#### END ####
