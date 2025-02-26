################################# #################################
### this follows basics in R, and manipulating data, it covers importing and ingesting data
### this script will focus on the data types we use here at DOL
### these can readily be adapted and extended to other data types as well
################################# #################################

# clean up
rm(list = ls())

## set up the environment, you will see this with each R script we work with

# this will ensure that the necessary packages this session are available, and if not, will find and load them directly
list.of.packages <- c("openxlsx","foreign", "XML", "jsonlite", "blsAPI", "zoo", "devtools")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(devtools)
install_github("mikeasilva/blsAPI")

# clean up
rm(list.of.packages, new.packages)

#####################################################################
## let's get going with data ingestion.  hands down, the most common, no question....
## reading in .csv files, note that this is base R functionality

setwd("~/learn/basicr/")
mydata <- read.csv("county centroids.csv")
head(mydata)

mean(mydata$Population)

#variable type, reading in specific formats and proc content analog

# all of these processess will read your data into dataframes, 
# yielding maximum flexibility and use with library functions

# using libraries to add functionality to R.  Libraries allows R to extend it's functions
# in this case, they give us a way to load proprietary file formats directly

library(openxlsx)
mydata <- openxlsx::read.xlsx("county centroids.xlsx", 1)
mean(mydata$Population)

# from proprietary stat packages like Stata (SAS works the same way)
library(foreign)
mydata <- read.dta("county_centroids2.dta")
mean(mydata$population)

# note: there is a SAS package called "sas7bdat" which specializes in 
# reading SAS databases.  if you have complex data or variable and value
# labels that you need to keep, this may be worth pursuing.

# from other general data structures such as generic database containers
library(foreign)
datafile <- "AZ_501.dbf"
mydata <- read.dbf(datafile)
str(mydata)

### other DOL specific data file formats include
######   read.fwf for fixed width ascii files

# additional help and templates
#https://www.r-bloggers.com/this-r-data-import-tutorial-is-everything-you-need/   #1 best greatest!
#http://www.statmethods.net/input/importingdata.html

# clean up
rm(list = ls())

################################# #################################
### importing and ingesting data   
### slightly more sophisticated data import methods
################################# #################################

library(XML)

### from web page (living wage calculator, DC, jurisdiction-wide)
### note for reference:   http://livingwage.mit.edu/


url <- "http://livingwage.mit.edu/counties/11001"
data_df <- readHTMLTable(url,
                         which=1)
str(data_df)

url <- "http://livingwage.mit.edu/counties/11001"
data_df2 <- readHTMLTable(url,
                         which=2)
str(data_df2)
data_df2[1:2]


# clean up
rm(list = ls())

################################# #################################
### slightly more sophisticated data import methods
### import from the BLS API, with a discussion of *WHY* this works
################################# #################################

#install_github("mikeasilva/blsAPI")
library(blsAPI)

#method 1

payload <- list('seriesid'=c('LAUCN040010000000005','LAUCN040010000000006'), 'startyear'='2010', 'endyear'='2012') 
payload
response <- blsAPI(payload) 
response

library(jsonlite)

## this is to show the actual output from the BLS API looks like
## there are simpler ways to do this, but it's important that you 
## have some general sense of what the return looks like so you can
## troubleshoot this process  

## we are going to use R tools to parse and rearrange this data so it 
## can be used in a practical way

json <- fromJSON(response, simplifyVector = TRUE)

## we are getting closer to something useful

json
json[[4]]

## the data are actually stored as a list.  we need to isolate the list
## and then rearrange it into a data frame

step1 <- as.data.frame(json[[4]])

## click on the step1 data frame icon to see what has been created.
## this is the first phase of the parse.  the second phase is coming up.
## note that series data are contained in cells [1,2] and [2,2] of the df
## we will repeat the process and extract them into tables.

step2 <- as.data.frame(step1[1,2])
step3 <- as.data.frame(step1[2,2])

## the output below should show the data you want, in a format you can use it in.

