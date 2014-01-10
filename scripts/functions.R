##### Functions for satellite analysis #####


#### mdf ####
## Coerce zoo time series to data frames: mdf (make data frame)#
## x: list of zoo time series objects
## coln: names of column headers, default ist stnames
mdf=function(x, coln=stnames){
  dfr=do.call(cbind, as.data.frame(x))  	# converison
  row.names(dfr)=as.character(time(x[[1]])) 	# only naming: timestep names
  colnames(dfr)=coln	#only naming column names
  return(dfr)
}
###

#### basic.aggregate ####
## creates basic summaries and variables to be analysed
## and outputs summary tables 
## variable names explained in the README
## x: list of zoo TS objects
## fun: mean or sum
## na.rm: TRUE/FALSE, default=TRUE
## opath: output path of file
## stnames: station names == names of column headers

basic.aggregate=function(x, fun, na.rm=FALSE, opath, stnames){
  require("zoo")
  require("hydroTSM")
  
  d_ts=x  
  d_df=mdf(x, coln=stnames)  
  write.csv(d_df, file=paste(opath,"/daily_data.csv", sep=""), na = "NA")

  m_ts <- lapply(x, daily2monthly, fun, na.rm) 
  m_df=mdf(m_ts, coln=stnames)
  write.csv(m_df, file=paste(opath,"/monthly_means.csv", sep=""), na = "NA")
  
  y_ts <- lapply(x, daily2annual, fun, na.rm)
  y_df=mdf(y_ts, coln=stnames)
  write.csv(y_df, file=paste(opath,"/yearly_means.csv", sep=""), na = "NA")
  
  davbm <- lapply(x, monthlyfunction, fun, na.rm)
  davbm_df=mdf(davbm, coln=stnames)
  write.csv(davbm_df, file=paste(opath,"/bymonth_dailymean.csv", sep=""), na = "NA")
    
  output=list(d_ts, d_df, m_ts, m_df, y_ts, y_df, davbm, davbm_df)
  names(output)=c("d_ts", "d_df", "m_ts", "m_df", "y_ts", "y_df", "davbm", "davbm_df")
  return(output)
}

###
