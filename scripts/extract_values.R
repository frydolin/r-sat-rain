######### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## Extract values for all stations on all dates

## SET UP ##
library("sp")
library("raster")
library("maptools")

### LOAD STATIONS ####
stations<-readShapePoints("input/stationmap/stationmap.shp")

###

#### EXTRACT ####
  cmorph.extr=t(extract(cmorph, stations))
  colnames(cmorph.extr)<-stations$ID
  row.names(cmorph.extr)<-as.character(time)
  range(cmorph.extr)
  
  persiann.extr=t(extract(persiann, stations))
  colnames(persiann.extr)<-stations$ID
  row.names(persiann.extr)<-as.character(time)
  range(persiann.extr, na.rm=TRUE)

###

#### MAKE TIME SERIES ####
  library("zoo")
  cmorph.ts=lapply(as.data.frame(cmorph.extr), 
                   function(x) zoo(x, order.by=time))
  #conversion of matrix to data frame is crucial
###

######### END #####
