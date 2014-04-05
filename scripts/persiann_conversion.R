###### SPATIO-TEMPORAL RAINFALL PATTERNS IN KAPUAS BASIN ######
	### ASSESSING USEFULNESS OF SATELLITE PRECIPITATION ESTIMATES ###
	
## persiann_conversion.R
## script to load PERSIANN data in ESRI ASCII format and convert to one single NetCDF file

#### SET UP ####
  # call libraries
  library("sp")
  library("raster")
  library("SDMTools")
  ## set up time locale to get English time format
  Sys.setlocale("LC_TIME", "en_US.UTF-8") 
### 

####P ERSIANN DATA CONVERSION ####
   # reads in daily persiann data and converts it to raster object.
   # and then exports it to netCDF
   # PERSIANN data is in ESRI ASCII format, but correctly subsetted
   # therefore .*asc data is read and then converted to raster objects
   # rainfall is in mm/day
   # 2001-2012 start date: 2001-01-01 
   fpath="input/PERSIANN" # needs adjustment
   files=list.files(path=fpath, pattern="*.asc", 
                    recursive=TRUE, include.dirs=TRUE, full.names=TRUE) # recursive=TRUE!!
   persiann.rlist=list() # initialize list
   for (i in 1:length(files)) {
     asc.tmp    =read.asc(file=files[i]) # read file
     persiann.rlist[i]=raster(asc.tmp) # convert to raster format
   } 
   persiann=brick(persiann.rlist)	# make brick out of list
   writeRaster( persiann, "persiann.nc" ) #write to NetCDF file
   # cleanup
   rm(i, asc.tmp, persiann.rlist)
   rm(fpath, files)
###

###### END persiann_conversion.R ######
