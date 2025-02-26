# clean up
rm(list = ls())
memory.limit(size = 56000)
# set working directory
setwd("~/learn/basicr/")


### basics: read in the data
require(data.table)
mydata <- fread("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Infographics\\WIOAPerformanceRecords_PY2017Q4_PUBLIC.csv")
colnames(mydata)


###FEMALE#####################
femalecount = sum(mydata$`PIRL 201` == 2, na.rm=TRUE)
femalewagner = sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 918`==1, na.rm=TRUE)
femaleadult = sum(mydata$`PIRL 201` == 2 & (mydata$`PIRL 903`==1|mydata$`PIRL 903`==2|mydata$`PIRL 903`==3), na.rm=TRUE)
femaledislocated = sum(mydata$`PIRL 201` == 2 & (mydata$`PIRL 904`==1|mydata$`PIRL 904`==2|mydata$`PIRL 904`==3), na.rm=TRUE)
femaleyouth = sum(mydata$`PIRL 201` == 2 & (mydata$`PIRL 905`==1|mydata$`PIRL 905`==2|mydata$`PIRL 905`==3), na.rm=TRUE)
femaletotal = femalewagner+femaleadult+femaledislocated+femaleyouth
femalepercentwagner = (femalewagner/femalecount)*100
femalepercentadult = (femaleadult/femalecount)*100
femalepercentdislocated = (femaledislocated/femalecount)*100
femalepercentyouth = (femaleyouth/femalecount)*100
femaleveterans = sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 300`==1, na.rm=TRUE)
femaleskillsdevelopmenttraining = sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 1300`==1, na.rm=TRUE)
femalesingleparent = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 806`==1, na.rm=TRUE)/femalecount)*100)
femalelowincome = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 802`==1, na.rm=TRUE)/femalecount)*100)
femaleSNAP = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 603`==1, na.rm=TRUE)/femalecount)*100)
femaleskilldeficiency = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 804`==1, na.rm=TRUE)/femalecount)*100)
femaleoffender = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 801`==1, na.rm=TRUE)/femalecount)*100)
femalewhite = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 215`==1, na.rm=TRUE)/femalecount)*100)
femaleblack = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 213`==1, na.rm=TRUE)/femalecount)*100)
femalelatina = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 210`==1, na.rm=TRUE)/femalecount)*100)
femalenative = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 211`==1, na.rm=TRUE)/femalecount)*100)
femaleasian = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 212`==1, na.rm=TRUE)/femalecount)*100)
femalehawaiian = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 214`==1, na.rm=TRUE)/femalecount)*100)

femalecount
femalepercentwagner
femalepercentadult
femalepercentdislocated
femalepercentyouth
femaleveterans
femaleskillsdevelopmenttraining
femalesingleparent
femalelowincome
femaleSNAP
femaleskilldeficiency
femaleoffender
femalewhite
femaleblack
femalelatina
femalenative
femaleasian
femalehawaiian

###BLACK#########################
blackcount = sum(mydata$`PIRL 213` == 1, na.rm=TRUE)
blackwagner = sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 918`==1, na.rm=TRUE)
blackadult = sum(mydata$`PIRL 213` == 1 & (mydata$`PIRL 903`==1|mydata$`PIRL 903`==2|mydata$`PIRL 903`==3), na.rm=TRUE)
blackdislocated = sum(mydata$`PIRL 213` == 1 & (mydata$`PIRL 904`==1|mydata$`PIRL 904`==2|mydata$`PIRL 904`==3), na.rm=TRUE)
blackyouth = sum(mydata$`PIRL 213` == 1 & (mydata$`PIRL 905`==1|mydata$`PIRL 905`==2|mydata$`PIRL 905`==3), na.rm=TRUE)
blacktotal = blackwagner+blackadult+blackdislocated+blackyouth
blackpercentwagner = (blackwagner/blackcount)*100
blackpercentadult = (blackadult/blackcount)*100
blackpercentdislocated = (blackdislocated/blackcount)*100
blackpercentyouth = (blackyouth/blackcount)*100
blackveteran = sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 300`==1, na.rm=TRUE)
blackfemale = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 213` == 1, na.rm=TRUE))/blackcount)*100
blackmale = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 213` == 1, na.rm=TRUE))/blackcount)*100
blackdevelopmenttraining = sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 1300`==1, na.rm=TRUE)
blackpercentother = (sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 1303`==06, na.rm=TRUE)/blackdevelopmenttraining)*100
blackpercentupgrading = (sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 1303`==02, na.rm=TRUE)/blackdevelopmenttraining)*100
blackpercentyouthoccupational = (sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 1303`==10, na.rm=TRUE)/blackdevelopmenttraining)*100
blackpercentotj = (sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 1303`==01, na.rm=TRUE)/blackdevelopmenttraining)*100
blackpercentabe = (sum(mydata$`PIRL 213` == 1 & (mydata$`PIRL 1303`==04|mydata$`PIRL 1303`==07), na.rm=TRUE)/blackdevelopmenttraining)*100
blackpercentlowincome = ((sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 802`==1, na.rm=TRUE)/blackcount)*100)
blackpercentSNAP = ((sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 603`==1, na.rm=TRUE)/blackcount)*100)
blackpercentsingleparent  = ((sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 806`==1, na.rm=TRUE)/blackcount)*100)
blackpercentoffender = ((sum(mydata$`PIRL 213` == 1 & mydata$`PIRL 801`==1, na.rm=TRUE)/blackcount)*100)

