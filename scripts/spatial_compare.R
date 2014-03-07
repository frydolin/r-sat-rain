#### Spatial Comparison ####

#### COMPARE WITH INTERPOLATED CATCHMENT TOTALS####
## Read in interpolated data
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
