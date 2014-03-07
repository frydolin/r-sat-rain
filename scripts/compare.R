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
# For daly data
  png(filename="output/daily_allscatterplots.png", pointsize = 11, width=10, height=20, units="cm", res=300)
 scatter.grid(daily.comp, xylim=c(0,120))
  dev.off()
# For monthly data
  png(filename="output/monthly_allscatterplots.png", pointsize = 11, width=10, height=20, units="cm", res=300)
 scatter.grid(monthly.comp, xylim=c(0,24))
  dev.off()
# yearly data
  png(filename="output/yearly_allscatterplots.png", pointsize = 11, width=10, height=20, units="cm", res=300)
 scatter.grid(yearly.comp, xylim=c(4,14))
  dev.off()
###

plot(daily.comp[1][[1]][2,], type="l")
str(daily.comp[[1]][1,])
class(daily.comp[[1]])
########## END compare.R #############
