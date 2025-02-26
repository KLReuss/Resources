################################# #################################
### basics in R   #First introduction
### this code shows a sample R job to give you sense of what R  code looks like and what it can do
### we will build some fluency in what this code is and why it works over the next few sessions
################################# #################################

## set up the environment, you will see this with each R script we work with

# this will ensure that the necessary packages this session are available, and if not, will find and load them directly
list.of.packages <- c("Hmisc", "maps")
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

# describe the data type and contents  :: check console box immediately below for output
class(mydata)
head(mydata)
summary(mydata)

# extend this: use a library to bring in better functionality for descriptive statistics
library(Hmisc)
describe(mydata$Population)

# an example of subsetting data
# restrict the data set to the first 20 rows, verify in upper right
mydata2 <- mydata[1:20,]

# generate a very basic barplot
barplot(mydata2$Population)

# generate a very basic scatterplot: population and land area
plot(mydata2$Population, mydata2$Land.Area, main="Scatterplot Example", 
     xlab="County Population", ylab="County Land area", pch=19, cex.axis= .8)

# another example of subsetting data
# restrict the data set to those counties in Florida, verify 
mydata2 <- mydata[mydata$State == "MI",]

# generate a very basic scatterplot
plot(mydata2$Population,mydata2$Land.Area)

# saving output 
#write.table(mydata, file = "counties.R")

# Aggregating data into tables
aggdata <- aggregate(cbind(Population,Land.Area,Water.Area,Total.Area)~State, 
          data=mydata, sum, na.rm=TRUE)

head(aggdata)
print(aggdata)

# Categorizing data
mydata2$popcat <- findInterval(mydata2$Population, c(0, 20000, 80000, 140000, 400000))
unique(mydata2$popcat)
table(mydata2$popcat)

# color scheme for counties on map
color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")

library(maps)
mp <- map('county', 'michigan', 
          col = color[mydata2$popcat], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)

### optional stuff to make it look nice and tight

#add a title
title(paste ("Population Distribution in Michigan by County"),cex.main = 1.1)

# create a legend
mapleg <- c("0 - 20k","20k - 80k","80k - 140k","140k - 400k","> 400k")

#add a legend
legend("bottomleft", # position
       legend = mapleg,
       inset=c(.05,.1),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .8,
       bty = "n") # border

# mydata2 <- mydata2[order(mydata2$popcat, mydata2$County),]
# write.csv(mydata2,"michigan.csv")

### a quick cautionary tale:
### trying the same code with florida will not yield the right answer

