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
####

#### panel.2lines function ####
# creates lines as input for a scatterplotmatrix
# lm regression
# 0,1 abline
panel.2lines <- function(x,y,...) {
  points(y~x, cex=0.7)
  abline(0,1,col="blue")
  abline(lm(y~x),col="red")
  box(col = "lightgray")
}
###
#### corgr ####
# own version of correlograms made by corrgram
# corgr creates *.svg files in fpath
## make sure directory exists!
## x: should be a data matrix (as in the normal corrgram() function)
## type: is only for naming e.g. daily, monthly 
sat.corgr=function(x, type, xylim, fpath, station){
  require("corrgram")
  name=paste(fpath,"/",type,"_corgr_",station,".png", sep ="")  # filename
  png(filename=name, pointsize = 11, width=16, height=16, units="cm", res=300)	# open *.png write
  corrgram(x, lower.panel=panel.pie, upper.panel=panel.2lines, diag.panel=panel.density, xlim=xylim, ylim=xylim, main="", oma=c(0,0,0,0))
  dev.off() #close write
}
###
#### Scatterplot Matrix ####
## x: should be a data matrix (as in the normal corrgram() function)
## type: is only for naming e.g. daily, monthly 
sat.scatterMatrix=function(x, xylim, type, fpath, station){
  name=paste(fpath,"/",type,"_scatter_",station,".png", sep ="")  # filename
  png(filename=name, pointsize = 11, width=16, height=16, units="cm", res=300) # open *.png write
  pairs(x, upper.panel=NULL, lower.panel=panel.2lines, xlim=xylim, ylim=xylim, 
        las=1, gap=0.3, oma=c(2.5,2.5,0,0), cex.labels=1.5, family="Lato"
  )
  dev.off()  # close write			# close write
}
###
#### scatter.grid####
scatter.grid=function(x,xylim, leftsidetext="rainfall at gauge station (mm/day)"){
  
  source("scripts//graphic_pars.R")
  par(def.par);
  par(mar=c(0,0,0.3,0.3), oma=c(5,7.7,1.5,0), las=1); par(mfrow=c(length(x),3));
  par(cex.axis=1,  cex.lab=1)

  for (i in 1:(length(x))){
    if (i==length(x)){ax="s"} else {ax="n"}
    plot(x[[i]][,1]~x[[i]][,2], xlim=xylim, ylim=xylim, xaxt=ax, cex=0.8)
    if(i==1){mtext("CMORPH", side = 3, line = 0.2, cex=0.8)}
    abline(0,1, col="#444444")
    abline(lm(x[[i]][,1]~x[[i]][,2]),col="#aaaaaa")
    mtext(names(x[i]), side = 2, line = 1.8, cex=0.8)
    plot(x[[i]][,1]~x[[i]][,3], xlim=xylim, ylim=xylim, yaxt="n", xaxt=ax, cex=0.8)
    if(i==1){mtext("PERSIANN", side = 3, line = 0.2, cex=0.8)}
    abline(0,1, col="#444444")
    abline(lm(x[[i]][,1]~x[[i]][,3]),col="#aaaaaa")
    plot(x[[i]][,1]~x[[i]][,4], xlim=xylim, ylim=xylim, yaxt="n", xaxt=ax, cex=0.8)
    if(i==1){mtext("TRMM 3B42", side = 3, line = 0.2, cex=0.8)}
    abline(0,1, col="#444444")
    abline(lm(x[[i]][,1]~x[[i]][,4]),col="#aaaaaa")
  }
  mtext(leftsidetext, side = 2, line = 6.5, cex=0.8, las=0, outer = TRUE, at = NA,  adj = 0.5, padj = 0.5)
  mtext("satellite rainfall estimate (mm/day)", side = 1, line =2, cex=0.8, outer = TRUE, adj = 0.5, padj = 0.5)
}
###
#### pairw.corr ####
## x: list of matrices
## in that matrix first row is compared to other rows
pairw.corr=function(x){ 
   corrs=matrix(data=NA,nrow=3, ncol=length(x))
  for(i in 1:length(x)){
  cmorph.cor=round(cor(x[[i]][,1],x[[i]][,2], use="pairwise.complete.obs", method="pearson"), digits=4)
  persiann.cor=round(cor(x[[i]][,1],x[[i]][,3], use="pairwise.complete.obs", method="pearson"), digits=4)
  trmm.cor=round(cor(x[[i]][,1],x[[i]][,4], use="pairwise.complete.obs", method="pearson"), digits=4)
  corrs[,i]=rbind(cmorph.cor, persiann.cor, trmm.cor)
  }
  dimnames(corrs)=list(c("CMORPH", "PERSIANN", "TRMM 3B42"),c(names(x)))
  return(corrs)
}

#### own version of levelplot with layers ####
 llplot=function(x, ...){
   require("rasterVis")
   require("maptools")
   source("scripts//graphic_pars.R")
  levelplot(x, par.settings=rast.theme, margin=FALSE, ...)+ layer(sp.polygons(obj=subcatch_shp, lwd=0.5, col="#555555"))+layer(sp.polygons(kapuas_shp, lwd=0.5, col="#222222"))+ layer(sp.points(stations_shp, col="black", cex=0.5))+ layer(sp.pointLabel(stations_shp, label=stations_shp$ID),theme=label.theme)
}
#### END functions.R ####
