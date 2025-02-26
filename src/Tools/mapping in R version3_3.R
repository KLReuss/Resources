################################# #################################
### basics in R   #First introduction
### this code shows a sample R job to give you sense of what R  code looks like and what it can do
### we will build some fluency in what this code is and why it works over the next few sessions
################################# #################################

# this will ensure that the necessary packages this session are available, and if not, will find and load them directly
list.of.packages <- c("Hmisc", "maps", "matools", "sp", "rgdal", "rcurl", "RJSONIO", "plyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# clean up
rm(list.of.packages, new.packages)


rm(list = ls())
dev.off()
# some basic commands to demonstrate how R works and to learn the 
# layout of R studio and become familiar with it's features
# this focuses on a typical task you might need to do in R here at DOL

# set working directory, import data, find type

setwd("~/learn/basicr/")

# import data : check environment box, upper right

mydata <- read.csv("county centroids.csv")

# Categorizing data
#Michigan Counties
michigan<-mydata[mydata$State=='MI',]
michigan$popcat<-as.numeric(cut(michigan$Population,c(0, 20000, 80000, 140000, 400000, 10000000)))

# color scheme for counties on map
color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

library(maps)

# we call a county map, for the state of michigan, and we tell it to assign colors based on the 
# values in michigan$popcat.  R is able to draw an association between the list of counties in the
# data frame, and relate that to the polygons it knows about.
map('county', 'michigan',
           col = color[michigan$popcat],fill=TRUE,
           resolution = 0, lty = 1, lwd = 0.2)
           
## extras, but they should be considered mandatory...
title(paste ("Population Distribution \nin Michigan by County"),cex.main = 1.1)
maplegmi <- c("0 - 20k","20k - 80k","80k - 140k","140k - 400k","> 400k")
legend("bottomleft", # position
       legend = maplegmi,
       inset=c(-.05,.0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .77,
       bty = "n") # border

# let's look at how maps handles shapefiles and geography...
# the following code will create a dataframe that lists all the county shapefiles

maps_county_data <- as.data.frame(county.fips)

# the actual shapefiles are downloaded as part of the package, but it's almost 
# guaranteed that system security has locked them away where you cannot acces them.  
# you can use the following to see where the files are but you generally cannot 
# check them out.

#Sys.getenv("R_MAP_DATA_DIR")

# the directory is likely "hidden" though you can put it into the file manager
# "R_MAP_DATA_DIR" is an envionmental variable, it's where your shapefiles are located
# the files are in a proprietary format and cannot be easily edited.  

# the main point is that the R MAPS package has a database of maps, and a series 
# of lookup tables between the shapefile names, common references to the geography 
# such as state abbreviation, FIPS code, etc, and the shapefile itself.

## to make maps successfully, you need to assign the shading variables to *each*
## geography in the county

#################################################################
## now the michigan map above worked out quite well but it will not work in all instances
## in the first sesison, I showed an example of the same thing not working for florida
## we will show why, and also provide a more general solution to the problem that will 
## work for you.

### setup for example
rm(list = ls())
dev.off()

mydata <- read.csv("county centroids.csv")
florida <- mydata[mydata$State=='FL',]

# create categories in data (grouping by populaiton size)
florida$popcat<-as.numeric(cut(florida$Population,c(0,50000,100000,500000,1000000,10000000)))
# color scheme for counties on map
color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

map('county', 'florida',
           col = color[florida$popcat],fill=TRUE,
           resolution = 0, lty = 1, lwd = 0.2)

title(paste ("Population Distribution in Florida by County"))
maplegfl <- c("0-50K","50k-100k","100k-500K","500K-1M",">1M")
legend("bottomleft", # position
        legend = maplegfl,
        inset=c(.05,.1),
        ncol = 1,
        #horiz = "true",
        title = "Legend",
        fill = color,
        cex = .8,
        bty = "n") # border

## So it's clear from this map that something has gone wrong.  Miami-Dade has a population category of 0-50k

## let's check the data to ensure that this is not the case, you'll see that the popcat is 5 and the 
## population is over 2 million....
florida[43,]

## so the issue is with the alignment between the county names and the shapefiles
## a bit of examination will turn up the culprit....

fl_map_fips <- subset(county.fips, 12000<=fips & fips<13000)
fl_map_fips

# one issue is that the shapefile for Okaloosa_County is split into two parts.
# https://en.wikipedia.org/wiki/Okaloosa_County,_Florida#/media/File:Map_of_Florida_highlighting_Okaloosa_County.svg

# another issue is that the way the shapefile refers to miami-dade, and it's order in the file, is likely to cause issues.
# https://en.wikipedia.org/wiki/Okaloosa_County,_Florida#/media/File:Map_of_Florida_highlighting_Okaloosa_County.svg

## MAIN TAKEAWAY
## so here is the main takeawy of this presentation for making maps in R: 
## start with the database of shapefiles the package has, and merge your data back into that as opposed to 
## starting with your data and adding shapefile names.  This will likely lead to you missing certain shapes 
## and in practical terms, the sequencing of the colors/shading will not be right and
## that will ultimately lead to incorrect graphics.

## SECOND TAKEAWAY
## the easiest bridge between the shapefiles and the data is the FIPS code.  Where shapefiles have multiple 
## separate geographies, you can assign the same fips code to them, and then use that to merge in your data 
## or categorization of data for graphing.  

################################################################################

## Okay, let's solve this, and also see what's actually happening when we shade a 
## map with data, here is a general approach to demonstrate what's happening

### clean up and set up for example
rm(list = ls())
dev.off()

## read in the data and aggregate to national
mydata <- read.csv("county centroids.csv")
aggdata <- aggregate(cbind(Population,Land.Area,Water.Area,Total.Area)~State, 
                     data=mydata, sum, na.rm=TRUE)
aggdata

## categorize the states by populaiton level
aggdata$popcat<-as.numeric(cut(aggdata$Population,c(0,1000000,3000000,6000000,15000000,50000000)))
unique(aggdata$popcat)
table(aggdata$popcat)

## harmonize the column titles to merge
names(aggdata)[1] <- "abb"

## display the list of state geographies
state.fips

## note that there are 63 shapefiles for the continental US, more than one per state.  To map this 
## accurately, we need to associate the correct state value, with each state shapefile.  Some call
## this a merge, some call it a one to many match, some call it a lookup.  In plain language, you
## need to make sure that you associate the correct statewide value with each geographic area to be 
## mapped.  Once this is done, sort the data on fips and polyname (the various geographic shapefiles),
## and then you have a series that you can feed into the "color" line of the mapping template code.

## (1) merge the categorizations into the mapping areas,
aggdata2 <- merge(state.fips, aggdata, by = 'abb')

## optional, you can think the herd a bit to make this easier to work with
aggdata2 <- aggdata2[c(2,6,11)]
aggdata2

## (2) sort the mapping areas by fips and geography
aggdata2 <- aggdata2[order(aggdata2$fips, aggdata2$polyname),]

color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

map('state',
    col = color[aggdata2$popcat],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

title(paste ("State Population Levels"))
maplegmd <- c("0 - 1M","1M - 3M","3M - 6M","6M - 15M","> 15M")
legend("bottomright", # position
       legend = maplegmd,
       inset=c(-.02,-.02),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .6,
       bty = "n") # border


## so we have the right shading in the right states, through accurate data linking 
## So now that we have all of this, let's make some basic templates for all sorts 
## of practical mapping applicaitons....

# 1) national maps of states
# 2) map of a specific group of states
# 3) state map of counties
# 4) map of a specific group of counties

###############################################################################
# 1) national maps of states
###############################################################################

### clean up and set up for example
rm(list = ls())
dev.off()

## repeat the last example but this time, we'll use total state area, not population
mydata <- read.csv("county centroids.csv")
aggdata <- aggregate(cbind(Population,Land.Area,Water.Area,Total.Area)~State, 
                     data=mydata, sum, na.rm=TRUE)
aggdata
library(Hmisc)
describe(aggdata$Total.Area)

## categorize the states by populaiton level
aggdata$areacat<-as.numeric(cut(aggdata$Total.Area,c(0,50000,120000,170000,225000,50000000)))
unique(aggdata$areacat)
table(aggdata$areacat)

## harmonize the column titles to merge
names(aggdata)[1] <- "abb"

## display the list of state geographies
state.fips

## (1) merge the categorizations into the mapping areas,
aggdata2 <- merge(state.fips, aggdata, by = 'abb')

## optional, you can think the herd a bit to make this easier to work with
aggdata2 <- aggdata2[c(2,6,11)]

## (2) sort the mapping areas by fips and geography
aggdata2 <- aggdata2[order(aggdata2$fips, aggdata2$polyname),]

color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

map('state',
    col = color[aggdata2$areacat],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

title(paste ("States Categorized by Total \nLand and Water Area (000 km^2)"))
maplegmd <- c("0 - 50","50 - 120","120 - 170","170 - 225","> 225")
legend("bottomright", # position
       legend = maplegmd,
       inset=c(-.01,-.02),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .6,
       bty = "n") # border


###############################################################################
# 2) map of a specific group of states
###############################################################################


map('state', 
    region = c('new york', 'new jersey', 'penn'),
    resolution = 0, lty = 1, lwd = 0.2)
title("Group of States \n New York, New Jersey & Pennsylvania")

map('state', 
    region = c('alabama','arkansas','florida','georgia','kentucky','louisiana',
               'mississippi','north carolina','south carolina','tennessee', 'virginia'),
    resolution = 0, lty = 1, lwd = 0.2)
title("Group of Southeastern States")
    
map('county', 
    region = c('alabama','arkansas','florida','georgia','kentucky','louisiana',
               'mississippi','north carolina','south carolina','tennessee', 'virginia'),
    resolution = 0, lty = 1, lwd = 0.2)
title("County Map for Southeastern \n United States")
    
map('state', 
    region = c('alabama','arkansas','florida','georgia','kentucky','louisiana',
               'mississippi','north carolina','south carolina','tennessee', 'virginia'),
    resolution = 0, lty = 1, lwd = 0.2)
title("Group of Southeastern States")

# now let's shade and tighten it up...
# first step is to grab the shapefiles we need to plot.
test_se <- subset(state.fips,abb=='AL'|abb=='AR'|abb=='FL'|abb=='GA'|abb=='KY'|abb=='LA'|abb=='MS'|abb=='NC'|abb=='SC'|abb=='TN'|abb=='VA')

# next we need to categorize some data to make a plot
aggdata$popcat<-as.numeric(cut(aggdata$Population,c(0,1000000,3000000,6000000,15000000,50000000)))
unique(aggdata$popcat)
table(aggdata$popcat)

## harmonize the column title in the aggregate data to the column title in the 
## data we will be mapping to faciliate a merge
names(aggdata)[1] <- "abb"

# merge the categories into the list of shapefiles
test_se <- merge(test_se, aggdata, by = 'abb')

## optional, you can think the herd a bit to make this easier to work with
test_se <- test_se[c(1,2,6,11)]

## (2) sort the mapping areas by fips and geography
test_se <- test_se[order(test_se$fips, test_se$polyname),]


color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

map('state', 
    region = c('alabama','arkansas','florida','georgia','kentucky','louisiana',
               'mississippi','north carolina','south carolina','tennessee', 'virginia'),
    col = color[test_se$areacat],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

title(paste ("Population Levels Among Southeastern States"))
maplegmd <- c("0 - 1M","1M - 3M","3M - 6M","6M - 15M","> 15M")

legend("bottomright", # position
       legend = maplegmd,
       inset=c(-0.05,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .6,
       bty = "n") # border


###############################################################################
# 3) state map of counties
###############################################################################

### clean up and set up for example
rm(list = ls())
dev.off()

### setup for example
mydata <- read.csv("county centroids.csv")
florida <- mydata[mydata$State=='FL',]

# create categories in data (grouping by populaiton size)
florida$popcat<-as.numeric(cut(florida$Population,c(0,50000,100000,500000,1000000,10000000)))
unique(florida$popcat)
table(florida$popcat)

# make a spine of fips codes that corresponds to the shapefiles, 
# create a list object that replaces them with the categories, and remove missing values
# you will then pass this list object (vector of categories) in for coloring
ctyfips <- county.fips$fips[match(map("county",plot=FALSE)$names,county.fips$polyname)]
ctycolmatch <- florida$popcat[match(ctyfips,florida$FIPS)]
ctycolmatch <- ctycolmatch[!is.na(ctycolmatch)]

# color scheme for counties on map
color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

map('county', 'florida',
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

title(paste ("Population Distribution in Florida by County"))
maplegfl <- c("0-50K","50k-100k","100k-500K","500K-1M",">1M")
legend("bottomleft", # position
       legend = maplegfl,
       inset=c(.05,.1),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .75,
       bty = "n") # border

################################################################################
## so here is the shorter, consolidated template for this task:

### clean up and set up for example
rm(list = ls())
dev.off()

### setup for example
mydata <- read.csv("county centroids.csv")
florida <- mydata[mydata$State=='FL',]

# create categories in data (grouping by populaiton size)
florida$popcat<-as.numeric(cut(florida$Population,c(0,50000,100000,500000,1000000,10000000)))

# make list of colors for plotting
ctyfips <- county.fips$fips[match(map("county",plot=FALSE)$names,county.fips$polyname)]
ctycolmatch <- florida$popcat[match(ctyfips,florida$FIPS)]
ctycolmatch <- ctycolmatch[!is.na(ctycolmatch)]

# color scheme for counties on map
color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

## make mape and shade counties based on category
map('county', 'florida',
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

## annotate map
title(paste ("Population Distribution in Florida by County"))
maplegfl <- c("0-50K","50k-100k","100k-500K","500K-1M",">1M")
legend("bottomleft", # position
       legend = maplegfl,
       inset=c(.05,.1),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .75,
       bty = "n") # border

## this is a generalized solution that should work in all cases....
## here is the same thing using MD

### setup for example
rm(list = ls())
dev.off()

mydata <- read.csv("county centroids.csv")
maryland <- mydata[mydata$State=='MD',]

maryland$popcat<-as.numeric(cut(maryland$Population,c(0,50000,100000,250000,500000,10000000)))

color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

ctyfips <- county.fips$fips[match(map("county",plot=FALSE)$names,county.fips$polyname)]
ctycolmatch <- maryland$popcat[match(ctyfips,maryland$FIPS)]
ctycolmatch <- ctycolmatch[!is.na(ctycolmatch)]

map('county', 'maryland',
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

title(paste ("Population Distribution in Maryland by County"))
maplegmd <- c("0-50K","50k-100k","100k-250K","250K-500K",">500K")
legend("bottomleft", # position
       legend = maplegmd,
       inset=c(.05,.1),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .8,
       bty = "n") # border


###############################################################################
# 4a) state map of selected counties within the state
###############################################################################

map('county', 
    region = c('michigan,alger','michigan,baraga','michigan,chippewa','michigan,delta',
                         'michigan,dickinson','michigan,gogebic','michigan,houghton','michigan,iron',
                         'michigan,keweenaw','michigan,luce','michigan,mackinac','michigan,marquette',
                         'michigan,menominee','michigan,ontonagon','michigan,schoolcraft'),
        resolution = 0, lty = 1, lwd = 0.2)
title("Counties in the Northern Penisula of Michigan")

map('county', 
    region = c('michigan,monroe', 'michigan,lenawee', 'michigan,wayne', 'michigan,washtenaw', 
               'michigan,macomb', 'michigan,oakland', 'michigan,livingston', 'michigan,st. clair', 
               'michigan,lapeer', 'michigan,genessee'),
    resolution = 0, lty = 1, lwd = 0.2)
title("Counties in the SouthEast Corner of Michigan")


### clean up and set up for example
rm(list = ls())
dev.off()

### setup for example
mydata <- read.csv("county centroids.csv")
michigan <- mydata[mydata$State=='MI',]

# create categories in data (grouping by populaiton size)
michigan$popcat<-as.numeric(cut(michigan$Population,c(0, 10000, 20000, 30000, 40000, 80000)))
unique(michigan$popcat)
table(michigan$popcat)

# make a spine of fips codes that corresponds to the shapefiles, 
# create a list object that replaces them with the categories, and remove missing values
# you will then pass this list object (vector of categories) in for coloring

test_mi <- subset(county.fips,
                  polyname=='michigan,alger'|polyname=='michigan,baraga'|polyname=='michigan,chippewa'|
                    polyname=='michigan,delta'|polyname=='michigan,dickinson'|polyname=='michigan,gogebic'|
                    polyname=='michigan,houghton'|polyname=='michigan,iron'|polyname=='michigan,keweenaw'|
                    polyname=='michigan,luce'|polyname=='michigan,mackinac'|polyname=='michigan,marquette'|
                    polyname=='michigan,menominee'|polyname=='michigan,ontonagon'|polyname=='michigan,schoolcraft')
                  
# use the same process we identified for other county maps within states, but use the 
# subset of county fips we just created.  note that this sequence of events is important.
ctyfips <- test_mi$fips[match(map("county",plot=FALSE)$names,test_mi$polyname)]
ctycolmatch <- michigan$popcat[match(ctyfips,michigan$FIPS)]
ctycolmatch <- ctycolmatch[!is.na(ctycolmatch)]

# color scheme for counties on map
color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

map('county', 
    region = c('michigan,alger','michigan,baraga','michigan,chippewa','michigan,delta',
               'michigan,dickinson','michigan,gogebic','michigan,houghton','michigan,iron',
               'michigan,keweenaw','michigan,luce','michigan,mackinac','michigan,marquette',
               'michigan,menominee','michigan,ontonagon','michigan,schoolcraft'), 
        col = color[ctycolmatch],fill=TRUE,
        resolution = 0, lty = 1, lwd = 0.2)

title("Population Distribution for Counties \n in Michigan's Northern Penninsula")

maplegfl <- c("0-10K","10k-20k","20k-30K","30K-40k","40k-80k")
legend("bottomright", # position
       legend = maplegfl,
       inset=c(-.02,-.05),
       ncol = 2,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .75,
       bty = "n") # border




################################################################################
# adding elements to maps you create
################################################################################


################################################################################
# you can plot are names on top of the shaded map by calling 'map.text' instead of 'map'. 
# note that we use the "add" switch to indicate that the map window shouldn't be cleared
# and a new map plotted, this will "onion skin" a new layer on top.

map.text('county', 
    region = c('michigan,alger','michigan,baraga','michigan,chippewa','michigan,delta',
               'michigan,dickinson','michigan,gogebic','michigan,houghton','michigan,iron',
               'michigan,keweenaw','michigan,luce','michigan,mackinac','michigan,marquette',
               'michigan,menominee','michigan,ontonagon','michigan,schoolcraft'), 
                add = TRUE, lty = 1, lwd = 0.2, cex = .75)


# Note that you can also call map.text on it's own....

dev.off()
map.text('county', 
         region = c('michigan,alger','michigan,baraga','michigan,chippewa','michigan,delta',
                    'michigan,dickinson','michigan,gogebic','michigan,houghton','michigan,iron',
                    'michigan,keweenaw','michigan,luce','michigan,mackinac','michigan,marquette',
                    'michigan,menominee','michigan,ontonagon','michigan,schoolcraft'), 
         lty = 1, lwd = 0.2, cex = .75)

# or feed in a vector of your own labels....you could do that because you don't want names
# in all lower case (the default) or you could want to add more meaningful labels or 
# qualitative information.  
# here is made up vector but you could feed in program relevant information such as 
# treatment/control areas for evaluations, inspection status, violation frequency, 
# employer outreach success, etc....
weather <- c("Sunny", "Windy", "Calm", "Rainy", "Icy",
             "Sunny", "Windy", "Calm", "Rainy", "Icy",
             "Sunny", "Windy", "Calm", "Rainy", "Icy")

# to plot this, we're going to back up a bit and recreate a nice shaded map

dev.off()
map('county', 
    region = c('michigan,alger','michigan,baraga','michigan,chippewa','michigan,delta',
               'michigan,dickinson','michigan,gogebic','michigan,houghton','michigan,iron',
               'michigan,keweenaw','michigan,luce','michigan,mackinac','michigan,marquette',
               'michigan,menominee','michigan,ontonagon','michigan,schoolcraft'), 
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

title("Population Distribution for Counties \n in Michigan's Northern Penninsula")

maplegfl <- c("0-10K","10k-20k","20k-30K","30K-40k","40k-80k")
legend("bottomright", # position
       legend = maplegfl,
       inset=c(-.02,-.05),
       ncol = 2,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .75,
       bty = "n") # border

# and then lay the labels on top, note that we use both the "add" and "labels" switch

map.text('county', 
         region = c('michigan,alger','michigan,baraga','michigan,chippewa','michigan,delta',
                    'michigan,dickinson','michigan,gogebic','michigan,houghton','michigan,iron',
                    'michigan,keweenaw','michigan,luce','michigan,mackinac','michigan,marquette',
                    'michigan,menominee','michigan,ontonagon','michigan,schoolcraft'), 
         add = TRUE, labels = weather, lty = 1, lwd = 0.2, cex = .75)

# you can also some of the formatting features associated with plotting

map.text('county', 
         region = c('michigan,alger','michigan,baraga','michigan,chippewa','michigan,delta',
                    'michigan,dickinson','michigan,gogebic','michigan,houghton','michigan,iron',
                    'michigan,keweenaw','michigan,luce','michigan,mackinac','michigan,marquette',
                    'michigan,menominee','michigan,ontonagon','michigan,schoolcraft'), 
         add = TRUE, col = "white", labels = weather, lty = 1, lwd = 0.2, cex = .75)

# you can also change fonts and text appearance, as well as moe the labels around, but 
# that is a bit more advanced and we'll save that for another presentation.  you can google
# the details and the following links will provide two different approaches to how you
# think about it:
# discussion of planning for a more cohesive way to handle fonts in R
# https://www.stat.auckland.ac.nz/~paul/R/fonts.html
# example of an external library to help you with this task....
# http://blog.revolutionanalytics.com/2012/09/how-to-use-your-favorite-fonts-in-r-charts.html


###############################################################################
# 4b) state map of selected counties across state boundaries
###############################################################################

### clean up and set up for example
rm(list = ls())
dev.off()

### setup for example
mydata <- read.csv("county centroids.csv")

mydata$popdens <- mydata$Population / mydata$Land.Area
#library(Hmisc)
#describe(mydata$popdens)

# create categories in data (grouping by populaiton size)
mydata$popcat<-as.numeric(cut(mydata$popdens,c(0, 10, 25, 100, 200, 300)))

# make a spine of fips codes that corresponds to the shapefiles, 
# create a list object that replaces them with the categories, and remove missing values
# you will then pass this list object (vector of categories) in for coloring


test_dmv <- subset(county.fips,
                   polyname=='district of columbia,washington'|
                     polyname=='maryland,calvert'|
                     polyname=='maryland,charles'|
                     polyname=='maryland,frederick'|
                     polyname=='maryland,montgomery'|
                     polyname=='maryland,prince georges'|
                     polyname=='virginia,arlington'|
                     polyname=='virginia,clarke'|
                     polyname=='virginia,culpeper'|
                     polyname=='virginia,fairfax'|
                     polyname=='virginia,fauquier'|
                     polyname=='virginia,loudoun'|
                     polyname=='virginia,prince william'|
                     polyname=='virginia,rappahannock'|
                     polyname=='virginia,spotsylvania'|
                     polyname=='virginia,stafford'|
                     polyname=='virginia,warren')

# use the same process we identified for other county maps within states, but use the 
# subset of county fips we just created.  note that this sequence of events is important.
ctyfips <- test_dmv$fips[match(map("county",plot=FALSE)$names,test_dmv$polyname)]
ctycolmatch <- mydata$popcat[match(ctyfips,mydata$FIPS)]
ctycolmatch <- ctycolmatch[!is.na(ctycolmatch)]

# color scheme for counties on map
color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

map('county', 
    region = c('district of columbia,washington','maryland,calvert','maryland,charles','maryland,frederick',
               'maryland,montgomery','maryland,prince georges','virginia,arlington','virginia,clarke','virginia,culpeper',
               'virginia,fairfax','virginia,fauquier','virginia,loudoun','virginia,prince william','virginia,rappahannock',
               'virginia,spotsylvania','virginia,stafford','virginia,warren'), 
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

title("Population Density for \n Counties in the DMV")

maplegfl <- c("0-10","10-25","25-100","100-200","200-300")
legend("topright", # position
      legend = maplegfl,
       inset=c(-.05,.05),
       ncol = 1,
       #horiz = "true",
       title = 'Pop. Density \n (persons/km2)',
       fill = color,
       cex = .5,
       bty = "n") # border

## in case you're wondering what's going on with DC, and more generally, if you find issue with 
## troubleshooting the shapefiles, then the easiest thing to do is to just make small area maps
## to narrow in on whatever the source of the issus is.

## the full map makes it look like we have overlap in DC and arlington.

## here are the counties in question
map('county', 
    region = c('district of columbia,washington','virginia,arlington','virginia,fairfax'))

## here is a map showing that DC has no overlap
map('county', 
    region = c('district of columbia,washington'))

## here is a map showing that arlington has no overlap
map('county', 
    region = c('virginia,arlington'))

# the core DMV with no overlap
map('county', 
    region = c('district of columbia,washington','virginia,arlington','virginia,fairfax',
               'maryland,prince georges','maryland,montgomery'))


#########################################################################
# National map of counties
## note that when you are doing national county maps, you really need to focus on 
## good color schemes.  I recommend this strongly: 
## http://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3

rm(list = ls())
dev.off()

mydata <- read.csv("county_livingwage.csv")
mydata <- mydata[mydata$Hourly.Wages == "Living Wage",]
mydata$Wage <- as.double(gsub("[$]", "", mydata$Wage_1))
library(Hmisc)
describe(mydata$Wage)

mydata$wagecat<-as.numeric(cut(mydata$Wage,c(0, 9.25, 9.75, 10.25, 10.75, 20)))
unique(mydata$wagecat)
table(mydata$wagecat)

# color scheme for counties on map
color = c("#ffffb2","#fecc5c","#fd8d3c","#f03b20","#bd0026")

ctyfips <- county.fips$fips[match(map("county",plot=FALSE)$names,county.fips$polyname)]
ctycolmatch <- mydata$wagecat[match(ctyfips,mydata$countyfips)]
ctycolmatch <- ctycolmatch[!is.na(ctycolmatch)]


# we call a US national map, and we tell it to assign colors based on the values for the 
# estimated living wage by county.  R is able to draw an association between the list of 
# counties in the data frame, and relate that to the polygons it knows about.
map('county', 
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

## extras, but they shoudl be considered mandatory...
title(paste ("Estimate of Living Wage for One Individual \nNo Dependents, By County"),cex.main = .9)
maplegmi <- c("<=$5","$5-$7.5","$7.5-$9","$9-10",">$10")
legend("bottomleft", # position
       legend = maplegmi,
       inset=c(-.02,-.05),
       ncol = 2,
       #horiz = "true",
       title = "Living Wage",
       fill = color,
       cex = .6,
       bty = "n") # border


## effective contrast is everything in this game

color = c("#edf8e9","#bae4b3","#74c476","#31a354","#006d2c")
map('county', 
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

## extras, but they shoudl be considered mandatory...
title(paste ("Estimate of Living Wage for One Individual \nNo Dependents, By County"),cex.main = .9)
maplegmi <- c("<=$5","$5-$7.5","$7.5-$9","$9-10",">$10")
legend("bottomleft", # position
       legend = maplegmi,
       inset=c(-.02,-.05),
       ncol = 2,
       #horiz = "true",
       title = "Living Wage",
       fill = color,
       cex = .6,
       bty = "n") # border


color = c("#edf8fb","#b3cde3","#8c96c6","#8856a7","#810f7c")
map('county', 
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

## extras, but they shoudl be considered mandatory...
title(paste ("Estimate of Living Wage for One Individual \nNo Dependents, By County"),cex.main = .9)
maplegmi <- c("<=$5","$5-$7.5","$7.5-$9","$9-10",">$10")
legend("bottomleft", # position
       legend = maplegmi,
       inset=c(-.02,-.05),
       ncol = 2,
       #horiz = "true",
       title = "Living Wage",
       fill = color,
       cex = .6,
       bty = "n") # border


color = c("#ffffcc","#a1dab4","#41b6c4","#2c7fb8","#253494")
map('county', 
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

## extras, but they shoudl be considered mandatory...
title(paste ("Estimate of Living Wage for One Individual \nNo Dependents, By County"),cex.main = .9)
maplegmi <- c("<=$5","$5-$7.5","$7.5-$9","$9-10",">$10")
legend("bottomleft", # position
       legend = maplegmi,
       inset=c(-.02,-.05),
       ncol = 2,
       #horiz = "true",
       title = "Living Wage",
       fill = color,
       cex = .6,
       bty = "n") # border


color = c("#f6eff7","#bdc9e1","#67a9cf","#1c9099","#016c59")
map('county', 
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

## extras, but they shoudl be considered mandatory...
title(paste ("Estimate of Living Wage for One Individual \nNo Dependents, By County"),cex.main = .9)
maplegmi <- c("<=$5","$5-$7.5","$7.5-$9","$9-10",">$10")
legend("bottomleft", # position
       legend = maplegmi,
       inset=c(-.02,-.05),
       ncol = 2,
       #horiz = "true",
       title = "Living Wage",
       fill = color,
       cex = .6,
       bty = "n") # border

# ryan asked if we could overlay state boundaries on a county map.  answer is yes
# but you need to be a little thoughtful about the order of
# operations.  do the color county maps first, as normal.
# then layer on a second map which is (1) a national map of 
# states, (2) not filled, (3) has contrasting color.
color = c("#ffffcc","#a1dab4","#41b6c4","#2c7fb8","#253494")
map('county', 
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 1, lwd = 0.2)

map('state', fill=FALSE,resolution = 0, lty = 1, lwd = 1.0, col = "white", add = TRUE)

# you can play around wiht other options like using dotted lines 
# between counties and solid lines for states, but these are busy.
color = c("#f6eff7","#bdc9e1","#67a9cf","#1c9099","#016c59")
map('county', 
    col = color[ctycolmatch],fill=TRUE,
    resolution = 0, lty = 3, lwd = 0.2)

map('state', fill=FALSE,resolution = 0, lty = 1, lwd = 0.6, col = "white", add = TRUE)




#########################################################################
# plotting points
#
# note on plotting points, there are multiple mapping libraries in R, all have 
# strengths and weaknesses.  the "maps" package I have used here has the advantage
# of being (relatively) simple to learn, so it's a good one to use to help convey
# the basic concepts and get you going.  But plotting points is maps' achilles heel.
# if plotting points is really important, i suggest you use the ggplot and ggmap
# libraries, google will offer you simple instructions in how to do that.
# an alternative is to you use Ryan's process for plotting to the google map API.
# What i offer below is a bit of hack to make this work in the maps package...
#########################################################################

rm(list = ls())
dev.off()

# template
library(maps)
library(maptools)
library(sp)
library(rgdal)

mydata <- read.csv("county centroids.csv")
michigan<-mydata[mydata$State=='MI',]

locations <- data.frame((michigan$Longitude*-1),michigan$Latitude)

MI <- map('county', region = c("michigan"),plot = FALSE)
MI_poly_sp <- map2SpatialLines(MI,IDs=NULL,proj4string=CRS("+proj=longlat + datum=wgs84"))
point_sp <- SpatialPoints(locations, proj4string=CRS(proj4string(MI_poly_sp)))
plot(MI_poly_sp,col="black",axes=TRUE)
points(point_sp, pch = 20)

# the county centroids account for the water area
# http://www.mapsofworld.com/usa/states/michigan/lat-long.html

mydata2 <- read.csv("cities in michigan.csv", header=FALSE)

## make up vectors of long-lat pairs for plotting
locations2 <- data.frame(mydata2$V3,mydata2$V2)

MI <- map('county', region = c("michigan"),plot = FALSE)
MI_poly_sp <- map2SpatialLines(MI,IDs=NULL,proj4string=CRS("+proj=longlat + datum=wgs84"))
point_sp <- SpatialPoints(locations2, proj4string=CRS(proj4string(MI_poly_sp)))
plot(MI_poly_sp,col="black",axes=TRUE)
points(point_sp, col = "red", pch = 1)
title("Cities in Michigan")

## one of the big advantages of moving this from a "maps" basis to a "plotting" 
## basis is that you are now able to leverage many of the graphical features of R

## make up vectors of long-lat pairs for plotting
mydata2a <- mydata2[mydata2$V5 == 1,]
mydata2b <- mydata2[mydata2$V5 == 2,]
mydata2c <- mydata2[mydata2$V5 == 3,]
mydata2d <- mydata2[mydata2$V5 == 4,]

# now we'll reproduce the chart as if we had different observations
MI <- map('county', region = c("michigan"),plot = FALSE)
MI_poly_sp <- map2SpatialLines(MI,IDs=NULL,proj4string=CRS("+proj=longlat + datum=wgs84"))

point_sp_a <- SpatialPoints(data.frame(mydata2a$V3,mydata2a$V2),
                            proj4string=CRS(proj4string(MI_poly_sp)))
point_sp_b <- SpatialPoints(data.frame(mydata2b$V3,mydata2b$V2),
                            proj4string=CRS(proj4string(MI_poly_sp)))
point_sp_c <- SpatialPoints(data.frame(mydata2c$V3,mydata2c$V2),
                            proj4string=CRS(proj4string(MI_poly_sp)))
point_sp_d <- SpatialPoints(data.frame(mydata2d$V3,mydata2d$V2),
                            proj4string=CRS(proj4string(MI_poly_sp)))

plot(MI_poly_sp,col="black",axes=TRUE)

points(point_sp_a, col = "red", pch = 1)
points(point_sp_b, col = "green", pch = 6)
points(point_sp_c, col = "blue", pch = 7)
points(point_sp_d, col = "orange", pch = 20)

title("Cities in Michigan")

## we can also leverage partitioned plotting to show more complex graphics...
## note that because of the size, I redirect this to an image (as we discussed 
## in a prior session), but it could easily be folded into a document or powerpoint.
jpeg('cities in michigan.jpg', quality = 100, bg = "white", res = 200, width = 12, height = 8, units = "in")
par(mfrow=c(2,2)) 
plot(MI_poly_sp,col="black",axes=TRUE)
points(point_sp_a, col = "red", pch = 1)
title("Plot #1 : Cities in Michigan")
plot(MI_poly_sp,col="black",axes=TRUE)
points(point_sp_b, col = "green", pch = 6)
title("Plot #2 : Cities in Michigan")
plot(MI_poly_sp,col="black",axes=TRUE)
points(point_sp_c, col = "blue", pch = 7)
title("Plot #3 : Cities in Michigan")
plot(MI_poly_sp,col="black",axes=TRUE)
points(point_sp_d, col = "orange", pch = 20)
title("Plot #4 : Cities in Michigan")

dev.off()

### IMPORTANT NOTE: this won't output to the screen, the .jpg file will be in 
### your working directory.  there should be a graphic there with the current 
### timestamp.  you don't have to send graphics to file but sometimes larger, 
### more complex graphics are easier to critically assess.


#let's reproduce the upper pennisula plot...
dev.off()
UMI <- map('county', 
           region = c('michigan,alger','michigan,baraga','michigan,chippewa','michigan,delta',
                      'michigan,dickinson','michigan,gogebic','michigan,houghton','michigan,iron',
                      'michigan,keweenaw','michigan,luce','michigan,mackinac','michigan,marquette',
                      'michigan,menominee','michigan,ontonagon','michigan,schoolcraft'), 
           plot = FALSE)

#let's restrict the cities list to those on the penninsula...
mydata3 <- mydata2[mydata2$V4 == 2,]
locations2 <- data.frame(mydata3$V3,mydata3$V2)

UMI_poly_sp <- map2SpatialLines(UMI,IDs=NULL,proj4string=CRS("+proj=longlat + datum=wgs84"))
point_sp <- SpatialPoints(locations2, proj4string=CRS(proj4string(UMI_poly_sp)))
plot(UMI_poly_sp,col="black",axes=TRUE)
points(point_sp, col = "red", pch = 1)
title("Cities in the Northern Penninsula of Michigan")


#####################################################################################
#####################################################################################

rm(list = ls())
dev.off()

# Finally, geocoding known addresses
# www.osha.gov/sandy/lab.xlsx

mydata <- read.csv('osha_sandy.csv')

## flip the longitude so it's negative
mydata$Longitude <- (mydata$Longitude*-1)

## make up vectors of long-lat pairs for plotting
locations <- data.frame(mydata$Longitude,mydata$Latitude)

library(maps)
map('county', region = c('new york', 'new jersey'),
    fill=FALSE, resolution = 0, lty = 1, lwd = 0.2)


sandy <- map('county', region = c('new york', 'new jersey'),
          fill=FALSE, resolution = 0, lty = 1, lwd = 0.2, plot = FALSE)
              

sandy_poly_sp <- map2SpatialLines(sandy,IDs=NULL,proj4string=CRS("+proj=longlat + datum=wgs84"))
point_sp <- SpatialPoints(locations, proj4string=CRS(proj4string(sandy_poly_sp)))
plot(sandy_poly_sp,col="black",axes=TRUE)
points(point_sp, col = "red", pch = 1)
title("Sites for OSHA Environmental Inspections Following Hurricaine Sandy")

## we can use a county map of new york to reduce the plotting space and make a better chart
## http://geology.com/county-map/new-york.shtml
## http://geology.com/county-map/new-jersey.shtml

map('county', 
           region = c('new york,suffolk','new york,nassau','new york,queens',
                'new york,brooklyn','new york,richmond','new york,kings',
                'new york,new york','new york,bronx','new york,westchester',
                'new jersey,bergen','new jersey,hudson','new jersey,union',
                'new jersey,middlesex','new jersey,monmouth','new jersey,ocean'),
                  fill=FALSE, resolution = 0, lty = 1, lwd = 0.2)

## that looks good so let's plot the points


sandy <- map('county', 
    region = c('new york,suffolk','new york,nassau','new york,queens',
               'new york,brooklyn','new york,richmond','new york,kings',
               'new york,new york','new york,bronx','new jersey,bergen',
               'new jersey,hudson','new jersey,union','new jersey,middlesex'),
          plot = FALSE)

sandy_poly_sp <- map2SpatialLines(sandy,IDs=NULL,proj4string=CRS("+proj=longlat + datum=wgs84"))
point_sp <- SpatialPoints(locations, proj4string=CRS(proj4string(sandy_poly_sp)))
plot(sandy_poly_sp,col="black",axes=TRUE, cex.axis = .8)
points(point_sp, col = "red", pch = 1)
title("OSHA Environmental Inspections Following Hurricaine Sandy", cex.main = .8)

## slightly more complicated, plot four different kinds of inspections

## make up vectors of long-lat pairs for plotting
mydataa <- mydata[mydata$Substance == "Silica",]
mydatab <- mydata[mydata$Substance == "Total Dust",]
mydatac <- mydata[mydata$Substance == "Asbestos",]
mydatad <- mydata[mydata$Substance == "Lead",]

# now we'll reproduce the chart as if we had different observations
# we still have the prior plot for NY and NJ counties that we can reuse (sandy and sandy_poly_sp)
# we just need to make spatial point objects for the data 

point_sp_a <- SpatialPoints(data.frame(mydataa$Longitude,mydataa$Latitude),
                            proj4string=CRS(proj4string(sandy_poly_sp)))
point_sp_b <- SpatialPoints(data.frame(mydatab$Longitude,mydatab$Latitude),
                            proj4string=CRS(proj4string(sandy_poly_sp)))
point_sp_c <- SpatialPoints(data.frame(mydatac$Longitude,mydatac$Latitude),
                            proj4string=CRS(proj4string(sandy_poly_sp)))
point_sp_d <- SpatialPoints(data.frame(mydatad$Longitude,mydatad$Latitude),
                            proj4string=CRS(proj4string(sandy_poly_sp)))

plot(sandy_poly_sp,col="black",axes=TRUE)

points(point_sp_a, col = "red", pch = 1)
points(point_sp_b, col = "green", pch = 6)
points(point_sp_c, col = "blue", pch = 7)
points(point_sp_d, col = "orange", pch = 20)

title("OSHA Environmental Inspections Following Hurricaine Sandy")

## we can also leverage partitioned plotting to show more complex graphics...

jpeg('osha_sandy_locations.jpg', quality = 100, bg = "white", res = 200, width = 12, height = 8, units = "in")
par(mfrow=c(2,2)) 
plot(sandy_poly_sp,col="black",axes=TRUE)
points(point_sp_a, col = "red", pch = 1)
title("Hurricaine Sandy Silica Inspections")

plot(sandy_poly_sp,col="black",axes=TRUE)
points(point_sp_b, col = "green", pch = 6)
title("Hurricaine Sandy Dust Inspections")

plot(sandy_poly_sp,col="black",axes=TRUE)
points(point_sp_c, col = "blue", pch = 7)
title("Hurricaine Sandy Asbestos Inspections")

plot(sandy_poly_sp,col="black",axes=TRUE)
points(point_sp_d, col = "orange", pch = 20)
title("Hurricaine Sandy Lead Inspections")

dev.off()

### IMPORTANT NOTE: this won't output to the screen, the .jpg file will be in 
### your working directory.  there should be a graphic there with the current 
### timestamp.  you don't have to send graphics to file but sometimes larger, 
### more complex graphics are easier to critically assess.

rm(mydataa, mydatab, mydatac, mydatad, point_sp,
   point_sp_a, point_sp_b, point_sp_c, point_sp_d, 
   sandy, sandy_poly_sp, poly_poly_sp, locations)
   
rm(list = ls())
dev.off()

##################################################################
# last thing, geocoding addresses
##################################################################

geocode_mapquest_batch <- function(addresses, 
                                   key = api_key("mapquest")) {
  options(warn=-1)
  # build a search url
  geo_url <- "http://open.mapquestapi.com/geocoding/v1/batch/"
  loclist = paste("location=", addresses, sep="", collapse="&")
  
  query <- list(key = key,
                maxResults = 1L,
                thumbMaps = "false",
                Format = "kvp")
  query <- paste(names(query), query, sep="=", collapse="&")
  query <- paste(query, loclist, sep="&")
  con <- paste(geo_url, query, sep="?")
  
  # get and parse results
  resp <- readLines(con)
  resp <- jsonlite::fromJSON(resp)
  
  # fill in blank data frames with NA to keep lat/lng frames same dimensions
  # as the original address vector
  
  latlng <- lapply(resp$results$locations, 
                   function(x) if(length(x) == 0) {
                     data.frame(lat = NA_real_, lng = NA_real_)} else {
                       x$latLng[,c("lat", "lng")]})
  latlng[sapply(latlng, is.null)] <- data.frame(lat = NA_real_, lng = NA_real_)
  latlng <- do.call("rbind", latlng)
  
  # output data frame of address, latitude, longitude
  outp <- cbind(resp$results$providedLocation, latlng)
  names(outp) <- c("address", "latitude", "longitude")
  outp
}

#' Geocode addresses using the Mapquest Open Geocoding API
#' 
#' You will need an API key to use this function. You can request one from
#' \url{http://developer.mapquest.com/web/products/open/geocoding-service}.
#' 
#' @param addresses A character vector of addresses
#' @param key Your mapquest API key
#' @param batch Reserved for future use
#' @param batch_size Addresses will be geocoded using the batch geocoding 
#' service. The \code{batch_size} controls how large each batch should be.
geocode_mapquest <- function(addresses, 
                             key = api_key("mapquest"), 
                             batch = TRUE, 
                             batch_size = 100L) {
  
  # returns a list of vectors w/ at most batch_size elements each
  batched_addresses <- chunk(addresses, batch_size)
  num_batches <- length(batched_addresses)
  
  geocodes <- vector("list", num_batches)
  for (b in 1:num_batches) {
    geocodes[[b]] <- geocode_mapquest_batch(batched_addresses[[b]],
                                            key)
    Sys.sleep(1)
  }
  do.call("rbind", geocodes)
}

#' Geocode addresses using the Google Maps API
#' 
#' This is \code{geocode} with \code{provider = "google"}. Note that by using this 
#' function, you're agreeing to the Google Maps API terms of service. See 
#' \url{https://developers.google.com/maps/terms#section_10_12}.
#' 
#' @note You will be limited to 2,500 addresses per 24-hour period.
#' 
#' @param addresses A character vector of addresses
#' @return A data frame with three columns: \code{address}, \code{latitude},
#' and \code{longitude}.
#' 
geocode_google <- function(addresses) {
  geocodes <- vector("list", length=length(addresses))
  
  for (a in 1:length(addresses)) {
    if(!(a %% 5L))  Sys.sleep(1L)
    geocodes[[a]] <- get_google_geocode(addresses[a])
    names(geocodes)[a] <- addresses[a]
  }
  
  geocodes <- do.call("rbind", geocodes)
  gc <- data.frame(address = rownames(geocodes), 
                   latitude = geocodes[,1],
                   longitude = geocodes[,2],
                   stringsAsFactors=FALSE)
  rownames(gc) <- NULL
  gc
}

#' Get geo-codes from addresses
#' 
#' @return A \code{data.frame} with three columns: \code{address}, 
#' \code{latitude}, and \code{longitude}
#' 
#' @param addresses A character vector of addresses
#' @param provider Which geo-coding API to use? ("google" or "mapquest")
#' 
#' @seealso \code{\link{geocode_google}}, \code{\link{geocode_mapquest}}
#' @export
geocode <- function(addresses, provider = "google", ...) {
  switch(provider, 
         google = geocode_google(addresses),
         mapquest = geocode_mapquest(addresses, ...))
}

#' Append geocodes to a data frame that includes addresses
#' 
#' @param df A \code{data.frame}
#' @param cols A vector of names or index numbers of the columns that identify 
#' the address-related columns in the data. Ideally, these should be in a 
#' natural order (street, city, state, zip, country).
#' @param ... Other arguments passed to \code{\link{geocode}}
#' 
#' @return The original \code{data.frame} with the added columns \code{address},
#' \code{lat}, and \code{lon}
#' @export
append_geocode <- function(df, cols, ...) {
  unrecognized_columns <- !cols %in% colnames(df)
  if (any(unrecognized_columns))
    stop("These columns are not recognized: ", 
         paste(cols[unrecognized_columns], collapse = ", "))
  
  addresses <- do.call("paste", df[,cols, drop = FALSE])
  gc <- geocode(addresses, ...)
  res <- cbind(df, gc[2:3])
  na_indices <- is.na(res$latitude) | is.na(res$longitude)
  na_cnt <- sum(na_indices)
  if (any(na_indices)) 
    warning("could not geocode ", na_cnt, " rows, so dropped them from the results. ",
            "The problematic addresses:\n", paste(addresses[na_indices], collapse = "\n"))
  res[!na_indices, , drop = FALSE]
}


key = "Js4IXjrj0bUTAS9K4LgosVic0CVYD6Wt"
address = "200 Constitution Ave NW Washington, DC 20210"

geocode_mapquest(address,key, TRUE, 1)

geocode_mapquest <- function(addresses, 
                             key = api_key("mapquest"), 
                             batch = TRUE, 
                             batch_size = 100L) {
  


r <- GET(u)


#####################################################


# below is a template for using the google API to turn 
# addresses into latitudes and longitudes.  we'll do a 
# fuller presentation on this in the very near future 
# but for now, this is a way to feed in addresses, and 
# get back latitude and longitude so you can spatially
# display some data, whatever it may be.

# there are two functions which (1) make a call to the 
# google API, and then (2) unpack and process the returned
# data

# let's geocode one of my favorite establishments: duck donuts in Fairfax
# 10694 Fairfax Blvd, Fairfax, VA 22030

library(rvest)
obj <- read_html("http://www.mapquestapi.com/geocoding/v1/address?key=Js4IXjrj0bUTAS9K4LgosVic0CVYD6Wt&location=200 Constitution Ave NW Washington, DC 20210", encoding = 'JSON')



library(XML)
url <- "http://www.mapquestapi.com/geocoding/v1/address?key=Js4IXjrj0bUTAS9K4LgosVic0CVYD6Wt&location=200 Constitution Ave NW Washington, DC 20210"
data_df <- readHTMLTable(url,
                         which=1)
str(data_df)



          "http://www.mapquestapi.com/geocoding/v1/address?key=Js4IXjrj0bUTAS9K4LgosVic0CVYD6Wt&location=3210%20barbour%20road%20falls%20church%20VA

address = "http://www.mapquestapi.com/geocoding/v1/address?key=Js4IXjrj0bUTAS9K4LgosVic0CVYD6Wt&location=200 Constitution Ave NW Washington, DC 20210"

library(httr)
r <- GET("http://www.mapquestapi.com/geocoding/v1/address?key=Js4IXjrj0bUTAS9K4LgosVic0CVYD6Wt&location=200 Constitution Ave NW Washington, DC 20210")
r <- GET(u)

r


u <- url(address)
u

doc <- getURL(u)
doc <- getURL(address)

doc


x <- fromJSON(doc,simplify = FALSE)


#######################################################

# sadly, what is below here no longer works as of only a short while ago.  Google
# has just moved their entire geocoding and maps systems, even for developers, behind
# a paywall.  I am working on a public use exception, but for now, this is only available
# to paying subscribers.

### load libraries
library(RCurl)
library(RJSONIO)
library(plyr)

# install function 1 :: create the URL to pass the goole API for geocoding
url <- function(address, return.call = "json", sensor = "false") {
  root <- "http://maps.google.com/maps/api/geocode/"
  u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
  return(URLencode(u))
}

# install function 2 :: pass the URL, get return JSON package, parse, array values
geoCode <- function(address,verbose=FALSE) {
  if(verbose) cat(address,"\n")
  u <- url(address)
  doc <- getURL(u)
  x <- fromJSON(doc,simplify = FALSE)
  if(x$status=="OK") {
    lat <- x$results[[1]]$geometry$location$lat
    lng <- x$results[[1]]$geometry$location$lng
    location_type <- x$results[[1]]$geometry$location_type
    formatted_address <- x$results[[1]]$formatted_address
    return(c(lat, lng, location_type, formatted_address))
  } else {
    return(c(NA,NA,NA, NA))
  }
}

# create container for matched data
df = data.frame(matrix(vector(), 0, 5,
                       dimnames=list(c(), c("record", "address", "lat", "long", "return"))),
                stringsAsFactors=F)
output <- df

# prepare some data just to demonstrate the funcitonality

center <- c('Comprehensive Access Point',
          'EDD Workforce Service - San Francisco Civic Center',
          'Western Addition Neighborhood Access Point',
          'Chinatown One Stop Career Center',
          'Southeast Workforce Development - San Francisco City College',
          'Visitacion Valley Access Point',
          'NOVA Job Center Daly City',
          'Alameda One Stop Career Center',
          'West Oakland Neighborhood Career Center',
          'The English Center(Argosy University)')

address <- c('1500 Mission Street San Francisco,CA 94103',
             '801 Turk Street San Francisco,CA 94102',
             '1449 Webster Street San Francisco,CA 94115',
             '601 Jackson Street,1st floor San Francisco,CA 94133',
             '1800 Oakdale Ave. San Francisco, CA 94124',
             '1099 Sunnydale Avenue San Francisco, CA 94134',
             '295 89th Street, Suite 308 Daly City, CA 94015',
             '555 Ralph Appezzato Memorial Parkway, Room Portable P Alameda,CA 94501',
             '1801 Adeline Street,Suite 209 Oakland,CA 94607',
             '1005 Atlantic Avenue Alameda,CA 94501')

mydata <- data.frame(center,address)

## manual example: put the address into a variable and 
## pass it to the google API
addr <- toString(mydata$address[1])
addr
address <- geoCode(addr)
address

## the return value has the address, lat, long and method
address[4]
address[1]
address[2]
address[3]

## write these into a record
#df[1,1] <- i
#df[1,2] <- address[4]
#df[1,3] <- address[1]
#df[1,4] <- address[2]
#df[1,5] <- address[3]


## you can put this into a loop to cycle through a list

for (i in 1:10)   {
  # pull out an address
  addr <- toString(mydata$address[i])
  
  ###########################################################
  # code template based on https://www.r-bloggers.com/using-google-maps-api-and-r/
  #### This script uses RCurl and RJSONIO to download data from Google's API:
  #### Latitude, longitude, location type (see explanation at the end), formatted address
  #### Notice ther is a limit of 2,500 calls per day
  
  address <- geoCode(addr)
  
  df[1,1] <- i
  df[1,2] <- address[4]
  df[1,3] <- address[1]
  df[1,4] <- address[2]
  df[1,5] <- address[3]
  
  output <- rbind(output,df)
  
  }

# check the rows in the data frame
nrow(output)
output

save(output, file = "output.r")
library(xlsx)
write.xlsx(output, "output.xlsx")


