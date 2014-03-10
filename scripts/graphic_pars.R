###### SPATIO-TEMPORAL RAINFALL PATTERNS IN KAPUAS BASIN ######
### Analysis and comparison of station data ###

## graphic_par.R sets graphic paramters

#### default ####
#dev.off()
par(family="Lato",
    mar=(c(4,4,3,0)+0.2),
    mgp=c(1.8,0.6,0))
def.par=par(no.readonly = TRUE)
#### COLOR SCHEME for plots ####
  col.fun <- colorRampPalette(c("#af5752","peachpuff","royalblue","#0f1c66"))
  rast.cols=col.fun(20)
  require("rasterVis")
  rast.theme<-rasterTheme(region=rast.cols, cex=0.8)
  label.theme <- list(add.text=list(cex=0.9,fontfamily='Lato'))


# For 14 colors
colors=rainbow(n=14, s = 1, v = 0.8, start = 0.05, end = max(1, 14 - 1)/14, alpha = 1)
#   pal((colors))
#   pal((desaturate(colors)))

# For statistical analysis
#   colors=colors[c(-3,-8,-9,-11,-13,-14)]
# For spatial interpolation
   colors=colors[c(-8,-9,-13)]
###
### END graphic_pars.R ###
