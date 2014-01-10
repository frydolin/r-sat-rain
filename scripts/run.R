###### SATELLITE PRECIPITATION ESTIMATES – ASSESSING FEASABILITY FOR KAPUAS CATCHMENT ######

## run.R executes the analysis ##

# Maybe you need to set the correct correct wd: set.wd() or adjust file path

source("scripts/read.R") 	          ## loads in all the data and converts to appropriate formats ##
source("scripts/extract_values.R")  ## extracts values of station positions and makes time series##
source("scripts/aggregate.R")	      ## creates all necessary summaries and variables to be analysed ##
source("scripts/compare.R")         ## plots comparative summaries to output ##

########## END run.R #############