step2
step3

## here is what a complete retrieval for Nevada State Unemployment Rates would
## look like.  

# clean up
rm(list = ls())

### consolidated example

payload <- list('seriesid'=c('LASST320000000000003'), 
                'startyear'='2010', 'endyear'='2015') 
response <- blsAPI(payload) 
json <- fromJSON(response, simplifyVector = TRUE)
step1 <- as.data.frame(json[[4]])
step2 <- as.data.frame(step1[1,2])

# drop the unnecessary text
step2 <- step2[,-c(5)]
step2

## and just for fun, let's convert the dates and build a chart

# build a date
step2$period <- sub('M', '', step2$period)
step2$datetxt <- paste(step2$year,"-",step2$period,sep = "")
library(zoo)
step2$date <- read.zoo(text = step2$datetxt, FUN = as.yearmon)
step2$date


# sort data frame by date
step2 <- step2[order(step2$year, step2$period),]

barplot(as.numeric(step2$value),names.arg = step2$datetxt, 
        xlab="Month", ylab="Unemployment Rate", pch=18, col="grey")


## a couple important things to note.  R is very powerful and can simplify
## and automate tasks in amazing ways, but it took me the better part of an
## afternoon to really understand what the data coming back from BLS was and 
## how to incorporate it effectively.

## the built in functions are very helpful, and the libraries that many people
## have created for many purposes are tremendous time savers and resources,
## but if you don't know what's going on behind the scenes, it can sometimes
## be frustrating to figure out why it won't work.

## note that in most cases where things don't work, you didn't fully read or
## understand the documentation, or you are trying to use it in a way not intended.

## note also that the other half of using this capabiliy is knowing what to look for
## the BLS series finder (beta) can be helpful: 
## https://www.bls.gov/bls/data_finder.htm
## try entering Nevada and see if you can find the code for the Nevada seasonaly adjusted unemployment rate

###############################################
###############################################
###############################################

### below is a much longer practical example: we are not going to cover 
### every aspect of it, but it illustrates a few simple points.
### 1) easing repetitive tasks by automating this in code
### 2) finding ways to merge, compare and contrast different data sets

# clean up
rm(list = ls())

library(XML)

### from web page (living wage calculator, state is ALabama, jurisdiction-wide)

### identify a URL
url <- "http://livingwage.mit.edu/states/01"

### read the URL as a data table (function from the XML library!)
LW_data_df <- readHTMLTable(url,which=1)

### thin the herd so we only have the data from columns 1 & 2
LW_data_df <- LW_data_df[,1:2]

### set the column name
colnames(LW_data_df)[2] <- "AL"


### after this, we are going to repeat the process, incrementing the FIPS code
### in the URL, doing the same edits, and adding the data to a state-named column

url <- "http://livingwage.mit.edu/states/02"
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$AK <- temp_data_df[,2]

### do this for the remainder of the states

url <- "http://livingwage.mit.edu/states/01"  
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$AL <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/02"  
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$AK <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/04"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$AZ <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/05"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$AR <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/06"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$CA <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/08"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$CO <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/09"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$CT <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/010"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$DE <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/011"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$DC <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/012"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$FL <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/013"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$GA <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/015"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$HI <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/016"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$ID <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/017"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$IL <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/018"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$IN <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/019"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$IA <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/020"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$KS <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/021"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$KY <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/022"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$LA <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/023"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$ME <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/024"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$MD <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/025"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$MA <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/026"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$MI <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/027"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$MN <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/028"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$MS <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/029"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$MO <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/030"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$MT <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/031"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$NE <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/032"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$NV <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/033"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$NH <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/034"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$NJ <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/035"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$NM <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/036"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$NY <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/037"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$NC <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/038"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$ND <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/039"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$OH <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/040"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$OK <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/041"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$OR <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/042"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$PA <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/044"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$RI <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/045"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$SC <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/046"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$SD <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/047"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$TN <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/048"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$TX <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/049"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$UT <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/050"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$VT <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/051"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$VA <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/053"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$WA <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/054"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$WV <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/055"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$WI <- temp_data_df[,2]

