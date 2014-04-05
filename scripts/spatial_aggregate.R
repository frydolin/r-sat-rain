###### SPATIO-TEMPORAL RAINFALL PATTERNS IN KAPUAS BASIN ######
	### ASSESSING USEFULNESS OF SATELLITE PRECIPITATION ESTIMATES ###
	### SPATIAL COMPARISON ####
	
#### A: SUBCATCHMENT AVERAGES ####
#### SET UP ####
  library("sp")
  library("maptools")
  library("raster")
  library("zoo")
  library("rts")
  
  projection=CRS(projection(trmm))
###

#### Load shapefiles ####
  shps=list(
      readShapePoly(fn="input//gis//tayan-shp//tayan-shp.shp", proj4string=projection),
      readShapePoly(fn="input//gis//sekayam-shp//sekayam-shp.shp", proj4string=projection),
        readShapePoly(fn="input//gis//belitang-shp/belitang.shp", proj4string=projection)
        )
  extents=lapply(shps, function(x) extent(x)+0.3) # get extents of subcatchments
###

#### Spatial Subsetting ####
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
#   rm(persiann, cmorph, trmm)

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
###

#### Convert to raster time series and aggregate####
# PERSIANN
  # na.rm is set to TRUE!
  persiann.d_ts=lapply(mask.persiann, rts, time=time.d)
  persiann.m_ts=lapply(persiann.d_ts, apply.monthly, mean,na.rm=TRUE)
  persiann.y_ts=lapply(persiann.d_ts, apply.yearly, mean,na.rm=TRUE)
# CMORPH
  cmorph.d_ts=lapply(mask.cmorph, rts, time=time.d)
  cmorph.m_ts=lapply(cmorph.d_ts, apply.monthly, mean)
  cmorph.y_ts=lapply(cmorph.d_ts, apply.yearly, mean)
# TRMM
  trmm.d_ts=lapply(mask.trmm, rts, time=time.d)
  trmm.m_ts=lapply(trmm.d_ts, apply.monthly, mean)
  trmm.y_ts=lapply(trmm.d_ts, apply.yearly, mean)

  rm(mask.persiann, mask.cmorph, mask.trmm )
###

#### CATCHMENT MEANS ####
## Make time series of catchment wide means values
## They can be compared to IDW spatial interpolations of mean values for the whole catchment
# PERSIANN
  persiann.sp.d_ts=lapply(persiann.d_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.d))
  persiann.sp.m_ts=lapply(persiann.m_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.m))
  persiann.sp.y_ts=lapply(persiann.y_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.y))
#CMORPH
  cmorph.sp.d_ts=lapply(cmorph.d_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.d))
  cmorph.sp.m_ts=lapply(cmorph.m_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.m))
  cmorph.sp.y_ts=lapply(cmorph.y_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.y))
# TRMM
  trmm.sp.d_ts=lapply(trmm.d_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.d))
  trmm.sp.m_ts=lapply(trmm.m_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.m))
  trmm.sp.y_ts=lapply(trmm.y_ts, function(x) zoo(cellStats(x@raster,stat=mean), order.by=time.y))
###
### END A: SUBCATCHMENT AVERAGES ###

#### B: AGGREGATE ON MAP LEVEL ####
####  SET UP ####
  library("maptools")
  library("raster")
  library("rts")
###

#### Load shapefiles ####
  projection=CRS(projection(cmorph))
  subcatch_shp <-readShapePoly(fn="input/gis/subcatchments/subcatchments.shp", IDvar="catchment", proj4string=projection)
  kapuas_shp  <-readShapePoly(fn="input/gis/kapuas-basin//kapuas-basin.shp", IDvar="DN", proj4string=projection)
  stations_shp<-readShapePoints("input/gis/stationmap/stationmap.shp")
  stations_shp=stations_shp[c(-8,-9,-13),] # exclude SGU04, SGU19, STG03
###

#### Subsetting ####
  ext=extent(subcatch_shp)+0.4
  # Crop:
  crop.cmorph=crop(cmorph, ext)
  crop.persiann=crop(persiann, ext)
  crop.trmm=crop(trmm, ext)
  srfe_subcatch=list("CMORPH"=crop.cmorph, "PERSIANN"=crop.persiann, "TRMM"=crop.trmm)
  rm(crop.cmorph, crop.persiann, crop.trmm)
  # Disaggregate:
  srfe_subcatch.da=lapply(srfe_subcatch, disaggregate, fact=5) 
  rm(srfe_subcatch) 
#  # set again the extent 
  extnt=extent(109.75,111.75,-0.1,1.25)
  srfe_subcatch.da.recrop=lapply(srfe_subcatch.da, crop, extnt)
  # Mask:
  mask.srfe_subcatch <-lapply(srfe_subcatch.da.recrop, raster::mask, mask=subcatch_shp)
  rm(srfe_subcatch.da,srfe_subcatch.da.recrop)
###
   
#### AGGREGATING ####
# Daily, monthly, yearly
	# Make time series
  srfe_subcatch.d_ts=lapply(mask.srfe_subcatch, rts, time=time.d)
  # Aggretate to monthly and yearly
  srfe_subcatch.m_ts=lapply(srfe_subcatch.d_ts, apply.monthly, mean)
#  srfe_subcatch.y_ts=lapply(cmorph.d_ts, apply.yearly, mean)
  rm(srfe_subcatch.d_ts)
  
# By month mean
	# setZ
  mask.srfe_subcatch.Z=lapply(mask.srfe_subcatch,setZ, z=time.d, name="time")
  mon.fac <- format.Date(time.d,format="%m")
  mon.fac <- factor(mon.fac)
  # aggregate
  subcatch.srfe.bymonth=lapply(mask.srfe_subcatch.Z, zApply, by=mon.fac, fun=mean, name='months')
  #names(subcatch.idw.bymonth)=format.Date(datesx,format="%b")[1:12]
  rm(mask.srfe_subcatch.Z)
  
# Long term mean
  subcatch.srfe.ov.av=lapply(srfe_subcatch.m_ts, period.apply, 144,mean, na.rm=TRUE) #because it's 144 month
###
### END B: AGGREGATE ON MAP LEVEL ###
###### END spatial_aggregate.R ######
