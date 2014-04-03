###### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## compare.R compares satellite and ground data on point to pixel##
#### SET UP ####
  source("scripts/graphic_pars.R")
  source("scripts/functions.R")
  fpath="output/point-to-pixel"
  dir.create(fpath)

# get maxes and mins to sed xylim
# max(unlist(lapply(monthly.comp,max, na.rm=TRUE)))
# min(unlist(lapply(monthly.comp,min, na.rm=TRUE)))

#### CORRELOGRAMS ####
# -> 1 example in main text, rest DA
fpath="output/point-to-pixel/correlograms"
dir.create(fpath)
  
  for (i in 1:length(daily.comp))
  {
  stname=names(daily.comp)[i]
  sat.corgr(daily.comp[[i]], xylim=c(0,160), type="daily", fpath=fpath, station=stname)
  sat.corgr(monthly.comp[[i]], xylim=c(0,25),type="monthly", fpath=fpath, station=stname)
  #if (i==2) next # skip problem child: yearly.comp[[2]] because so much NA in the ground data
  sat.corgr(yearly.comp[[i]], xylim=c(4.5,14), type="yearly", fpath=fpath, station=stname)
  }
rm(fpath, i, stname)
### END CORRGRAMS ###

#### SCATTERPLOT MATRIX ####
fpath="output/point-to-pixel/scatterplotmatrix"
dir.create(fpath)

  for (i in 1:length(daily.comp))
  {
    stname=names(daily.comp)[i]
    sat.scatterMatrix(daily.comp[[i]], xylim=c(0,160), type="daily", 
                      fpath=fpath, station=stname)
    sat.scatterMatrix(monthly.comp[[i]], xylim=c(0,25),type="monthly", 
                      fpath=fpath, station=stname)
    sat.scatterMatrix(yearly.comp[[i]], xylim=c(4.5,14), type="yearly", 
                      fpath=fpath,station=stname) 
  }
rm(fpath, i)
### END SCATTERPLOT MATRIX ###

#### SCATTERPLOT OVERVIEW PER SRFE ####
fpath="output/point-to-pixel/scattergrids"
dir.create(fpath)
# For daly data
  png(filename=paste(fpath,"/daily_allscatterplots.png", sep=""), pointsize = 11, width=9, height=23, units="cm", res=300)
 scatter.grid(daily.comp, xylim=c(0,160))
  dev.off()
# For monthly data
  png(filename=paste(fpath,"/monthly_allscatterplots.png", sep=""), pointsize = 11, width=9, height=23, units="cm", res=300)
 scatter.grid(monthly.comp, xylim=c(0,25))
  dev.off()
# yearly data
  png(filename=paste(fpath,"/yearly_allscatterplots.png", sep=""), pointsize = 11, width=9, height=23, units="cm", res=300)
 scatter.grid(yearly.comp, xylim=c(4.5,14))
  dev.off()

#raindays
png(filename=paste(fpath,"/monthly_raindays_allscatterplots.png", sep=""), pointsize = 11, width=9, height=23, units="cm", res=300)
scatter.grid(raindays.comp, xylim=c(0,31), leftsidetext="No. of raindays at gauge station", bottomtext="No. of raindays of satellite rainfall estimate")
dev.off()
###

#### PEARSON CORRELATION PER SRFE ####
fpath="output/point-to-pixel/scattergrids"
  write.csv(pairw.corr(daily.comp), file=paste(fpath,"/daily_cor.csv", sep=""))
  write.csv(pairw.corr(monthly.comp), file=paste(fpath,"/monthly_cor.csv", sep=""))
  write.csv(pairw.corr(yearly.comp), file=paste(fpath,"/yearly_cor.csv", sep=""))
###

rm(fpath, stname)
########## END compare.R #############
