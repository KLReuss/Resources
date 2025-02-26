rm(list = ls())
memory.limit(size = 56000)


library("rio")
library("bit64")
print("Processing: ingesting data...")
PY18.df <- import("C:\\Users\\Reuss.Kevin.L\\Documents\\Model Data\\PY18Q1\\PY18.csv", header=TRUE)

library("dplyr")
library("lubridate")
library("Hmisc")
library("tidyr")

quarter.df <- import("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\MSG Model\\Quarter Data.csv", header = TRUE)
quarter.df[,c(5:9)] <- lapply(quarter.df[,c(5:9)], ymd)

PY18.df$PY2016 <- ifelse((PY18.df$'900'<= quarter.df[PY18.df$PY =="2016",6]) &
                         ((PY18.df$`901`>=quarter.df[quarter.df$PY=="2016",5]) | is.na(PY18.df$`901`)) &
                         ((PY18.df$`923` == "0") | (PY18.df$`923`=="7") | (is.na(PY18.df$`923`))),1, NA)

print("completed")

PY16 <- PY18.df %>% filter(PY2016==1)
PY16_TX <- PY16 %>% filter('101'=="TX")

# clean up
rm(list = ls())
# set working directory
setwd("~/learn/basicr/")


### basics: read in the data
mydata <- import("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\WIOAPerformanceRecords_PY2017Q3_FULL.csv", header = FALSE)

vn.df <- import("C:\\Users\\Reuss.Kevin.L\\Documents\\Model Data\\variable_names.xlsx")
variable_name <- vn.df$`Variable Name`
PIRL <- vn.df$`PIRL #`

PY16_TX <- mydata %>% filter(V238=="TX")

exit_allPY16 <- count(PY16_TX, (!is.na(V68)&V68<=20170630))

exit_allPY16 <- count(PY16_TX, V68<=20170630 & V68>=20160701)
exitwtrain_allPY16 <- count(PY16_TX, (!is.na(V68)&V68<=20170630)&V143==1)

count(PY16_TX, V68<=20170330)
count(PY16_TX, (!is.na(V68)&(V83==1)))

count(PY16_TX, ((V68>=20160701 & V68<=20170630)&(V69==1|V69==2|V69==3|V70==1|V70==2|
                                                V70==3|V71==1|V71==2|V71==3|V75==1)))
count(PY16_TX, (V68>=20160701 & V68<=20170630))

count(PY16_TX, ((V68>=20160701 & V68<=20170630)&(V69==3)))
count(PY16_TX, ((V68>=20160701 & V68<=20170630)&(V69==1|V69==2|V69==3|V70==1|V70==2|
                                                   V70==3|V71==1|V71==2|V71==3)))
count(PY16_TX, ((V68>=20160701 & V68<=20170630)&(V70==1|V70==2|
                                                   V70==3|V71==1|V71==2|V71==3)))
count(PY16_TX, ((V68>=20160701 & V68<=20170630)&(V70==3)))
count(PY16_TX, ((V68>=20160701 & V68<=20170630)&(V71==3)))
count(PY16_TX, ((V68>=20160701 & V68<=20170630)&(V69==1|V69==2|V69==3|V70==1|V70==2|
                                                   V70==3|V71==1|V71==2|V71==3)&V143==1))
count(PY16_TX, ((V68>=20160701 & V68<=20170630)&(V69==1|V70==1|V71==1)))


count(PY16_TX, ((V68>=20160701 & V68<=20170630)&(V69==1|V69==2|V69==3|V70==1|V70==2|
                                                V70==3|V71==1|V71==2|V71==3|V75==1)&V143==1))

count(PY16_TX, ((V68>=20170701 & V68<=20180630)&(V69==1|V69==2|V69==3|V70==1|V70==2|
                                                   V70==3|V71==1|V71==2|V71==3|V75==1)))


mydata1 <- import("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\adult17_raw.csv", header = TRUE)
PY17_TX <- mydata1 %>% filter(pirl101=="TX")
mydata1a <- import("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\dw17_raw.csv", header = TRUE)
PY17_TXa <- mydata1a %>% filter(pirl101=="TX")
mydata1b <- import("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\youth17_raw.csv", header = TRUE)
PY17_TXb <- mydata1b %>% filter(pirl101=="TX")
count(PY17_TX, (pirl901>=20170701 & pirl901<=20180630))
count(PY17_TXa, (pirl901>=20170701 & pirl901<=20180630))
count(PY17_TXb, (pirl901>=20170701 & pirl901<=20180630))