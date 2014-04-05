###### SPATIO-TEMPORAL RAINFALL PATTERNS IN KAPUAS BASIN ######
	### ASSESSING USEFULNESS OF SATELLITE PRECIPITATION ESTIMATES ###

## run.R:
## can be used to execute the whole analysis
## takes files in /input, analyzes them and writes the results to /output
## further information can be found in the README file

# Maybe you need to set the correct correct working directory: set.wd() or adjust file paths before analysis
source("scripts/read.R") 	          ## loads in all the data and converts to appropriate formats ##

# PART 1: Point to pixel comparison
source("scripts/extract_values.R")  ## extracts values of station positions and makes time series ##
source("scripts/aggregate.R")	      ## creates all necessary summaries and variables to be analysed ##
source("scripts/compare.R")         ## plots comparative summaries to output ##

# PART 2: Spatial comparison
source("scripts/spatial_aggregate.R")  ## spatially subsets and aggregates data ##
source("scripts/spatial_compare.R")  ## compares spatially aggregated data and interpolation results ##

###### END run.R ######
