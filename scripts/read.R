######### SATELLITE PRECIPITATION ESTIMATES – ASSESSING THEIR FEASABILITY FOR KAPUAS CATCHMENT ######

## read.R reads in the data

#### SET UP ####
  # call libraries
  library("sp")
  library("raster")
  library("SDMTools")
  ## set up time locale to get English time format
  Sys.setlocale("LC_TIME", "en_US.UTF-8") 
### END SET UP ###

#### TIME ####
#create time vectors
time.d=seq(as.Date("2001-01-01"), as.Date("2012-12-31"), by="day")
time.m=seq(as.Date("2001-01-01"), as.Date("2012-12-31"), by="month")
time.y=seq(as.Date("2001-01-01"), as.Date("2012-12-31"), by="year")
###
  
####PERSIANN DATA CONVERSION####
#   # reads in daily persiann data and converts it to raster object.
#   # and then exports it to netCDF
#   # PERSIANN data is in ESRI asc format, but correctly subsetted
#   # therefore asc data is read and then converted to raster objects
#   # rainfall in mm/day
#   # 2001-2012 start date: 2001-01-01
#   fpath="input/PERSIANN"
#   files=list.files(path=fpath, pattern="*.asc", 
#                    recursive=TRUE, include.dirs=TRUE, full.names=TRUE)
#   persiann.rlist=list() #initialize
#   for (i in 1:length(files)) {
#     asc.tmp    =read.asc(file=files[i])
#     persiann.rlist[i]=raster(asc.tmp)
#   } 
#   persiann=brick(persiann.rlist)
#   writeRaster( persiann, "persiann.nc" ) #write to NetCDF file
# #cleanup
#   rm(i, asc.tmp, persiann.rlist)
#   rm(fpath, files)

####PERSIANN DATA####
  # persiann data already converted in one *.nc file
  # rainfall in mm/day
  # 2001-2012 start date: 2001-01-01
  persiann<-brick("input/persiann.nc", varname="variable", crs=projection)
#   str(persiann)
  names(persiann)=time.d
#   plot(persiann[[4]])

#### CMORPH DATA ####
  # cmorph data already converted in one *.nc file
  # rainfall in mm/day
  # 2001-2012 start date: 2001-01-01
  cmorph<-brick("input/cmorph.nc", varname="cmorph", crs=projection)
#   str(cmorph)
   names(cmorph)=time.d
#   plot(cmorph[[4]])
###

#### TRMM 3B42 data ####
  # 3b42 data already converted in one *.nc file
  # Rainfall in mm/day
  # 2001-2012 start date: 2001-01-01
  trmm<-brick("input/TRMM3B42.nc", varname="r")
#    str(trmm)
    names(trmm)=time.d
#    plot(trmm[[4]])
###

#### LOAD IN ALL GROUND DATA ####
# Get file names
fpath='input/ground'
  files= list.files(path=fpath, pattern=".csv", full.names=TRUE)
  # Read in
  gdata=lapply(files, read.csv, na.strings = "NA", row.names=1)
  names(gdata)=c("d_df", "m_df", "y_df")
rm(files)
### END LOAD GROUND DATA###

####### END read.R #######