url <- "http://livingwage.mit.edu/states/056"	
temp_data_df <- readHTMLTable(url,which=1)
temp_data_df <- temp_data_df[,1:2]
LW_data_df$WY <- temp_data_df[,2]

### delete the temp data container
rm(temp_data_df,url)

### create what will be our destination data frame
### note the t() syntax that will trnspose this matrix
### we have the states as column names, but need to rotate them to merge them 
### with other data types

livwag_df <- as.data.frame(t(LW_data_df))

# note the transposition in the obs/var counts in the upper right
# they correspond to the row/column counts

# note that the transpose has introduced some issues which are easily fixed

# we have an unintended consequence of the transpose in the first row
# pull out the values from selected cells in row 1 to be new column names
colnames(livwag_df) <- c(toString(livwag_df[1,1]),toString(livwag_df[1,2]),toString(livwag_df[1,3]))

# drop the first row because it's duplicative
livwag_df <- livwag_df[-1,]

# we also have an unintended consequence of the transpose in the row names
# convert the row names into a new variable called state which can be 
# used to merge data
livwag_df$state <- rownames(livwag_df)

# eliminate the old row names
rownames(livwag_df) <- c()

rm(LW_data_df)


################################# #################################
### bring in BLS data from LAUS
### note, to simplify this example, i am not downloading it
### in real time but bringing it in as a spreadsheet
################################# #################################

dat <- read.csv("ptable14full2016.csv")
dat <- dat[c(1:11)]
urate <- dat[dat$Group=="Total",]

################################# #################################
### Note that there is no way to merge the BLS LAUS data with the living
### wage data: living wage has two letter state abbreviations, BLS data
### has full state names.  We're going to use a utility table to translate.
### think of this as a rosetta stone....
################################# #################################

st.codes<-data.frame(
  state=(c("AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", 
           "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", 
           "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", 
           "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", 
           "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", 
           "VT", "WA", "WI", "WV", "WY")),
  FIPS=(c("2", "1", "5", "60", "4", "6", "8", "9", "11", "10", 
          "12", "13", "66", "15", "19", "16", "17", "18", "20", "21", 
          "22", "25", "24", "23", "26", "27", "29", "28", "30", "37", 
          "38", "31", "33", "34", "35", "32", "36", "39", "40", "41", 
          "42", "72", "44", "45", "46", "47", "48", "49", "51", "78", 
          "50", "53", "55", "54", "56")),
  fullcap=(c("ALASKA", "ALABAMA", "ARKANSAS", "AMERICAN SAMOA", "ARIZONA", "CALIFORNIA", "COLORADO", "CONNECTICUT", "DISTRICT OF COLUMBIA", "DELAWARE", 
             "FLORIDA", "GEORGIA", "GUAM", "HAWAII", "IOWA", "IDAHO", "ILLINOIS", "INDIANA", "KANSAS", "KENTUCKY", 
             "LOUISIANA", "MASSACHUSETTS", "MARYLAND", "MAINE", "MICHIGAN", "MINNESOTA", "MISSOURI", "MISSISSIPPI", "MONTANA", "NORTH CAROLINA", 
             "NORTH DAKOTA", "NEBRASKA", "NEW HAMPSHIRE", "NEW JERSEY", "NEW MEXICO", "NEVADA", "NEW YORK", "OHIO", "OKLAHOMA", "OREGON", 
             "PENNSYLVANIA", "PUERTO RICO", "RHODE ISLAND", "SOUTH CAROLINA", "SOUTH DAKOTA", "TENNESSEE", "TEXAS", "UTAH", "VIRGINIA", "VIRGIN ISLANDS", 
             "VERMONT", "WASHINGTON", "WISCONSIN", "WEST VIRGINIA", "WYOMING")),
  fulllow=(c("alaska", "alabama", "arkansas", "american samoa", "arizona", "california", "colorado", "connecticut", "district of columbia", "delaware", 
             "florida", "georgia", "guam", "hawaii", "iowa", "idaho", "illinois", "indiana", "kansas", "kentucky", 
             "louisiana", "massachusetts", "maryland", "maine", "michigan", "minnesota", "missouri", "mississippi", "montana", "north carolina", 
             "north dakota", "nebraska", "new hampshire", "new jersey", "new mexico", "nevada", "new york", "ohio", "oklahoma", "oregon", 
             "pennsylvania", "puerto rico", "rhode island", "south carolina", "south dakota", "tennessee", "texas", "utah", "virginia", "virgin islands", 
             "vermont", "washington", "wisconsin", "west virginia", "wyoming")),
  fullfirst=(c("Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District Of Columbia", "Delaware", 
               "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", 
               "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", 
               "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", 
               "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", 
               "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming")),
  region=(c("W", "SE", "SW", "NA", "W", "W", "SW", "NE", "NE", "NE", 
            "SE", "SE", "NA", "W", "MW", "W", "MW", "MW", "MW", "SE", 
            "SW", "NE", "NE", "NE", "MW", "MW", "MW", "SE", "SW", "SE", 
            "SW", "MW", "NE", "NE", "SW", "W", "NE", "MW", "SW", "W", 
            "NE", "NE", "NE", "SE", "SW", "SE", "SW", "SW", "NE", "NE", 
            "NE", "W", "MW", "NE", "SW"))
)

