# clean up and add memory
rm(list = ls())
memory.limit(size = 56000)

#################################
##### PY18Q1 DATA ###############
################################
##load data: full clean data
library("rio")
library("bit64")
library("dplyr")
library("lubridate")
library("Hmisc")
library("tidyr")


print("Processing: ingesting data...")
wp <- import("C:\\Users\\Reuss.Kevin.L\\Documents\\Model Data\\WP.csv", header = FALSE)
vn.df <- import("C:\\Users\\Reuss.Kevin.L\\Documents\\Model Data\\variable_names2.xlsx")

head(wp)

variable_number <- vn.df$`Number`
PIRL <- vn.df$`PIRL`
colnames(wp) <- PIRL
head(wp)

period <- import("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\MSG Model\\Reporting Period.csv", header = TRUE)
period[,c(5:9)] <- lapply(period[,c(5:9)], ymd)
fips.df <- import("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\MSG Model\\FIPS.csv", header = TRUE)
wp$fips <- fips.df[match(wp$`p3000`, fips.df$`Alpha code`),3]

wp[,c('p1811','p900','p901','p1806','p1807','p1808','p1809','p1810')] <- lapply(wp[,c('p1811','p900','p901','p1806','p1807','p1808','p1809','p1810')], ymd)

wp$PY2017 <- ifelse(((wp$`p901`>=period[period$PY=="2017",5]) & (wp$`p901` <= period[period$PY=="2017",6])),1, NA)

wp17 <- wp %>% filter(PY2017==1)


wp17v <- wp17 %>% filter(p309==1)

wp17ve <- wp17v %>% filter(p1602==1 | p1602==2 | p1603==3)

export(wp17v, "C:\\Users\\Reuss.Kevin.L\\Documents\\Model Data\\PY18Q1\\HVRP_17.csv")


