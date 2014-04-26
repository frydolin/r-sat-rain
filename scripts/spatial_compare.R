###### SPATIO-TEMPORAL RAINFALL PATTERNS IN KAPUAS BASIN ######
	### ASSESSING USEFULNESS OF SATELLITE PRECIPITATION ESTIMATES ###
	### SPATIAL COMPARISON ####

#### SET UP ####
  library("hydroTSM")
  source("scripts//functions.R")
  
  fpath="output/spatial_comparison"
  dir.create(fpath)
###

#### PART I COMPARE WITH INTERPOLATED CATCHMENT TOTALS####
  #### Read in interpolated data ####
  # daily
    idw.d=read.csv("input/interpolation_results//subcatch_d_idw.csv")
    idw.d_ts=list(zoo(idw.d$PTayan, order.by=time.d),zoo(idw.d$PSekayam, order.by=time.d),zoo(idw.d$PBelitang, order.by=time.d) )
    names(idw.d_ts)=c("Tayan", "Sekayam", "Belitang")
  # monthly
    idw.m=read.csv("input/interpolation_results//subcatch_m_idw.csv")
    idw.m_ts=list(zoo(idw.m$PTayan, order.by=time.m),zoo(idw.m$PSekayam, order.by=time.m),zoo(idw.m$PBelitang, order.by=time.m) )
    names(idw.m_ts)=c("Tayan", "Sekayam", "Belitang")
  # aggregate monthly to yearly
    idw.y_ts=lapply(idw.m_ts, monthly2annual, mean)
  ###
  
  #### COMPARATIVE SCATTERPLOTS ####
  # with scatter.grid function
  fpath="output/spatial_comparison/correlation"
  dir.create(fpath)
  # Daily
    # make appropriate data structure:
      daily.sp.comp=list()
        for (i in 1:length(idw.d_ts)){
          daily.sp.comp[[i]]=cbind(idw.d_ts[[i]],cmorph.sp.d_ts[[i]], persiann.sp.d_ts[[i]], trmm.sp.d_ts[[i]])}
      names(daily.sp.comp)=names(idw.d_ts)
    # plot
    png(filename=paste(fpath,"/daily_sp_scatterplot.png", sep=""), pointsize = 11, width=16, height=15, units="cm", res=300)
    scatter.grid(daily.sp.comp, xylim=c(0,100), leftsidetext="IDW interpolation (mm/day)")
    dev.off() 
  # Monthly
    # make appropriate data structure:
    monthly.sp.comp=list()
    for (i in 1:length(idw.d_ts)){
      monthly.sp.comp[[i]]=cbind(idw.m_ts[[i]],cmorph.sp.m_ts[[i]], persiann.sp.m_ts[[i]], trmm.sp.m_ts[[i]])}
    names(monthly.sp.comp)=names(idw.m_ts)
    # plot
    png(filename=paste(fpath,"/monthly_sp_scatterplot.png", sep=""), pointsize = 11, width=16, height=15, units="cm", res=300)
    scatter.grid(monthly.sp.comp, xylim=c(0,22), leftsidetext="IDW interpolation (mm/day)")
    dev.off()
  # Yearly
    yearly.sp.comp=list()
    for (i in 1:length(idw.d_ts)){
      yearly.sp.comp[[i]]=cbind(idw.y_ts[[i]],cmorph.sp.y_ts[[i]], persiann.sp.y_ts[[i]], trmm.sp.y_ts[[i]])}
    names(yearly.sp.comp)=names(idw.d_ts)
    png(filename=paste(fpath,"/yearly_sp_scatterplot.png", sep=""), pointsize = 11, width=16, height=15, units="cm", res=300)
    scatter.grid(yearly.sp.comp, xylim=c(6,13), leftsidetext="IDW interpolation (mm/day)")
    dev.off()
  ###

  #### PEARSON CORRELATION COEFFICIENTS ####
  write.csv(pairw.corr(daily.sp.comp), file=paste(fpath,"/daily_cor.csv", sep=""))
  write.csv(pairw.corr(monthly.sp.comp), file=paste(fpath,"/monthly_cor.csv", sep=""))
  write.csv(pairw.corr(yearly.sp.comp), file=paste(fpath,"/yearly_cor.csv", sep=""))
  ###
rm(fpath)
### END PART I ###

#### PART II: COMPARE ON MAP LEVEL ####
	#### Load interpolation data ####
  load(file="input//interpolation_results/subcatch.idw.bymonth")
  load(file="input//interpolation_results/subcatch.idw.ov.av")
  # change extents to match the ones of the satellite imagery
  subcatch.idw.bymonth=extend(x=subcatch.idw.bymonth, y=extnt) # a warning appears, still a correct result is obtained
  subcatch.idw.ov.av=extend(x=subcatch.idw.ov.av@raster, y=extnt)
	###
	
	#### PLOT MONTHLY VALUES OF PEAK RAINY AND PEAK DRY SEASON ####
	fpath="output/spatial_comparison/months"
	dir.create(fpath)
#		## appropirate scaling
#   levelplot(... at=scaling,...)
#   lapply(subcatch.srfe.bymonth, function(x) cellStats(x, max))
#   cellStats(subcatch.idw.bymonth[[11]], min)
#   lapply(subcatch.srfe.bymonth, function(x) cellStats(x[[8]], max))
#   cellStats(subcatch.idw.bymonth[[8]], max)
		scaling <- seq(2.9, 13.6, (2/3))
	# Plot January values  
	name=paste(fpath,"/nov_idw.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.idw.bymonth[[11]], at=scaling)
		dev.off()
	name=paste(fpath,"/nov_cmorph.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.srfe.bymonth[[1]][[11]], at=scaling)
	dev.off()
	name=paste(fpath,"/nov_persiann.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		    llplot(subcatch.srfe.bymonth[[2]][[11]],at=scaling)
	dev.off()
	name=paste(fpath,"/nov_trmm3b42.svg", sep="")
	svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.srfe.bymonth[[3]][[11]],at=scaling)
	dev.off()
	# Plot August values
	name=paste(fpath,"/aug_idw.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.idw.bymonth[[8]],at=scaling)
	dev.off()
	name=paste(fpath,"/aug_cmorph.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.srfe.bymonth[[1]][[8]],at=scaling)
	dev.off()
	name=paste(fpath,"/aug_persiann.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.srfe.bymonth[[2]][[8]],at=scaling)
	dev.off()
	name=paste(fpath,"/aug_trmm3b42.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.srfe.bymonth[[3]][[8]],at=scaling)
	dev.off()
	###

	#### PLOT LONG TERM MEANS ###
	fpath="output/spatial_comparison/long-term-average"
	dir.create(fpath)
#		## appropirate scaling
#   lapply(subcatch.srfe.ov.av, function(x) cellStats(x@raster, max))
#   cellStats(subcatch.idw.ov.av, min)
  scaling <- seq(7.3, 11.5, 0.2)
  # Plot
	name=paste(fpath,"/lta_idw.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.idw.ov.av, at=scaling)
	dev.off()
	name=paste(fpath,"/lta_cmorph.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.srfe.ov.av[[1]]@raster, at=scaling)
	dev.off()
	name=paste(fpath,"/lta_persiann.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.srfe.ov.av[[2]]@raster, at=scaling)
	dev.off()
	name=paste(fpath,"/lta_trmm3b42.svg", sep="")
		svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
		  llplot(subcatch.srfe.ov.av[[3]]@raster, at=scaling)
	dev.off()
	###
### END PART II ###

#### CLEAN UP ####
rm(fpath, name)
rm(i)
rm(scaling)
###
###### END spatial_compare.R ######
