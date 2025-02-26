################################################################
###########  LIST OF PACKAGES TO INSTALL  ######################
################################################################

#### System #####
###############################################################
#devtools
install.packages("devtools")
library(devtools)

#installr
#update R
install.packages("installr")


#### Import Data ####
###############################################################

#datapasta
#copy and past data
install.packages("datapasta")

#gapminder
#source of country GDP and life exp data
install.packages("gapminder")

#readr
#fast import of data
install.packages("readr")

#rio
#import data
install.packages("rio")

#vroom
#fast data import
install.packages("vroom")


#### Transform Data ####
#############################################################

#dplyr
#Transforming data
install.packages("dplyr")

#lubridate
#handling dates
install.packages("lubridate")

#magrittr
#Library for the pipe ( %>% )
install.packages("magrittr")

#tidyr
#Rehaping data
install.packages("tidyr")

#tidytext
#text analysis
install.packages("tidytext")

#tidyverse
#data manipulation and graphing
install.packages("tidyverse")

#tigris
#census shapefiles
install.packages("tigris")


#### Statistics ####
##############################################################

#car
#companion to appied regression
install.packages("car")

#gmodels
#confidence intervals for models
install.packages("gmodels")

#Hmisc
#summary statistics
install.packages("Hmisc")

#lme4
#statistical modeling
install.packages("lme4")

#lmtest
#for hetoroskedasticity analysis
install.packages("lmtest")

#plm
#panel data analysis
install.packages("plm")

#prophet
#forcasting
install.packages("prophet")

#summarytools
#summary statistics
install.packages("summarytools")

#tseries
#For timeseries analysis
install.packages("tseries")


#### Visualize Data ####
###################################################################

#dygraphs
#interactive time series graphs
devtools::install_github(c("ramnathv/htmlwidgets", "rstudio/dygraphs"))

#esquisee
 #explore data interactively
install.packages("esquisse")

#gganimate
 #fun animations
install.packages("gganimate")

#ggbeeswarm
 #fun plots
install.packages("ggbeeswarm")

#ggiraph
 #animate ggplots
install.packages("ggiraph")

#ggpubr
 #publication ready ggplot2 plots
install.packages("ggpubr")

#ggridges
 #fun plots
install.packages("ggridges")

#ggvis
 #visualize data with interactivve graphics in Rstudio
install.packages("ggvis")

#gifski
 #turn plot into gif
install.packages("gifski")

#gplots
 #various tools for plotting data
install.packages("gplots")

#RColorBrewer
 #color palettes
install.packages("RColorBrewer")

#shiny
 #web applications
install.packages("shiny")

#sjPlot
 #plotting and table outputs of various statistical analysis
install.packages("sjPlot")

#taucharts
 #javascript charts for data exploration
install.packages("taucharts")

#tvthemes
 #themes based on tv shows
devtools::install_github("Ryo-N7/tvthemes")

#wesanderson
 #wes anderson colors
install.packages("wesanderson")