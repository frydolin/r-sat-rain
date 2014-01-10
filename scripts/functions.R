######### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## functions.R contains self written functions for the analysis ##

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
## x: list of zoo TS objects with daily or monthly time step
## fun: mean or sum
## na.rm: TRUE/FALSE, default=FALSE
## opath: output path of file
## stnames: station names == names of column headers

basic.aggregate=function(x, fun, na.rm=FALSE, opath, stnames){
  require("zoo")
  require("hydroTSM")
  if (!(sfreq(x[[1]]) %in% c("daily", "monthly"))){
    stop("Invalid argument: 'x' is not a daily or monthly time series ")
  }
  
  if (sfreq(x[[1]])=="daily"){
  d_ts=x  
  d_df=mdf(x, coln=stnames)  
  write.csv(d_df, file=paste(opath,"/daily_data.csv", sep=""), na = "NA")
  } else{d_ts=NA; d_df=NA}
  
  if (sfreq(x[[1]])=="daily"){
  m_ts <- lapply(x, daily2monthly, fun, na.rm)}
  else if (sfreq(x[[1]])=="monthly"){
    m_ts <-x } 
    else{m_ts=NA; d_df=NA}
  
  m_df=mdf(m_ts, coln=stnames)
  write.csv(m_df, file=paste(opath,"/monthly_means.csv", sep=""), na = "NA")
  
  if (sfreq(x[[1]])=="daily"){
  y_ts <- lapply(x, daily2annual, fun, na.rm)}
  else 
    if (sfreq(x[[1]])=="monthly"){
    y_ts <- lapply(x, monthly2annual, fun, na.rm)} 
    else{y_ts=NA; y_df=NA}
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