blackpercentwagner
blackpercentdislocated
blackpercentadult
blackpercentyouth
blackcount
blackveteran
blackfemale
blackmale
blackdevelopmenttraining
blackpercentother
blackpercentupgrading
blackpercentyouthoccupational
blackpercentotj
blackpercentabe
blackpercentlowincome
blackpercentSNAP
blackpercentsingleparent
blackpercentoffender

###ASIAN######################
asiancount = sum(mydata$`PIRL 212` == 1, na.rm=TRUE)
asianwagner = sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 918`==1, na.rm=TRUE)
asianadult = sum(mydata$`PIRL 212` == 1 & (mydata$`PIRL 903`==1|mydata$`PIRL 903`==2|mydata$`PIRL 903`==3), na.rm=TRUE)
asiandislocated = sum(mydata$`PIRL 212` == 1 & (mydata$`PIRL 904`==1|mydata$`PIRL 904`==2|mydata$`PIRL 904`==3), na.rm=TRUE)
asianyouth = sum(mydata$`PIRL 212` == 1 & (mydata$`PIRL 905`==1|mydata$`PIRL 905`==2|mydata$`PIRL 905`==3), na.rm=TRUE)
asiantotal = asianwagner+asianadult+asiandislocated+asianyouth
asianwagner = (asianwagner/asiancount)*100
asianadult = (asianadult/asiancount)*100
asiandislocated = (asiandislocated/asiancount)*100
asianyouth = (asianyouth/asiancount)*100
asianveteran = sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 300`==1, na.rm=TRUE)
asiandevelopmenttraining = sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1300`==1, na.rm=TRUE)
asianpercentother = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==06, na.rm=TRUE)/asiandevelopmenttraining)*100
asianpercentupgrading = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==02, na.rm=TRUE)/asiandevelopmenttraining)*100
asianpercentyouthoccupational = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==10, na.rm=TRUE)/asiandevelopmenttraining)*100
asianpercentotj = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==01, na.rm=TRUE)/asiandevelopmenttraining)*100
asianpercentabe = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==04, na.rm=TRUE)/asiandevelopmenttraining)*100
asianpercentremedial = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==07, na.rm=TRUE)/asiandevelopmenttraining)*100
asianpercentcustomized = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==05, na.rm=TRUE)/asiandevelopmenttraining)*100
asianpercentothernonocc = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==11, na.rm=TRUE)/asiandevelopmenttraining)*100
asianpercentprereq = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==08, na.rm=TRUE)/asiandevelopmenttraining)*100
asianpercentapprenticeship = (sum(mydata$`PIRL 212` == 1 & mydata$`PIRL 1303`==09, na.rm=TRUE)/asiandevelopmenttraining)*100

asiancount
asianwagner
asianadult
asiandislocated
asianyouth
asianveteran
asiandevelopmenttraining
asianpercentother
asianpercentabe
asianpercentupgrading
asianpercentotj
asianpercentcustomized
asianpercentyouthoccupational
asianpercentremedial
asianpercentothernonocc
asianpercentprereq
asianpercentapprenticeship

###HISPANIC#######################

hiscount = sum(mydata$`PIRL 210` == 1, na.rm=TRUE)
hiswagner = sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 918`==1, na.rm=TRUE)
hisadult = sum(mydata$`PIRL 210` == 1 & (mydata$`PIRL 903`==1|mydata$`PIRL 903`==2|mydata$`PIRL 903`==3), na.rm=TRUE)
hisdislocated = sum(mydata$`PIRL 210` == 1 & (mydata$`PIRL 904`==1|mydata$`PIRL 904`==2|mydata$`PIRL 904`==3), na.rm=TRUE)
hisyouth = sum(mydata$`PIRL 210` == 1 & (mydata$`PIRL 905`==1|mydata$`PIRL 905`==2|mydata$`PIRL 905`==3), na.rm=TRUE)
histotal = hiswagner+hisadult+hisdislocated+hisyouth
hiswagner = (hiswagner/hiscount)*100
hisadult = (hisadult/hiscount)*100
hisdislocated = (hisdislocated/hiscount)*100
hisyouth = (hisyouth/hiscount)*100
hisveteran = sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 300`==1, na.rm=TRUE)
hisfemale = ((sum(mydata$`PIRL 201` == 2 & mydata$`PIRL 210` == 1, na.rm=TRUE))/hiscount)*100
hismale = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 210` == 1, na.rm=TRUE))/hiscount)*100
hisdevelopmenttraining = sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 1300`==1, na.rm=TRUE)
hisother = (sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 1303`==06, na.rm=TRUE)/hisdevelopmenttraining)*100
hisupgrading = (sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 1303`==02, na.rm=TRUE)/hisdevelopmenttraining)*100
hisyouthocc = (sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 1303`==10, na.rm=TRUE)/hisdevelopmenttraining)*100
hisotj = (sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 1303`==01, na.rm=TRUE)/hisdevelopmenttraining)*100
hisabe = (sum(mydata$`PIRL 210` == 1 & (mydata$`PIRL 1303`==04|mydata$`PIRL 1303`==07), na.rm=TRUE)/hisdevelopmenttraining)*100
hislowincome = ((sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 802`==1, na.rm=TRUE)/hiscount)*100)
hisSNAP = ((sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 603`==1, na.rm=TRUE)/hiscount)*100)
hissingleparent  = ((sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 806`==1, na.rm=TRUE)/hiscount)*100)
hisoffender = ((sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 801`==1, na.rm=TRUE)/hiscount)*100)
hisesl = ((sum(mydata$`PIRL 210` == 1 & mydata$`PIRL 803`==1, na.rm=TRUE)/hiscount)*100)

hiswagner
hisdislocated
hisadult
hisyouth
hiscount
hisveteran
hisfemale
hismale
hisdevelopmenttraining
hisother
hisupgrading
hisabe
hisyouthocc
hisotj
hissingleparent
hislowincome
hisesl 
hisSNAP
hisoffender

###MALE########################
malecount = sum(mydata$`PIRL 201` == 1, na.rm=TRUE)
malewagner = sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 918`==1, na.rm=TRUE)
maleadult = sum(mydata$`PIRL 201` == 1 & (mydata$`PIRL 903`==1|mydata$`PIRL 903`==2|mydata$`PIRL 903`==3), na.rm=TRUE)
maledislocated = sum(mydata$`PIRL 201` == 1 & (mydata$`PIRL 904`==1|mydata$`PIRL 904`==2|mydata$`PIRL 904`==3), na.rm=TRUE)
maleyouth = sum(mydata$`PIRL 201` == 1 & (mydata$`PIRL 905`==1|mydata$`PIRL 905`==2|mydata$`PIRL 905`==3), na.rm=TRUE)
maletotal = malewagner+maleadult+maledislocated+maleyouth
malewagner = (malewagner/maletotal)*100
maleadult = (maleadult/maletotal)*100
maledislocated = (maledislocated/maletotal)*100
maleyouth = (maleyouth/femaletotal)*100
maleveteran = sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 300`==1, na.rm=TRUE)
maledevelopmenttraining = sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 1300`==1, na.rm=TRUE)
maleother = (sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 1303`==06, na.rm=TRUE)/maledevelopmenttraining)*100
maleupgrading = (sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 1303`==02, na.rm=TRUE)/maledevelopmenttraining)*100
maleojt = (sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 1303`==01, na.rm=TRUE)/maledevelopmenttraining)*100
maleyouthocc = (sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 1303`==10, na.rm=TRUE)/maledevelopmenttraining)*100
maleabe =  (sum(mydata$`PIRL 201` == 1 & (mydata$`PIRL 1303`==04|mydata$`PIRL 1303`==07), na.rm=TRUE)/maledevelopmenttraining)*100
malecustomized =  (sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 1303`==05, na.rm=TRUE)/maledevelopmenttraining)*100
malesingleparent = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 806`==1, na.rm=TRUE)/malecount)*100)
malelowincome = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 802`==1, na.rm=TRUE)/malecount)*100)
maleoffender = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 801`==1, na.rm=TRUE)/malecount)*100)
malewhite = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 215`==1, na.rm=TRUE)/malecount)*100)
maleblack = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 213`==1, na.rm=TRUE)/malecount)*100)
malehispanic = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 210`==1, na.rm=TRUE)/malecount)*100)
malenative = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 211`==1, na.rm=TRUE)/malecount)*100)
maleasian = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 212`==1, na.rm=TRUE)/malecount)*100)
malehawaiian = ((sum(mydata$`PIRL 201` == 1 & mydata$`PIRL 214`==1, na.rm=TRUE)/malecount)*100)

malecount
maleveteran
malewagner
maleadult
maledislocated
maleyouth
maledevelopmenttraining
maleother
maleupgrading
maleojt
maleyouthocc
maleabe
malecustomized
malelowincome
malesingleparent
maleoffender
malewhite
maleblack
malehispanic
malenative
maleasian
malehawaiian

###YOUTH######################
youthcount = sum(mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3, na.rm=TRUE)
youthinschool = sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3)&(mydata$`PIRL 409`==1|mydata$`PIRL 409`==2|mydata$`PIRL 409`==3), na.rm=TRUE)
youthoutschool = sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3)&(mydata$`PIRL 409`==4|mydata$`PIRL 409`==5|mydata$`PIRL 409`==6), na.rm=TRUE)
youthinschool = (youthinschool/(youthinschool+youthoutschool))*100
youthoutshcool = (youthoutschool/(youthinschool+youthoutschool))*100
youthfemale = ((sum(mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3, na.rm=TRUE))/youthcount)*100
youthmale = ((sum(mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3, na.rm=TRUE))/youthcount)*100
youthsupportive = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 1409`, na.rm=TRUE)/youthcount)*100)
youthworkexperience
youthcomprehensive = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 1411`, na.rm=TRUE)/youthcount)*100)
youthtutoring
youthleadership
youthsummer
youthwhite = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 215`==1, na.rm=TRUE)/youthcount)*100)
youthblack = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 213`==1, na.rm=TRUE)/youthcount)*100)
youthhispanic = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 210`==1, na.rm=TRUE)/youthcount)*100)
youthnative = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 211`==1, na.rm=TRUE)/youthcount)*100)
youthasian = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 212`==1, na.rm=TRUE)/youthcount)*100)
youthhawaiian = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 214`==1, na.rm=TRUE)/youthcount)*100)
youthmultiple
dob = as.Date(mydata$`PIRL 200`, format="%Y%m%d", na.rm=TRUE)
refDate = as.Date("2007-11-30", format="%Y%m%d")
library ('eeptools')
age = age_calc(na.omit(dob), enddate=refDate, units='years', precise=TRUE)
age = mydata$age[!is.na(mydata$dob)]
age

mydata$PIRL200 <- as.character(mydata$PIRL200)
mydata$PIRL200[is.na(mydata$PIRL200)] <- "19000101"
mydata$PIRL200 <- as.Date(mydata$PIRL200, "%Y%m%d")
mydata$PIRL200[mydata$PIRL200 == as.Date("19000101", "%Y%m%d")] <- NA

#typeof(pirl$PIRL200)
#year(pirl$PIRL900[1])
#year(pirl$PIRL200[1])
#head(pirl$PIRL900)
#head(pirl$PIRL200)

library(lubridate)

## compute age according to ETA protocol
mydata$age = year(mydata$PIRL900) - year(mydata$PIRL200)
describe(mydata$age)
mydata$age <- ifelse( (month(mydata$PIRL900) < month(mydata$PIRL200)) | (month(mydata$PIRL900) == month(mydata$PIRL200) & day(mydata$PIRL900) < day(mydata$PIRL200)), mydata$age - 1 , mydata$age)
describe(mydata$age)

mydata$age = year(mydata$PIRL900) - year(mydata$PIRL200)
youth14 = 
youth16
youth19
youth22
youthlowincome = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 802`==1, na.rm=TRUE)/youthcount)*100)
youthsingleparent  = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 806`==1, na.rm=TRUE)/youthcount)*100)
youthoffender = ((sum((mydata$`PIRL 905` == 1 | mydata$`PIRL 905` == 2 | mydata$`PIRL 905` == 3) & mydata$`PIRL 801`==1, na.rm=TRUE)/youthcount)*100)
youthell
youthdisability
youthhomeless
youthfoster
youthunemployed

youthcount
youthinschool
youthoutschool
youthfemale
youthmale
youthsupportive
youthworkexperience
youthcomprehensive
youthtutoring
youthleadership
youthsummer  ######52% of all work experiences were summer employment
youthwhite
youthblack
youthhispanic
youthmultiple
youthnative
youthasian
youthhawaiian
youth14
youth16
youth19
youth22
youthlowincome
youthell
youthdisability
youthsingleparent
youthoffender
youthhomeless
youthfoster
youthunemployed

