###### SPATIO-TEMPORAL RAINFALL PATTERNS IN KAPUAS BASIN ######
	### ASSESSING USEFULNESS OF SATELLITE PRECIPITATION ESTIMATES ###

## read.R:
## reads in the data

#### SET UP ####
  # call libraries
  library("sp")
  library("raster")
  ## set up time locale to get English time format
  Sys.setlocale("LC_TIME", "en_US.UTF-8") 
### END SET UP ###

#### TIME VECTORS ####
#create time vectors
time.d=seq(as.Date("2001-01-01"), as.Date("2012-12-31"), by="day")
time.m=seq(as.Date("2001-01-01"), as.Date("2012-12-31"), by="month")
time.y=seq(as.Date("2001-01-01"), as.Date("2012-12-31"), by="year")
###
  
#### READ PERSIANN DATA ####
  # persiann data already converted in one *.nc file
  # rainfall in mm/day
  # 2001-2012 start date: 2001-01-01
  persiann<-brick("input/persiann.nc", varname="variable", crs=projection)
#   str(persiann)
  names(persiann)=time.d
#   plot(persiann[[4]])

#### READ CMORPH DATA ####
  # cmorph data already converted in one *.nc file
  # rainfall in mm/day
  # 2001-2012 start date: 2001-01-01
  cmorph<-brick("input/cmorph.nc", varname="cmorph", crs=projection)
#   str(cmorph)
   names(cmorph)=time.d
#   plot(cmorph[[4]])
###

#### READ TRMM 3B42 DATA ####
  # 3b42 data already converted in one *.nc file
  # Rainfall in mm/day
  # 2001-2012 start date: 2001-01-01
  trmm<-brick("input/TRMM3B42.nc", varname="r")
#    str(trmm)
    names(trmm)=time.d
#    plot(trmm[[4]])
###

#### LOAD IN GROUND DATA ####
	# loads daily, monthly and yearly data obtained in rainfall analysis
	# Get file names
	fpath='input/ground'
  files= list.files(path=fpath, pattern=".csv", full.names=TRUE)
  # Read into a list
  gdata=lapply(files, read.csv, na.strings = "NA", row.names=1)
  names(gdata)=c("d_df", "m_df", "y_df")
	rm(files)
### END LOAD GROUND DATA ###

###### END read.R ######
