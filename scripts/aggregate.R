######### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## aggregate.R creates all necessary summaries and variables to be analysed
## and outputs summary tables 
## see README for variable naming convention 

## aggregation with mean i.e. output is average daily rainfall per week, month, year, ... ##
## and also sums ##
## na.rm currently FALSE 

#### AGGREGATION ####
#cmorph
  opath="output/cmorph"
  dir.create(opath)
  cmorph.ag=basic.aggregate(cmorph.ts, fun=mean, opath=opath, 
                            stnames=stations$ID)
#persiann

#trmm3b43
  opath="output/trmm3b43"
  dir.create(opath)
  trmm3b43.ag=basic.aggregate(trmm3b43.ts, fun=mean, opath=opath, 
                            stnames=stations$ID)
View(trmm3b43.ag$davbm_df)
########## END aggregate.R #############
