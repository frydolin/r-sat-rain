###### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## compare.R compares satellite and ground data ##
source("scripts/graphic_pars.R")
#### CORRELATION ####
fpath="output/correlation"
dir.create(fpath)
#### CORRELOGRAMS ####
fpath="output/correlation/correlograms"
dir.create(fpath)
  
  for (i in 1:length(daily.comp))
  {
  stname=names(daily.comp)[i]
  sat.corgr(daily.comp[[i]], type="daily", fpath=fpath, station=stname)
  sat.corgr(monthly.comp[[i]], type="monthly", fpath=fpath, station=stname)
  #if (i==2) next # skip problem child: yearly.comp[[2]] because so much NA in the ground data
  sat.corgr(yearly.comp[[i]], type="yearly", fpath=fpath, station=stname)
  }
rm(fpath, i, stname)
### END CORRGRAMS ###

#### SCATTERPLOT MATRIX ####
fpath="output/correlation/scatterplotmatrix"
dir.create(fpath)
for (i in 1:length(daily.comp))
{
  stname=names(daily.comp)[i]
  sat.scatterMatrix(daily.comp[[i]], xylim=c(0,150), type="daily", 
                    fpath=fpath, station=stname)
  sat.scatterMatrix(monthly.comp[[i]], xylim=c(0,25),type="monthly", 
                    fpath=fpath, station=stname)
  sat.scatterMatrix(yearly.comp[[i]], xylim=c(0,20), type="yearly", 
                    fpath=fpath,station=stname) 
}
dev.off()
rm(fpath, i)
### END SCATTERPLOT MATRIX ###
### END CORRELATION###
#### OVERVIEW PER SRFE ####
# For monthly data
xylim=c(0,22)
png(filename="output/monthly_allscatterplots.png", pointsize = 11, width=10, height=20, units="cm", res=300)
par(def.par);par(mar=c(0,0,0.2,0.2), oma=c(2,3.5,2.5,0), las=1); par(mfrow=c(length(monthly.comp),3))
for (i in 1:(length(monthly.comp))){
    if (i==length(monthly.comp)){ax="s"} else {ax="n"}
      plot(monthly.comp[i][[1]][,1]~monthly.comp[i][[1]][,2], xlim=xylim, ylim=xylim, xaxt=ax)
  abline(0,1, col="red")
  plot(monthly.comp[i][[1]][,1]~monthly.comp[i][[1]][,3], xlim=xylim, ylim=xylim, yaxt="n", xaxt=ax)
  abline(0,1, col="red")
  plot(monthly.comp[i][[1]][,1]~monthly.comp[i][[1]][,4], xlim=xylim, ylim=xylim, yaxt="n", xaxt=ax)
  abline(0,1, col="red")
}
dev.off()
###

########## END compare.R #############
