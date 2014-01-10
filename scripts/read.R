######### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## read.R
## Reads in the data

#### SET UP ####
  # call libraries
  library("sp")
  library("raster")
  library("SDMTools")
  
####PERSIANN DATA####
  # reads in daily persiann data and converts it to raster object.
  # PERSIANN data is in ESRI asc format, but correctly subsetted
  # therefore asc data is read and then converted to raster objects
  # rainfall in mm/day
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
#cleanup
  rm(i, asc.tmp, persiann.rlist)
  rm(fpath, files)
# 
#   str(persiann)
#   names(persiann)
#   plot(persiann[[4]])

#### CMORPH DATA ####
  library("raster")
  # cmorph data already converted in one *.nc file
  # rainfall in mm/day
  # 2001-2012 start date: 2001-01-01
  cmorph<-brick("input/CMORPH/cmorph.nc", varname="cmorph")

#   str(cmorph)
#   names(cmorph)    
#   plot(cmorph[[4]])
###

#### TRMM 3B43 data ####
  # 3b43 data already converted in one *.nc file
  # monthly averages of rainfall in mm/hour!!!
  # 2001-2012 start date: 2001-01-01
  library("raster")
  trmm3b43<-brick("input/TRMM3B43/TRMM3B43-rate.nc")#, varname="cmorph")
#   str(trmm3b43)
#   names(trmm3b43)    
#   plot(trmm3b43[[4]])
###

#### TIME ####
#create time vector
time.d=seq(as.Date("2001-01-01"), as.Date("2012-12-31"), by="day")
time.m=seq(as.Date("2001-01-01"), as.Date("2012-12-31"), by="month")
###

####### END read.R #####
