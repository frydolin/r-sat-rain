###### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## compare.R compares satellite and ground data ##

#### CORRELATION ####
fpath="output/correlation"
dir.create(fpath)
#### CORRELOGRAMS ####
fpath="output/correlation/correlograms"
dir.create(fpath)
  
  for (i in 1:length(daily.comp))
  {
  stname=names(daily.comp)[8]
  sat.corgr(daily.comp[[i]], type="daily", fpath=fpath, station=stname)
  sat.corgr(monthly.comp[[i]], type="monthly", fpath=fpath, station=stname)
  if (i==2) next # skip problem child: yearly.comp[[2]] because so much NA in the ground data
  sat.corgr(yearly.comp[[i]], type="yearly", fpath=fpath, station=stname)
  }

dev.off()
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

########## END compare.R #############
