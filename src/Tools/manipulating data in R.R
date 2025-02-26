################################# #################################
### Data manipulation in R   #First introduction
### this code shows a number of basic methods for data manipulation including
### aggregation, merging, column and row addition, column and row subtraction,
### sorting, reshaping, recoding, computing new variables, 
### we will build some fluency in what this code is and why it works over the next few sessions
################################# #################################

## set up the environment, you will see this with each R script we work with

# this will ensure that the necessary packages this session are available, and if not, will find and load them directly
list.of.packages <- c("Hmisc")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# clean up
rm(list.of.packages, new.packages)

# some basic commands to demonstrate how R works and to learn the 
# layout of R studio and become familiar with it's features
# this focuses on a typical task you might need to do in R here at DOL

# set working directory
setwd("~/learn/basicr/")

# import data : you will see this reflected in the box on the upper right
mydata <- read.csv("county centroids.csv")

# subset the data and redirect the output into a new dataframe
mydata2 <- mydata[mydata$State=="MD",]

#########################################################################
# basics of subsetting, adding and subtracting rows and columns
#########################################################################

## subsetting is one of the most fundamental skills to acquire because it's
## not just useful for data manipulaiton, it's foundational to the syntax
## in R to accomplish most basic tasks.  R's syntax involves specifying an 
## action and the group of records on which to perform the action

## additional guidance: http://www.statmethods.net/management/subset.html

## helpful tip for subsetting
colnames(mydata2)

# numeric indexing of rows, columns can be done the same way
mydata2[c(1:5),]      ## the first 5 rows of the data frame
mydata2[c(17:18),]    ## 2 rows from the middle of the data frame

########################################################################
# a bit more on RC notation and subsetting
########################################################################
# note that R has some built in functions to give you first 5 / last 5
head(mydata2)   # first 5
tail(mydata2)   # last 5

# you can add groups of conditions, or groups of subgroups.  Basically any statement that 
# can be evaluated by R logically against each record is a possible conditional.
# if you include multiple conditions, use a collection (i.e. c(a..,b..,c..) )
mydata2[c(1:5,17:18),]

# please note in the last syntax, that we are still using RC coding.  we reference rows
# we want, we put in the comma, and we leave the columns blank.  black defaults to no 
# restrictions, or *include all with no subsets*.  BUT WE STILL HAVE THE COMMA!!!

# note that the following works
mydata2[,]
# and it is essentially the same as just saying 
mydata2

# so including the comma with no subsets is fine, but what about omitting the comma?
# it doesn't work: without the comma, R doesn't know what we are asking for...

mydata2[c(1:5,17:18)]   # this should produce an error

# so in summary, simply get in the habit of always using  RC notation when subsetting
# an easy way to do this is to write your subset syntax...
#      newdata <- mydata[,]
# and then populate it with your conditions for subsetting
#      newdata <- mydata[ c(1:5) , c(1:5) ]
#      newdata 
      
########################################################################
# Below are some additional kinds of subsetting.  you may not even think about them 
# as subsets, but that's in essence what they are.  All the people in a room whose name
# begins with "B" or who are taller than 5'8", or who have more than 2 siblings.
# this is among the most common data steps: "all establishments with 1 or more violations..." 
########################################################################

# name indexing (i.e. subsetting off the variable names)
mydata_temp <- mydata2[,c("FIPS","County","Population")]
head(mydata_temp)

rm(mydata_temp)

#logical indexing  (i.e. all records on one side of a numeric criteria)
mydata2$Population >150000
  #1 this simply provides a list of logicals for *which records meet the criteria*

# subsetting using this
mydata2[mydata2$Population >150000, ]
  #2 this shows the records in the dataframe that meet the criteria*
  # note the difference in the syntax from the prior command, that was just a condition, 
  # this is a condition within a subset.  Do ou see the difference?

## redirecting output into a new dataframe
mydata3 <- mydata2[mydata2$Population >150000, ]
head(mydata3)
  #3  this creates a new dataframe for records which  meet the criteria

mydata4 <- mydata2[mydata2$Population <75000, ]
head(mydata4)
  # same as above, but looking at counties with small populations

####### column addition and subtraction   ################################
## create a new variable:  this happens in one step: you define the variable and 
## the system will create it and populate it.
## syntax:    dataframe$new_variable <- (expression)

mydata3$three  <- 3
head(mydata3)

mydata3$Population2  <- mydata3$Population
head(mydata3)

## it's common to create new variables for analysis this way.  you might make an unemployment rate by dividing the number
## of unemployed by the labor force, or percent of funds expended by dividing obligations  by total budget.  you can do this 
## 'inline' meaning that defining the variable in the calculation will create it, format it, and store it's values.
mydata3$popdensity <- (mydata3$Population / mydata3$Land.Area)
head(mydata3)

mydata3

## removing columns: same syntax as subsetting
## !! note the use of the minus sign in front of the "c" for collection
## we still make a collection of columns, but the minus sign will exclude them

