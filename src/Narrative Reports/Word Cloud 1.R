setwd("C:\\Users\\Reuss.Kevin.L\\Documents\\R")

### basics: read in the data
mydata <- read.csv("WIOAPerformanceRecords_PY2017Q3_FULL.csv")
colnames(mydata)
head(mydata)

mydata <- read.csv("osha_sandy.csv")

memory.limit()

memory.limit(size=50000)