# restrict the data set to those counties in Florida, verify 
mydata2 <- mydata[mydata$State == "FL",]
mydata2$popcat <- findInterval(mydata2$Population, c(0, 20000, 80000, 140000, 400000))
color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784")
mp <- map('county', 'florida', 
          col = color[mydata2$popcat], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Population Distribution in Florida by County"),cex.main = 1.1)
mapleg <- c("0 - 20k","20k - 80k","80k - 140k","140k - 400k","> 400k")
legend("bottomleft", # position
       legend = mapleg,
       inset=c(.05,.1),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color,
       cex = .8,
       bty = "n") # border

### this is because of the database of names for the counties
### and the underlying programming that drives the map function

### in one of the upcoming sessions, we will work throuh this example and better understand the *why*
### but for now, nust notice how simple it is to import data, rearrange and analyze/summarize and 
### then turn it into plots, maps and charts.

### We start now with a basic understanding of how data works inside of R

################################# #################################
### basics in R   #Built in data types
################################# #################################

# clear output window
dev.off()

# clear memory
rm(list = ls())

# Create variables (scalars and strings) by naming them and giving value
# you generally don't define the variable type, R will assign an approprate container
var1 <- 2
var1 = 3

# R will create the right kind of data type for you
# note thta we don't need to initialize text variables and numeric variables
var2 <- "Claude"
var3 <- "12/31/17"

typeof(var1)
typeof(var2)
typeof(var3)
# note, var3 is not a date!!!    
var4 <- as.Date(var3,"%m/%d/%y")
typeof(var4)
# note, var4 is *still* not a date, but it is something that can be processed like a date now.

#removing the value but not the variable
var1 <- NULL

#removing the variable
rm(var1,var2,var3, var4)

################################################

# you can use variables the way you would use numbers or values
# operation are easy, and generally done in the manner you would write them out
var1 <- 2
var2 <- 4
var3 <- 6

var4 <- var1 + var2 + var3

# you don't need variables to do operations, R is an interpretter
3 + 4

# note that the prior commnad did not create a variable: R took your input and interpretted what you wanted
# note also that you can type these into the console as well...

################################################

# clear memory
rm(list = ls())

# Vectors (or sets)

v <- c(1, 2, 3, 4)   # c "combines" elements into a list, like the excel concatenate function.

# as above, to see the contents, type the object's name
v 

# alternate methods to create consecutive vectors:
v1 <- 1:8
v1

# and non-consecutive vectors:
v2 <- seq(from = 0, to = 0.5, by = 0.1)
v2

# Use variables you make to create vectors, or pass into functions as argument:
a <- 0
b <- 22
v3 <- seq(a, b, 2)
v3

#Use the length() and mean() functions to describe content of vectors
length(v3)   
mean(v3)     

#values from functions can be passed back into variables, handy for looping
vector_length <- length(v3)

# clear memory
rm(list = ls())

# vectors can contain any data type
v_names <- c("claude", "pierre", "jean")
v_names

# IMPORTANT :: elements of vectors are referenced using matrix notation
# get the first element
v_names[1]

#get the first and third elements
v_names[c(1, 3)]   

# overwrite existing elements
# example of *assignment* you "push" the values into those variables
  
v_names[2:3]  <- c("sarah", "tina")
v_names

# clear memory
rm(list = ls())

# Matrices (or 2D vectors)

# for now, just be aware that matrices operate exactly like vectors
# !!! matrix notation is [row, column], sometimes referred to RC notation
# and their values are referenced in the same way, but with RC notation

v1 <- c("claude", "pierre", "jean")
v2 <- c("sarah", "tina", "jeanne")

mat = matrix(nrow=2, ncol=3)
mat[1,] <- v1
mat[2,] <- v2
mat

mat[1,1]
mat[1,3]
mat[2,1]
mat[2,3]

rm(list = ls())

# IMPORTANT :: the core data structure in R is the data frame
# Data frames are the most common and default structure in 
# R for complex data types.

name <- c("Harry", "Ron", "Hermione", "Hagrid", "Voldemort")
height <- c(176, 175, 167, 230, 180)
gpa <- c(3.4, 2.8, 4.0, 2.2, 3.4)

df_students <- data.frame(name, height, gpa)

### Note: you can view this data frame by clicking on the spreadsheet icon under
### data next to the data frame name in the upper right window.  it will dispay 
### as a tab just above this window

## IMPORTANT
# (1) you do not need to define the data type ahead of time
# (2) you can address data elements in the same way you did above
# (3) you can also address them as < dataframe$variable >
# (4) commit the [R,C] syntax to memory, 99.976% of newbie errors are due to this

# whole dataframe
df_students

# addressing by variable
df_students$height
df_students$gpa

# Note that as above, we can redirect any output into a new variable
df_students$gpa2 <- df_students$gpa
df_students$gpa2 <- df_students$gpa2 * 1.25
df_students

# addressing by element
df_students[1,1]
df_students[2,1]
df_students[2,2]

# referencing rows (don't forget the comma!)
df_students[1,]
df_students[1:3,]

# referencing columns (don't forget the comma!)
df_students[,1]
df_students[,1:2]
# you can see "collections" of columns or rows
df_students[,c(1,3)]

# mixed: referencing rows and columns
df_students$gpa[1:2]
df_students$gpa[2:3]

# built in functions that are handy:
head(df_students)  # first 5 records
tail(df_students)  # last 5 records


################################# #################################
### Okay, so why was all that worth paying attention to?
### basic data subsetting is the root of most practical activity
### quick example that illustrates a practical example of the prior concepts
################################# #################################

rm(list = ls())

## import a data file as a data frame
mydata <- read.csv("county centroids.csv")

# load a library that has functionality i need to explore the data
library(Hmisc)

# remember: you reference a variable in a data frame as <df_name $ df_element>
describe(mydata$Population)

# using a function to compute an average value across the records
pop_avg <- mean(mydata$Population)

## the lowest population we see from describe is 82 (which is pretty small)
## how do I find out which county has such a small population?
## more generally, how do i display records that meet specific criteria?
## answer: subsetting data.  
## the syntax is df[row condition,column condition]

mydata[mydata$Population == 82,]

## how do I then redirect that into a new file?

smallest <- mydata[mydata$Population == 82,]

## how do I find the largest?

mydata[mydata$Population == 9818605,]

## remember that what i am doing with this syntax is asking for 
## all rows that meet that condition.  in this case, it's all 
## rows with a county population of 9,818,605

## how do i find the counties in the top 95% of population?
## i got the 95% value from the "describe" output
## and use the same apporach, select rows that meet condition

larger <- mydata[mydata$Population >= 422713,]

# see what's in the subset
larger

## so your boss just came in with three new questions:
## 1) what is the average population among the top 5% of cases?
## 2) a) compute the population density, b) which counties are in the top 5%
## 3) what is the average population density in the top 5% of cases?

## 1) 
## subset the data and redirect the cases
larger <- mydata[mydata$Population >= 422713,]
## compute the desired statistics off the subset
mean(larger$Population)

## 2) 
## compute population density
mydata$popdens <- (mydata$Population / mydata$Land.Area)
## get the 95% value
describe(mydata$popdens)  
## subset the data and redirect the cases
larger <- mydata[mydata$popdens >= 345.1373,]  
larger
larger[c(4,2)]

## 3) 
## use the redirected cases to compute mean
mean(larger$popdens)  


### gold star bonus assignment: 
### which counties are in the top 5% of population *AND*
### in the top 5% of population density?
### you can either solve it or think about how you would set up 
### the data to solve it.


################################# #################################
### utility code: missing values
################################# #################################

### setup for example
rm(list = ls())
name <- c("Harry", "Ron", "Hermione", "Hagrid", "Voldemort")
height <- c(176, 175, 167, 230, 180)
gpa <- c(3.4, 2.8, 4.0, 2.2, 3.4)
df_students <- data.frame(name, height, gpa)

### going back to the student data set, adding missing values that are stored as NA
df_students[1:2,1:2]  <- NA

## in small data sets, it's easy, we can just look and see the NAs
df_students

## in larger data sets, you can use a simple process to see if there are any NAs
df_students[!complete.cases(df_students),]

## WHY DO WE CARE??
## note that R behaves in a manner similar to what you have seen 
## in excel.  the presence of NAs will complicate simple operations:
mean(df_students$height) # returns NA
mean(df_students$height, na.rm=TRUE) # returns 2

## be careful about some built in functions
## this will "solve" your problem, but you will lose any records with NAs
df_students2 <- na.omit(df_students)
df_students2

df_students3 <- df_students
df_students3

## replacing missing values

## you can find logicals around whether values are missing or not
is.na(df_students3$height)

## replace by subsetting the missing values, and replacing them
df_students$height[is.na(df_students$height)] <- 192.33
df_students

# clean up
rm(list = ls())