## note also that as you execute these commands, you can see the number of 
## variables in the upper right environment screen begin to drop

mydata3 <- mydata3[,-c(15:16)]

## you can also remove by negation
mydata3$popdensity <- NULL
colnames(mydata3)

####### row addition and subtraction   ################################

# you can add rows (MUST HAVE THE SAME STRUCTURE) by using rbind (row binding is appending)
colnames(mydata3)
colnames(mydata4)
mydata5 <- rbind(mydata3, mydata4)

# you can remove rows by condition...   (note that the "!" is a "not" operator)
mydata5 <- mydata5[!(mydata5$Population > 600000),]

# ...or you can keep only those rows that meet a condition
mydata5 <- mydata5[mydata5$Population < 50000,]

# you can remove rows by addressing the row indexes. 
mydata5 <- mydata5[-c(5:7),]

# and you can do the same thing with column indexes. Note that only difference here is where we put the comma
mydata5 <- mydata5[,-c(5:7)]

# I can't really emphasize this enough. the basic idea of [row,column] notation is so fundamental to everything
# you will do.  it's often the cause of issues you have, and you may not even notice or may have overlooked it.
# if you forget the comma, R will try to interpret what you are asking as best it can, but it may not be what 
# you intended.

# clean up
rm(mydata3, mydata4, mydata5)

#########################################################################
## sorting
#########################################################################

## you use the order() function to sort or change the sequence 
## of data.  the basic syntax you will most commonly use is:

#dataframe[order(dataframe$variable),]

mydata2[order(mydata2$Population),] 

## to save your sorted data set, use the same syntax but redirect into new dataframe:

mydata2 <- mydata2[order(mydata2$Population),] 
mydata2[,c(1:8)]

## to save your current working data set, sorted as you indicated,
## but to a different data frame, redirect it into a new dataframe:

sorted_data <- mydata2[order(mydata2$Land.Area),] 
head(sorted_data)

## the default sort mode is ascending.  you can reverse this by adding a
## minus sign (-) in front of the variable

mydata2 <- mydata2[order(-mydata2$Population),] 
mydata2[,c(1:8)]

## you can sort on more than one variable, and do so ascending or descending
## the default sort mode is ascending.  reverse this by preceding 
## minus sign (-) in front of the variable

# create a category for the sorting example, cut population at 85000
mydata2$cat[mydata2$Population < 85000] <- 1
mydata2$cat[mydata2$Population >= 85000] <- 2
mydata2

## these examples are generally more useful in exploratory data analysis
sorted_data <- mydata2[order(mydata2$cat,-mydata2$Population),] 
sorted_data[,c(1:4,15,6)]

## Potentially helpful hint, especially if you do a lot of googling!
## there is also an order function that produces a vector with rankings
## but this does not sort the data, it simply gives you an index of the 
## rankings.  the difference is important.  order() is also useful but 
## don't confuse it with sorting.  if your output is a long string of numbers
## that look like a sequence, you are probably getting the sort order as 
## opposed to (the acton of) actually sorting your data

#clean up
rm(sorted_data)

## Categorizing data ###########################################
## you may wonder why categorization is listed here as an important manipulation action
## something as simple as making a map always implicitly requires you to draw distinctions
## in your values, and put the values into bins that can be compared.  you can often leave 
## this ot the system to do, but the cut points will be defined by distibution, and may not 
## show even representaiton among the bins.   you're (almost!) always better off making the 
## decision, doing the analysis and then adjusting your values if you don't like what you see.
library(Hmisc)
mydata$popdensity <- (mydata$Population / mydata$Land.Area)
describe(mydata$popdensity)

## method 1: specify the intervals, produces an integer categorical
mydata$popcat <- findInterval(mydata$Population, c(0, 20000, 80000, 140000, 400000,10000000))
unique(mydata$popcat)
table(mydata$popcat)
typeof(mydata$popcat)

## Method 2: specify the number of groups, and let the system make the cut points
mydata$popcat2 <- cut(mydata$Population, breaks = 4) 
unique(mydata$popcat2)
table(mydata$popcat2)
typeof(mydata$popcat2)
## NOTE: this produces some unusual intervals, there are 3135 data points in 1, and a handful in the others.
## this is....well...not good.

# the results are pretty uneven so you can specify where you want the breaks to be
mydata$popcat2 <- cut(mydata$Population, c(0, 20000, 80000, 140000, 400000,10000000) ) 
table(mydata$popcat2)

# you can knock off the scientific notation...and add clearer labels....
mydata$popcat2 <- cut(mydata$Population, c(0, 20000, 80000, 140000, 400000,10000000), dig.lab=10,labels = c("0-20k","20k-80k","80k-140k","140K-400k", "400K-10M"))
table(mydata$popcat2)

## an simpler, clearer, and more modular coding style: break out the characteristics and 
## include them as components.  it's easier to edit the pieces and rerun the code to produce
## output that you find appropriate

## create a vector of labels
labels <- c("0-20k","20k-80k","80k-140k","140K-400k", "400K-10M")

