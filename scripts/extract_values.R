######### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## extract_values.R: Extract values of pixels of station locations on all dates from 

#### SET UP ####
library("sp")
library("raster")
library("maptools")

### LOAD STATIONS ####
stations_shp<-readShapePoints("input/gis//stationmap//stationmap.shp")
stations_shp=stations_shp[c(-8,-9,-13),] # exclude SGU04, SGU19, STG03

###
#### EXTRACT ####
extr.val=function(from,which){
  extr=t(raster::extract(from, which)) # there is a funciton extract in zoo as well therefore the raster:
  colnames(extr)<-which$ID
  row.names(extr)<-as.character(time.d)
  return(extr)
}
#PERSIANN 
  persiann.extr=extr.val(persiann, which=stations_shp)
  range(persiann.extr, na.rm=TRUE)
# CMORPH
  cmorph.extr=extr.val(cmorph, which=stations_shp)
  range(cmorph.extr, na.rm=TRUE)
#TRMM 3B42
  trmm.extr=extr.val(trmm, which=stations_shp)
  range(trmm.extr, na.rm=TRUE)
###
#### MAKE TIME SERIES ####
  library("zoo")
  #conversion of matrix to data frame is crucial
#cmorph
  cmorph.ts=lapply(as.data.frame(cmorph.extr), 
                   function(x) zoo(x, order.by=time.d))
  names(cmorph.ts)=paste("cmorph",stations_shp$ID, sep=".")
  
#PERSIANN
  persiann.ts=lapply(as.data.frame(persiann.extr), 
                 function(x) zoo(x, order.by=time.d))
  names(persiann.ts)=paste("persiann",stations_shp$ID, sep=".")
#TRMM 3B42
  trmm.ts=lapply(as.data.frame(trmm.extr), 
                 function(x) zoo(x, order.by=time.d))
  names(trmm.ts)=paste("trmm3b42",stations_shp$ID, sep=".")

rm(persiann.extr, cmorph.extr, trmm.extr)
###

######### END extract.R#########
