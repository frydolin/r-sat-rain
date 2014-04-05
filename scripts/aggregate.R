###### SPATIO-TEMPORAL RAINFALL PATTERNS IN KAPUAS BASIN ######
	### ASSESSING USEFULNESS OF SATELLITE PRECIPITATION ESTIMATES ###

## aggregate.R:
## creates all summaries to be analysed and outputs summary tables 
## for satellite and ground data

#### SET UP ####
	source("scripts/functions.R")
###

#### AGGREGATION OF EXTRACTED SATELLITE DATA ####
	## see README for variable naming convention 
	## aggregation with mean i.e. output is average daily rainfall per month, year, ... 
	## na.rm currently TRUE (the satellite data contains almost no NAs)
	## see functions.R for details to basic.aggregate() function used here
	dir.create("output/aggregated/")
	#cmorph
		opath="output/aggregated/cmorph"
		dir.create(opath)
		cmorph.ag=basic.aggregate(cmorph.ts, fun=mean, na.rm=TRUE, opath=opath, stnames=stations_shp$ID) 
	#persiann
		opath="output/aggregated/persiann"
		dir.create(opath)
		persiann.ag=basic.aggregate(persiann.ts, fun=mean, na.rm=TRUE, opath=opath, stnames=stations_shp$ID)

	#trmm3b42
		opath="output/aggregated/trmm"
		dir.create(opath)
		trmm.ag=basic.aggregate(trmm.ts, fun=mean, na.rm=TRUE, opath=opath, stnames=stations_shp$ID)

	rm(cmorph.ts, persiann.ts, trmm.ts) #they are now part of the *.ag lists
###

#### SUBSET GROUND DATA ####
# subset to the same period as satellite data
# note that end date is the same as for satellite time series, only for this reason subsetting is possible like this
  gdata$d_df=gdata$d_df[(nrow(gdata$d_df)-nrow(cmorph.ag$d_df)+1):nrow(gdata$d_df),]
  gdata$m_df=gdata$m_df[(nrow(gdata$m_df)-nrow(cmorph.ag$m_df)+1):nrow(gdata$m_df),]
  gdata$y_df=gdata$y_df[(nrow(gdata$y_df)-nrow(cmorph.ag$y_df)+1):nrow(gdata$y_df),]
###

#### MAKE ONE DATAFRAME PER STATION ####
# Makes a combined data frame of all observation types per station, this format is good for easy comparison later on
# DAILY
  daily.comp=list()
  for (i in names(gdata$d_df))
  {
    daily.comp[[i]]=
      (                  cbind(gdata$d_df[,i],cmorph.ag$d_df[,i], 
                         persiann.ag$d_df[,i],trmm.ag$d_df[,i])
      )
    colnames(daily.comp[[i]])=c("Ground", "CMORPH", "PERSIANN", "TRMM 3B42")
  }

# MONTHLY
  monthly.comp=list()
  for (i in names(gdata$m_df))
  {
    monthly.comp[[i]]=
      (                  cbind(gdata$m_df[,i],cmorph.ag$m_df[,i], 
                         persiann.ag$m_df[,i], trmm.ag$m_df[,i])
      )
    colnames(monthly.comp[[i]])=c("Ground", "CMORPH", "PERSIANN", "TRMM 3B42")
  }
  
# YEARLY
  yearly.comp=list()
  for (i in names(gdata$y_df))
  {
    yearly.comp[[i]]=
      (                  cbind(gdata$y_df[,i],cmorph.ag$y_df[,i], 
                               persiann.ag$y_df[,i], trmm.ag$y_df[,i])
      )
    colnames(yearly.comp[[i]])=c("Ground", "CMORPH", "PERSIANN", "TRMM 3B42")
  }
###

#### RAINDAYS ####
raindays.month=function(x){
  require("hydroTSM")
  # function that outputs raindays:
  if (class(x[[1]]) != "zoo"){x=lapply(x, zoo, order.by=time.d)}
  d.rainday<-lapply(x, function (x) ifelse(x>1, 1, 0))
  m.rainday<-lapply(d.rainday, daily2monthly, sum, na.rm=FALSE)
  m.rainday=mdf(m.rainday, coln=stations_shp$ID)}
  
	# get raindays:
  cmorph.rd=raindays.month(cmorph.ts)
  persiann.rd=raindays.month(persiann.ts)
  trmm.rd=raindays.month(trmm.ts)
  gdata.rd=raindays.month(gdata$d_df)
  
  # combine:    
	raindays.comp=list()
	for (i in names(gdata$m_df))
	{
		raindays.comp[[i]]=
		  (
		    cbind(gdata.rd[,i],cmorph.rd[,i],persiann.rd[,i], trmm.rd[,i])
		  )
		colnames(raindays.comp[[i]])=c("Ground", "CMORPH", "PERSIANN", "TRMM 3B42")
	}
	
	rm(cmorph.rd, persiann.rd, trmm.rd, gdata.rd)
###

#### CLEAN UP ####
# remove variables and data not needed anymore
	rm(i)
	rm(opath, fpath) 
###

###### END aggregate.R ######