## create a vector of breaks
breaks <- c(0, 20000, 80000, 140000, 400000,10000000)

## fold everything back together using the syntax we were using above
mydata$popcat2 <- cut(mydata$Population, breaks = breaks, dig.lab=10, labels = labels)
table(mydata$popcat2)
head(mydata)

## note an advantage of this is that R picks up the value labels and your tables look better as a result.
describe(mydata$popcat2)

plot(jitter(mydata$popcat),jitter(mydata$popdensity), whisklty = 0, staplelty = 0,
     main="Population Density within Population Intervals", 
     xlab="Population Category", ylab="Population Density", pch=1)

plot(mydata$popcat2,jitter(mydata$popdensity), whisklty = 0, staplelty = 0,
     main="Population Density within Population Intervals", 
     xlab="Population Category", ylab="Population Density", pch=1)

## esp. stata users: you can value label your categoricals and 
## interval scaled variables instead of categorization
## http://www.statmethods.net/input/valuelabels.html

#########################################################################
#########################################################################

## reshaping

#transpose row and columns: syntax is t(dataframe)
mydata3 <- t(mydata2)
head(mydata3)

# note, the results are not *exactly* what you would expect.
# in a prior example, i showed how to manipulate the data into 
# something reasonable, but you may want to pull out particular 
# segments of a data frame and transpose them and recombine.

## re-ordering

## reorder columns in a data frame by providing the sequence 
# of the columns.  Syntax is: dataframe[c(1,3,2)]

mydata3 <- mydata[c(1:3,15,4:12)]

## aggregation

## this is simple, single operation so you need to restrict it to 
## variables for which the operaiton is relevant.  if you're computing 
## means, don't include county name (string) or zip code (irrelevant)

## 1) pick the variables you want aggregated and cbind them together
## 2) pick the variable you want to aggregate them across (it follows the '~')
## 3) pay attention to the details: pick the dataset, the aggregation function, and
##    how to handle missing values

# Aggregating data into tables, useful for rolling up totals
aggdata <- aggregate(cbind(Population,Land.Area,Water.Area,Total.Area)~State, 
                     data=mydata, sum, na.rm=TRUE)
aggdata

rm(aggdata, mydata2, mydata3, breaks, labels)

## merging

## merging in R is easy.  if you harmonize the merging variables, it is particularly 
## easy, but even without that, the necessary code is not complicated

## make a second data set to have something to merge
colnames(mydata)
mydata <- mydata[,c(1:14)]
mydata2 <- mydata

# add something new to the dataset, this is all stuff we did above
mydata2$popdensity <- (mydata$Population / mydata$Land.Area)
mydata2$popcat <- findInterval(mydata$Population, c(0, 20000, 80000, 140000, 400000,10000000))

# keep only FIPS, population and the two new variables we created
mydata2 <- mydata2[,c(3,6,15:16)]

colnames(mydata)
colnames(mydata2)

## we can merge on FIPS code
## the general syntax is: new_data_frame <- merge(dataframe1, dataframe2, joining field)

newdf <- merge(mydata, mydata2, "FIPS")

## a couple of things to note:
## 1) you know the merge was successful based on looking at the row and column count in
##    the upper right hand corner
## 2) view the resultsing data frame and what do you notice about the two population columns
## 3) if you are confused about merging, here are two resources that will help:
#######  Know the kinds of data joins: https://stackoverflow.com/questions/17946221/sql-join-and-different-types-of-joins
#######  Know the syntax for merging: https://stat.ethz.ch/R-manual/R-devel/library/base/html/merge.html

rm(mydata2, newdf)

#################################################################
# practical example

## the following code shows a simple example: lets' say we want to use what we have 
## learned to find out which counties have population levels above the state average
## the following code will walk through a very basic way of doing this: we are keeping
## the code simple so you can use what we are learning, and follow the concepts.    


# compute the average value across counties within each state
aggdata <- aggregate(cbind(Population,Land.Area,Water.Area,Total.Area)~State, 
                     data=mydata, mean, na.rm=TRUE)
# check output
aggdata

# check column names
colnames(aggdata)

# we need to make new column names so we can fold this data back into the original
colnames(aggdata) <- c("State","aggPopulation", "aggLand.Area", "aggWater.area", "aggTotal.Area")

# check column names
colnames(aggdata)

## aggregate data can easily be merged with other aggregate data but care should 
## be taken in merging it back into individual data.  example: 

# fold the aggregate (statewide) data back into the individual county data
mydata4 <- merge(mydata,aggdata,by="State")
mydata4

# just to illustrate the point, compute each counties' difference from the 
# statewide avg. in population

mydata4$popdiff = mydata4$Population - mydata4$aggPopulation
describe(mydata4$popdiff)

# visualize
plot(mydata4$popdiff,mydata4$Population)

# get the top and bottom 5: sort the data on popdiff and then list the first and last 5
mydata4 <- mydata4[order(mydata4$popdiff),]
head(mydata4)
tail(mydata4)

