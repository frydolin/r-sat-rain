#### Spatial Comparison ####

library("hydroTSM")
source("scripts//functions.R")
#### PART I COMPARE WITH INTERPOLATED CATCHMENT TOTALS####
  #### Read in interpolated data ####
  #daily
    idw.d=read.csv("input/interpoaltion_results//subcatch_d_idw.csv")
    idw.d_ts=list(zoo(idw.d$PTayan, order.by=time.d),zoo(idw.d$PSekayam, order.by=time.d),zoo(idw.d$PBelitang, order.by=time.d) )
    names(idw.d_ts)=c("Tayan", "Sekayam", "Belitang")
  #monthly
    idw.m=read.csv("input/interpoaltion_results//subcatch_m_idw.csv")
    idw.m_ts=list(zoo(idw.m$PTayan, order.by=time.m),zoo(idw.m$PSekayam, order.by=time.m),zoo(idw.m$PBelitang, order.by=time.m) )
    names(idw.m_ts)=c("Tayan", "Sekayam", "Belitang")
  
  # aggregate to yearly
    idw.y_ts=lapply(idw.m_ts, monthly2annual, mean)
  
  ## Comparative plots
  fpath="output/spatial_compare"
  dir.create(fpath)
  # Daily
  daily.sp.comp=list()
    for (i in 1:length(idw.d_ts)){
      daily.sp.comp[[i]]=cbind(idw.d_ts[[i]],cmorph.sp.d_ts[[i]], persiann.sp.d_ts[[i]], trmm.sp.d_ts[[i]])}
  names(daily.sp.comp)=names(idw.d_ts)
  
    png(filename=paste(fpath,"/daily_sp_scatterplot.png", sep=""), pointsize = 11, width=16, height=15, units="cm", res=300)
    scatter.grid(daily.sp.comp, xylim=c(0,100), leftsidetext="IDW interpolation (mm/day)")
    dev.off()
  
  # Monthly
    monthly.sp.comp=list()
    for (i in 1:length(idw.d_ts)){
      monthly.sp.comp[[i]]=cbind(idw.m_ts[[i]],cmorph.sp.m_ts[[i]], persiann.sp.m_ts[[i]], trmm.sp.m_ts[[i]])}
    names(monthly.sp.comp)=names(idw.d_ts)
    
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
  #### Correlation Coefficients ####
  fpath="output/spatial_compare"
  write.csv(pairw.corr(daily.sp.comp), file=paste(fpath,"/daily_cor.csv", sep=""))
  write.csv(pairw.corr(monthly.sp.comp), file=paste(fpath,"/monthly_cor.csv", sep=""))
  write.csv(pairw.corr(yearly.sp.comp), file=paste(fpath,"/yearly_cor.csv", sep=""))
  ###
### END PART I ###
#### PART II: COMPARE ON PIXEL LEVEL ####
library("rasterVis")
source("scripts//graphic_pars.R")
## Load interpolation data
  load(file="input//interpolation_results/subcatch.idw.bymonth")
  load(file="input//interpolation_results/subcatch.idw.ov.av")
  #change extents to match the ones of the satellite imagery
  subcatch.idw.bymonth=extend(x=subcatch.idw.bymonth, y=extnt)
  subcatch.idw.ov.av=extend(x=subcatch.idw.ov.av, y=extnt)
##
lapply(subcatch.srfe.ov.av, function(x) cellStats(x@raster, max))
##
# Plot December values
  fpath="output/spatial_compare/month"
  dir.create(fpath)
scaling <- seq(8.8, 15.2, 0.2)
  name=paste(fpath,"/dec_idw.svg", sep="")
  svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
    levelplot(subcatch.idw.bymonth[[12]], par.settings=rast.theme,  at=scaling, margin=FALSE)+ layer(sp.polygons(obj=subcatch_shp, lwd=0.5, col="#777777"))+layer(sp.polygons(kapuas_shp, lwd=0.5, col="#333333"))+ layer(sp.points(stations_shp, col="black", cex=0.5))+ layer(sp.pointLabel(stations_shp, label=stations_shp$ID),theme=label.theme)
dev.off()
name=paste(fpath,"/dec_cmorph.svg", sep="")
svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
    levelplot(subcatch.srfe.bymonth[[1]][[12]], par.settings=rast.theme, at=scaling, margin=FALSE)+ layer(sp.polygons(obj=subcatch_shp, lwd=0.5, col="#777777"))+layer(sp.polygons(kapuas_shp, lwd=0.5, col="#333333"))+ layer(sp.points(stations_shp, col="black", cex=0.5))+ layer(sp.pointLabel(stations_shp, label=stations_shp$ID),theme=label.theme)