## Now we can use the st.codes file as a hinge to merge the living wage data 
## with the BLS data

labordat <- merge(urate,st.codes,by = 'FIPS')
labordat <- merge(labordat,livwag_df,by = 'state')
rm(dat,urate,livwag_df,st.codes)

## you can view the labor force data to see which variables you need
## optionally, you can drop the variables that are no longer necessary
labordat <- labordat[,-c(3,5,13:16)]

# create names without a space in them
colnames(labordat)[11] <- "livingwage"
colnames(labordat)[12] <- "povertywage"
colnames(labordat)[13] <- "minimumwage"

# insurance
labordat2 <- labordat

# strip out dollar sign and force character format
labordat$livingwage <- gsub("[$]", "", labordat$livingwage)
labordat$minimumwage <- gsub("[$]", "", labordat$minimumwage)
labordat$povertywage <- gsub("[$]", "", labordat$povertywage)

# check format
typeof(labordat$livingwage)

# compute difference
labordat$diffwage <- as.double(labordat$livingwage) - as.double(labordat$minimumwage)

# check format
typeof(labordat$unemp_rate)

# and because we rarely sit around importing data just for the heck of it, let's visualize this
# generate a very basic scatterplot: difference between living wage and minimum wage, and urate

plot(labordat$diffwage, labordat$emp_pct_of_pop, main="Living Wage Gap and Employment Rate", 
     xlab="Gap from Living Wage to Min Wage", ylab="Percent Employment in State Population", pch=19, cex.axis= .8)

text(labordat$diffwage, labordat$emp_pct_of_pop, labels=labordat$state, cex= 0.7, pos = 3)

plot(labordat$diffwage, labordat$unemp_rate, main="Living Wage Gap and Unemployment Rate", 
     xlab="Gap from Living Wage to Min Wage", ylab="SA State Unemployment Rate", pch=19, cex.axis= .8)

text(labordat$diffwage, labordat$unemp_rate, labels=labordat$state, cex= 0.7, pos = 3)

plot(labordat$diffwage, labordat$clf_pct_of_pop, main="CLF as % of Population and Employment Rate", 
     xlab="Gap from Living Wage to Min Wage", ylab="Civ Labor Force as a percent of Population", pch=19, cex.axis= .8)

text(labordat$diffwage, labordat$clf_pct_of_pop, labels=labordat$state, cex= 0.7, pos = 3)










