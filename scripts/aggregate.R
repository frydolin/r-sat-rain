######### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## aggregate.R creates all summaries to be analysed
## and outputs summary tables 
## also ground data is read and necessary data conversions performed


#### AGGREGATION ####
## see README for variable naming convention 
## aggregation with mean i.e. output is average daily rainfall per week, month, year, ... ##
## and also sums ##
## na.rm currently FALSE 

#cmorph
  opath="output/cmorph"
  dir.create(opath)
  cmorph.ag=basic.aggregate(cmorph.ts, fun=mean, opath=opath, 
                            stnames=stations$ID)
#persiann
  opath="output/cmorph"
  dir.create(opath)
  persiann.ag=basic.aggregate(persiann.ts, fun=mean, opath=opath, 
                            stnames=stations$ID)

#trmm3b43
  opath="output/trmm3b43"
  dir.create(opath)
  trmm3b43.ag=basic.aggregate(trmm3b43.ts, fun=mean, opath=opath, 
                            stnames=stations$ID)

###

#### LOAD IN ALL GROUND DATA ####
# Get file names
  fpath='input/ground'
  files= list.files(path=fpath, pattern=".csv", full.names=TRUE)
# Read in
  gdata=lapply(files, read.csv, na.strings = "NA")

# change time column to row. names, assign column names
  for(i in 1:length(gdata)){
    row.names(gdata[[i]])=gdata[[i]]$X
    gdata[[i]]=gdata[[i]][,-1]
  }
  names(gdata)=c("d_df", "m_df", "y_df")

# subset 
# note that end date is the same then for satellite time series
# only for this reason subsetting is possible like this
  gdata$d_df=gdata$d_df[(nrow(gdata$d_df)-nrow(cmorph.ag$d_df)+1):nrow(gdata$d_df),]
  gdata$m_df=gdata$m_df[(nrow(gdata$m_df)-nrow(cmorph.ag$m_df)+1):nrow(gdata$m_df),]
  gdata$y_df=gdata$y_df[(nrow(gdata$y_df)-nrow(cmorph.ag$y_df)+1):nrow(gdata$y_df),]
### END LOAD DATA ###

#### MAKE A DATAFRAME PER STATION FOR EASY COMPARISON ####
# DAILY
  daily.comp=list()
  for (i in names(gdata$d_df))
  {
    daily.comp[[i]]=(
      assign(paste(i,"d_df", sep="_"),
             cbind(gdata$d_df[,i],cmorph.ag$d_df[,i], persiann.ag$d_df[,i])))
    colnames=c("Ground", "CMORPH", "PERSIANN")
  }
#monthly
  monthly.comp=list()
  for (i in names(gdata$m_df))
  {
    monthly.comp[[i]]=(
      assign(paste(i,"m_df", sep="_"),
             cbind(gdata$m_df[,i],cmorph.ag$m_df[,i], persiann.ag$m_df[,i],trmm3b43.ag$m_df[,i] )))
    colnames=c("Ground", "CMORPH", "PERSIANN", "TRMM")
  }
#yearly
  yearly.comp=list()
  for (i in names(gdata$y_df))
  {
    yearly.comp[[i]]=(
      assign(paste(i,"y_df", sep="_"),
             cbind(gdata$y_df[,i],cmorph.ag$y_df[,i], persiann.ag$y_df[,i],trmm3b43.ag$y_df[,i] )))
    colnames=c("Ground", "CMORPH", "PERSIANN", "TRMM")
  }

#### CLEAN UP ####
# remove variables and data not needed anymore
rm(i)
rm(files, opath, fpath) 
### END CLEAN UP ###

########## END aggregate.R #############
