######### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## read.R
## Reads in the data

#### SET UP ####
  # call libraries
  library("SDMTools")
  library("raster")
  
  source("scripts/functions.R")

####PERSIANN DATA####
  # reads in daily persiann data and converts it to raster object.
  # PERSIANN data is in ESRI asc format, but correctly subsetted
  # therefore asc data is read and then converted to raster objects
  # 2001-2012 start date: 2001-01-01
  fpath="input/PERSIANN"
  files=list.files(path=fpath, pattern="*.asc", 
                   recursive=TRUE, include.dirs=TRUE, full.names=TRUE)
  persiann.rlist=list() #initialize
  for (i in 1:length(files)) {
    asc.tmp    =read.asc(file=files[i])
    persiann.rlist[i]=raster(asc.tmp)
  } 
  persiann=brick(persiann.rlist)
  rm(i, asc.tmp, persiann.rlist)
  str(persiann)
  names(persiann)
  plot(persiann[[4]])

#### CMORPH DATA ####
  library("raster")
  cmorph<-brick("input/CMORPH/cmorph.nc", varname="cmorph")
  str(cmorph)
  names(cmorph)    
  plot(cmorph[[4]])
###

#### TIME ####
#create time vector
time=seq(as.Date("2001-01-01"), as.Date("2012-12-31"), by="day")

####### END read.R #####