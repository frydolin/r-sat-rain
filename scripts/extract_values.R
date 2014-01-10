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
# CMORPH
  cmorph.extr=t(raster::extract(cmorph, stations))
  # there is a funciton extract in zoo as well therefore the raster::
  colnames(cmorph.extr)<-stations$ID
  row.names(cmorph.extr)<-as.character(time.d)
  range(cmorph.extr, na.rm=TRUE)

#PERSIANN 
  persiann.extr=t(raster::extract(persiann, stations))
  colnames(persiann.extr)<-stations$ID
  row.names(persiann.extr)<-as.character(time.d)
  range(persiann.extr, na.rm=TRUE)

#3B43
  trmm3b43.extr=t(raster::extract(trmm3b43, stations))
  colnames(trmm3b43.extr)<-stations$ID
  row.names(trmm3b43.extr)<-as.character(time.m)
  trmm3b43.extr=trmm3b43.extr*24 #convert rain rate to daily average
  range(trmm3b43.extr, na.rm=TRUE)

###

#### MAKE TIME SERIES ####
  library("zoo")
  #conversion of matrix to data frame is crucial
#cmorph
  cmorph.ts=lapply(as.data.frame(cmorph.extr), 
                   function(x) zoo(x, order.by=time.d))
  names(cmorph.ts)=paste("cmorph",stations$ID, sep=".")
  
#PERSIANN
  persiann.ts=lapply(as.data.frame(persiann.extr), 
                 function(x) zoo(x, order.by=time.d))
  names(persiann.ts)=paste("persiann",stations$ID, sep=".")
#3B43
  trmm3b43.ts=lapply(as.data.frame(trmm3b43.extr), 
                 function(x) zoo(x, order.by=time.m))
  names(trmm3b43.ts)=paste("trmm3b43",stations$ID, sep=".")
###

######### END #####
