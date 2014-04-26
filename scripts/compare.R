###### SPATIO-TEMPORAL RAINFALL PATTERNS IN KAPUAS BASIN ######
	### ASSESSING USEFULNESS OF SATELLITE PRECIPITATION ESTIMATES ###

## compare.R:
## compares satellite and ground data on point to pixel level
## check functions.R in order to get details about the functions used

#### SET UP ####
  source("scripts/graphic_pars.R")
  source("scripts/functions.R")

  fpath="output/point-to-pixel_comparison"
  dir.create(fpath)
# get maxes and mins to set xylims corrrectly
# max(unlist(lapply(monthly.comp,max, na.rm=TRUE)))
# min(unlist(lapply(monthly.comp,min, na.rm=TRUE)))
###

#### CORRELOGRAMS ####
  fpath="output/point-to-pixel_comparison/correlograms"
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

#### SCATTERPLOT MATRICES ####
fpath="output/point-to-pixel_comparison/scatterplotmatrices"
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

#### SCATTERPLOTS GIVING AN OVERVIEW PER SRFE ####
fpath="output/point-to-pixel_comparison/scattergrids"
dir.create(fpath)
# For daly data
  png(filename=paste(fpath,"/daily_scatterplots.png", sep=""), pointsize = 11, width=9, height=23, units="cm", res=300)
 scatter.grid(daily.comp, xylim=c(0,160))
  dev.off()
# For monthly data
  png(filename=paste(fpath,"/monthly_scatterplots.png", sep=""), pointsize = 11, width=9, height=23, units="cm", res=300)
 scatter.grid(monthly.comp, xylim=c(0,25))
  dev.off()
# yearly data
  png(filename=paste(fpath,"/yearly_scatterplots.png", sep=""), pointsize = 11, width=9, height=23, units="cm", res=300)
 scatter.grid(yearly.comp, xylim=c(4.5,14))
  dev.off()

# raindays
	png(filename=paste(fpath,"/monthly_raindays_scatterplots.png", sep=""), pointsize = 11, width=9, height=23, units="cm", res=300)
	scatter.grid(raindays.comp, xylim=c(0,31), leftsidetext="No. of raindays at gauge station", bottomtext="No. of raindays of satellite rainfall estimate")
	dev.off()
###

#### PEARSON CORRELATION COEFFICIENTS PER SRFE ####
fpath="output/point-to-pixel_comparison/"
  write.csv(pairw.corr(daily.comp), file=paste(fpath,"/daily_cor_coef.csv", sep=""))
  write.csv(pairw.corr(monthly.comp), file=paste(fpath,"/monthly_cor_coef.csv", sep=""))
  write.csv(pairw.corr(yearly.comp), file=paste(fpath,"/yearly_cor_coef.csv", sep=""))
###

#### CLEAN UP ####
rm(fpath, stname)
###

###### END compare.R ######
