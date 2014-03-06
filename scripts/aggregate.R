######### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## aggregate.R creates all summaries to be analysed
## and outputs summary tables 
## also ground data is read and necessary data conversions performed

source("scripts/functions.R")

#### AGGREGATION ####
## see README for variable naming convention 
## aggregation with mean i.e. output is average daily rainfall per week, month, year, ... ##
## na.rm currently FALSE 

#cmorph
  opath="output/cmorph"
  dir.create(opath)
  cmorph.ag=basic.aggregate(cmorph.ts, fun=mean, na.rm=TRUE, opath=opath, stnames=stations_shp$ID)
#persiann
  opath="output/persiann"
  dir.create(opath)
  persiann.ag=basic.aggregate(persiann.ts, fun=mean, na.rm=TRUE, opath=opath, stnames=stations_shp$ID)

#trmm3b42
  opath="output/trmm"
  dir.create(opath)
  trmm.ag=basic.aggregate(trmm.ts, fun=mean, na.rm=TRUE, opath=opath, stnames=stations_shp$ID)

rm(cmorph.ts, persiann.ts, trmm.ts) #they are now part of the *.ag lists
###
#### SUBSET GROUND DATA ####
# note that end date is the same as for satellite time series
# only for this reason subsetting is possible like this
  gdata$d_df=gdata$d_df[(nrow(gdata$d_df)-nrow(cmorph.ag$d_df)+1):nrow(gdata$d_df),]
  gdata$m_df=gdata$m_df[(nrow(gdata$m_df)-nrow(cmorph.ag$m_df)+1):nrow(gdata$m_df),]
  gdata$y_df=gdata$y_df[(nrow(gdata$y_df)-nrow(cmorph.ag$y_df)+1):nrow(gdata$y_df),]

#### MAKE A DATAFRAME PER STATION FOR EASY COMPARISON ####
# DAILY
  daily.comp=list()
  for (i in names(gdata$d_df))
  {
    daily.comp[[i]]=
      (                  cbind(gdata$d_df[,i],cmorph.ag$d_df[,i], 
                         persiann.ag$d_df[,i],trmm.ag$d_df[,i])
      )
    colnames(daily.comp[[i]])=c("Ground", "CMORPH", "PERSIANN", "TRMM")
  }

#monthly
  monthly.comp=list()
  for (i in names(gdata$m_df))
  {
    monthly.comp[[i]]=
      (                  cbind(gdata$m_df[,i],cmorph.ag$m_df[,i], 
                         persiann.ag$m_df[,i], trmm.ag$m_df[,i])
      )
    colnames(monthly.comp[[i]])=c("Ground", "CMORPH", "PERSIANN", "TRMM")
  }
#yearly
  yearly.comp=list()
  for (i in names(gdata$y_df))
  {
    yearly.comp[[i]]=
      (                  cbind(gdata$y_df[,i],cmorph.ag$y_df[,i], 
                               persiann.ag$y_df[,i], trmm.ag$y_df[,i])
      )
    colnames(yearly.comp[[i]])=c("Ground", "CMORPH", "PERSIANN", "TRMM")
  }
###
#### CLEAN UP ####
# remove variables and data not needed anymore
rm(i)
rm(opath, fpath) 
### END CLEAN UP ###

########## END aggregate.R #############