dev.off()
name=paste(fpath,"/dec_persiann.svg", sep="")
svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
    levelplot(subcatch.srfe.bymonth[[2]][[12]], par.settings=rast.theme, at=scaling, margin=FALSE)+ layer(sp.polygons(obj=subcatch_shp, lwd=0.5, col="#777777"))+layer(sp.polygons(kapuas_shp, lwd=0.5, col="#333333"))+ layer(sp.points(stations_shp, col="black", cex=0.5))+ layer(sp.pointLabel(stations_shp, label=stations_shp$ID),theme=label.theme)
dev.off()
name=paste(fpath,"/dec_trmm3b42.svg", sep="")
svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
    levelplot(subcatch.srfe.bymonth[[3]][[12]], par.settings=rast.theme, at=scaling, margin=FALSE)+ layer(sp.polygons(obj=subcatch_shp, lwd=0.5, col="#777777"))+layer(sp.polygons(kapuas_shp, lwd=0.5, col="#333333"))+ layer(sp.points(stations_shp, col="black", cex=0.5))+ layer(sp.pointLabel(stations_shp, label=stations_shp$ID),theme=label.theme)
dev.off()

# Plot long term average
scaling <- seq(7.4, 11.6, 0.2)
fpath="output/spatial_compare/lta"
dir.create(fpath)
name=paste(fpath,"/lta_idw.svg", sep="")
svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
levelplot(subcatch.idw.ov.av@raster, par.settings=rast.theme,  at=scaling, margin=FALSE)+ layer(sp.polygons(obj=subcatch_shp, lwd=0.5, col="#777777"))+layer(sp.polygons(kapuas_shp, lwd=0.5, col="#333333"))+ layer(sp.points(stations_shp, col="black", cex=0.5))+ layer(sp.pointLabel(stations_shp, label=stations_shp$ID),theme=label.theme)
dev.off()
name=paste(fpath,"/lta_cmorph.svg", sep="")
svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
levelplot(subcatch.srfe.ov.av[[1]]@raster, par.settings=rast.theme, at=scaling, margin=FALSE)+ layer(sp.polygons(obj=subcatch_shp, lwd=0.5, col="#777777"))+layer(sp.polygons(kapuas_shp, lwd=0.5, col="#333333"))+ layer(sp.points(stations_shp, col="black", cex=0.5))+ layer(sp.pointLabel(stations_shp, label=stations_shp$ID),theme=label.theme)
dev.off()
name=paste(fpath,"/lta_persiann.svg", sep="")
svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
levelplot(subcatch.srfe.ov.av[[2]]@raster, par.settings=rast.theme, at=scaling, margin=FALSE)+ layer(sp.polygons(obj=subcatch_shp, lwd=0.5, col="#777777"))+layer(sp.polygons(kapuas_shp, lwd=0.5, col="#333333"))+ layer(sp.points(stations_shp, col="black", cex=0.5))+ layer(sp.pointLabel(stations_shp, label=stations_shp$ID),theme=label.theme)
dev.off()
name=paste(fpath,"/lta_trmm3b42.svg", sep="")
svg(filename=name, pointsize = 11, width=8, height=7, family="Lato")
levelplot(subcatch.srfe.ov.av[[3]]@raster, par.settings=rast.theme, at=scaling, margin=FALSE)+ layer(sp.polygons(obj=subcatch_shp, lwd=0.5, col="#777777"))+layer(sp.polygons(kapuas_shp, lwd=0.5, col="#333333"))+ layer(sp.points(stations_shp, col="black", cex=0.5))+ layer(sp.pointLabel(stations_shp, label=stations_shp$ID),theme=label.theme)
dev.off()
#### END ####
library("sp")
library("maptools")
library("rgeos")
library("raster")

projection=CRS(projection(cmorph))
catchment_shp  <-readShapePoly(fn="input/Kapuas_catchment//Kapuas-catchment2.shp", proj4string=projection)
extent=extent(catchment_shp)
crop.cmorph=crop(cmorph, extent)
    plot(crop.cmorph[[4]])
    ncol(crop.cmorph[[4]])
    nrow(crop.cmorph[[4]])
# divide each cell into 25 cells so as to go from 0.25° to 0.05°
da.cmorph=disaggregate(crop.cmorph, fact=5) 
    plot(da.cmorph[[4]])
    ncol(da.cmorph[[4]])
    nrow(da.cmorph[[4]])
masked.cmorph=mask(da.cmorph, catchment_shp)
    plot(masked.cmorph[[10]])
    plot(catchment_shp, add=TRUE)
    str(masked.cmorph)

s1=cellStats(masked.cmorph[[4]],stat=sum)
s2=sum(masked.cmorph[[4:5]])
plot(s2-masked.cmorph[[4]])
s3=cellStats(masked.cmorph[[5]],stat=sum)
s4=cellStats(s2,stat=sum)
s1+s3
s4
