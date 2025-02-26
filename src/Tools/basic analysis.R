###  Introduction to analysis: outline
###  -------------------------------------------
###  Exploratory data analysis
###  Example of basic linear regression
###  Template code for regression diagnostics
###  exploring regression objects, extracting useful components
###  Example of basic nonlinear regression (logistic)
###  R template ccode for in-sample/out of sample analysis with metrics
###  a basic model for forward stepwise regression 
###  -------------------------------------------

list.of.packages <- c("Hmisc", "foreign", "Metrics", "car", "schoRsch", "foreign", "ResourceSelection", "lmtest")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

rm(list = ls())

# set working directory
setwd("~/learn/basicr/")

### basics: read in the data
mydata <- read.csv("UI Initial Claims and Google Searches 4-7-2017.csv")
colnames(mydata)

# get rid of the vast empty spaces
mydata <- mydata[,-c(9:10)]
mydata <- mydata[1:264,]

# simplify the variable names just a bit
colnames(mydata)
names(mydata)[6] <- "google.index.1"
names(mydata)[7] <- "google.index.2"
names(mydata)[8] <- "google.index.3"
colnames(mydata)

typeof(mydata$UI.week.ending)
head(mydata)

###some basic elements of exploratory data analysis
### in addition to the code below, here are some helpful links with simple code templates
### https://www.r-bloggers.com/exploratory-data-analysis-useful-r-functions-for-exploring-a-data-frame/
### https://www.r-bloggers.com/exploratory-data-analysis-using-r-part-i/
### http://r4ds.had.co.nz/exploratory-data-analysis.html

# quick summary :: descriptive stats
library(Hmisc)
describe(mydata$UI.scaled.2)
describe(mydata$google.index.1)

### basic plot looking at correlations
xyplot(UI.scaled.2 ~ google.index.1, data = mydata,
       xlab = "Google Searches for Unemployment Insurance (Index)",
       ylab = "Count of Unemployment Insurance Claims",
       main = "Scatter Plot of UI Claims and Google Searches for UI")

### Time plot looking at covariation across observations
plot(mydata$UI.scaled.2, xlim = c(0,270),ylim = c(0,110), type="n", main="line plot") 
lines(mydata$UI.scaled.2, type="o", col = "blue") 
lines(mydata$google.index.1, type="o", col = "red") 
lines(mydata$google.index.2, type="o", col = "green") 
lines(mydata$google.index.3, type="o", col = "yellow") 

### Look at correlation plot/matrix to evaluate among the 
### potential explantory variables
panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...) 
{ 
  usr <- par("usr"); on.exit(par(usr)) 
  par(usr = c(0, 1, 0, 1)) 
  r <- abs(cor(x, y)) 
  txt <- format(c(r, 0.123456789), digits=digits)[1] 
  txt <- paste(prefix, txt, sep="") 
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt) 
  text(0.5, 0.5, txt, cex = cex.cor * r) 
} 

pairs(~UI.scaled.1 + google.index.1 + google.index.2 + google.index.3,  
      data=mydata, 
      lower.panel=panel.smooth,  
      upper.panel=panel.cor,  
      pch=20,  
      main="Correlation Among UI claims Data and Google Searches") 

### check for missing values, look at variation among the values
sapply(mydata,function(x) sum(is.na(x)))
sapply(mydata, function(x) length(unique(x)))

## build test model
model1 <- lm(UI.scaled.1 ~ google.index.3, data = mydata)

## running that regression creates a "regression object" called model1
typeof(model1)
## it's a complex list object
model1


## An object of class "lm" is a list containing at least the following components:
## coefficients, residuals, fitted.values, rank, weights, df.residual, call, 
## terms, contrasts, xlevels, offset, y, x, model, na.action	
## type "?lm" to see the details, check the "value" entry for more details

model1[1]  ## coefficients
model1[2]  ## residuals
model1[3]  ## fitted values

## by default, calling the object gives a brief summary(model and coefficients)
model1

## using summary() to get better model output and some diagnostics
summary(model1)

## some diagnostic plots along the lines of the following: 
## http://data.library.virginia.edu/diagnostic-plots/

## residual diagnostic plot
xyplot(resid(model1) ~ fitted(model1),
       xlab = "Fitted Values",
       ylab = "Residuals",
       main = "Residual Diagnostic Plot",
       panel = function(x, y, ...)
       {
         panel.grid(h = -1, v = -1)
         panel.abline(h = 0)
         panel.xyplot(x, y, ...)
       }
)

## quantile diagnostic plot
qqmath( ~ resid(model1),
        xlab = "Theoretical Quantiles",
        ylab = "Residuals"
)

# get all the diagnostic plots in one view....
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(model1)

dev.off()

## You don't necessarily need to use indexes to gather all of the 
## regression object output.  there are basic calls and functions 
## that dramatically simplify this, and they are intuitive

coefficients(model1) # model coefficients
confint(model1, level=0.95) # CIs for model parameters 
fitted(model1) # predicted values
residuals(model1) # residuals
anova(model1) # anova table 
vcov(model1) # covariance matrix for model parameters 
influence(model1) # https://en.wikipedia.org/wiki/Influential_observation

library(car)  ## helpful diagnostic functions
# Assessing Outliers
outlierTest(model1) # Bonferonni p-value for most extreme obs
qqPlot(model1, main="QQ Plot") #qq plot for studentized resid 
leveragePlots(model1) # leverage plots

# Influential Observations
av.plots(model1)
# Cook's D plot
# identify D values > 4/(n-k-1) 
cutoff <- 4/((nrow(mydata)-length(model1$coefficients)-2)) 
plot(model1, which=4, cook.levels=cutoff)
# Influence Plot 
# influencePlot(model1, id.method="identify", main="Influence Plot", sub="Circle size is proportial to Cook's Distance" )


### there is a very good resource on inference in regression using R 
### including comparing models at the following:
###   https://cran.r-project.org/doc/contrib/Faraway-PRA.pdf
### important note: this is not statistical advice, just R programming advice.
### please do execise prudence when using any of these methods to draw conclusions 

## reminder that the first model is as follows
model1 <- lm(UI.scaled.1 ~ google.index.1, data = mydata)

## build a second test model
model2 <- lm(UI.scaled.1 ~ google.index.1, data = mydata)

anova(model1, model2)

######################################################################
rm(list = ls())
dev.off()

# set path, read in data set.  Note, you generally need to "saveold" in stata to import in R...
library(foreign)
mydata <- read.dta("counties_old.dta")

# this is a technical detail, there are some aspects of R that don't handle missing data in an automatic fashion.
# the data set contains some NAs, and these need to be removed before much meaningful analysis can be performed
# fortunately, it's pretty easy to do....(note: the stata and r file may be working with different numbers of cases 
# so exercise caution when comparing results between the files please.

mydata <- mydata[complete.cases(mydata[,15:17]),]

# create possible dependent variables

mydata$dmaj <- ifelse((mydata$democrat> mydata$republican & mydata$democrat> mydata$Perot), c(1), c(0) )
mydata$rmaj <- ifelse((mydata$republican > mydata$democrat & mydata$republican > mydata$Perot), c(1), c(0) )
mydata$imaj <- ifelse((mydata$Perot > mydata$republican & mydata$Perot > mydata$democrat), c(1), c(0) )

# option to make the statistical diagnostic output easier to read, no scientific notation, force decimals
options(scipen=999)

# the syntax below will run a regression and create a regression object
# note that here we are using the GLM (general linear model) and specifying 
# a distribution to use.  in this case, the binomial distribution will yield
# a logistic regression.  you could do poisson, exponential, etc.

# this is the intiial run with a very basic logit model...
logit1 <- glm(rmaj ~ pop, data = mydata, family = "binomial")

# to visualize an object, simply type it's name, or request a sumamry of it which will have additional formating.
logit1
summary(logit1)

# odds ratios
exp(coef(logit1))

# we will start making a decile table for this very basic model
# compute predicted values from logistic regression
mydata$pred <- predict(logit1, mydata, type="response")

### step 1 sort data on predicted scores
### note that some implementations of ntiles (below) will do this sort but it's a good idea to be sure...
mydata <- mydata[order(mydata$pred),]

### step 2 now that data is sorted, break data into groups of even size, generally 10 or 20
### the ntiles function resides in a few different libraries, i am using the schoRsch library version
library(schoRsch)
mydata$decile <- ntiles(mydata, dv="pred", bins=10)

### step 3 aggregate predictions into a mean response by decile
dectab <- aggregate(mydata$pred, list(dec = mydata$decile), mean)
dectab

### step 4 aggregate actuals to look at how predictions compare to actuals
dectab <- aggregate(mydata$rmaj, list(dec = mydata$decile), mean)
dectab

####################################################
# next, let's add some variables and test the models to see if we have a 
# significantly better product...

logit2 <- glm(rmaj ~ pop+white+farm+turnout,
              data = mydata, family = "binomial")

summary(logit1)
summary(logit2)

logLik(logit1)
logLik(logit2)

library(lmtest)
waldtest(logit1,logit2)

####################################################
# next, a slightly more helpful example using a more suitable regression spec

logit1 <- glm(rmaj ~ farm+college+age6574+popdensity+popchange+turnout,
              data = mydata, family = "binomial")


logit2 <- glm(rmaj ~ white+farm+college+age6574+popdensity+popchange+turnout,
              data = mydata, family = "binomial")

summary(logit1)
summary(logit2)

logLik(logit1)
logLik(logit2)

library(lmtest)
waldtest(logit1,logit2)


# finally, somerthing approaching a decent model....
# we will make some new variables and run a much more complete regression spec

mydata$col_inc <- mydata$college * mydata$income
mydata$col_crime <- mydata$college * mydata$crime

logit1<-glm(rmaj~white+farm+col_inc+col_crime+crime+college+income+
              popdensity+popchange+turnout+state,
            data = mydata, family = "binomial")

summary(logit1)


mydata$pred <- predict(logit1, mydata, type="response")
mydata <- mydata[order(mydata$pred),]
mydata$decile <- ntiles(mydata, dv="pred", bins=10)
dectab <- aggregate(mydata$pred, list(dec = mydata$decile), mean)
dectab
dectab <- aggregate(mydata$rmaj, list(dec = mydata$decile), mean)
dectab

## run a goodness of fit test called hosmer lemeshow.
## 


library(ResourceSelection)
hls <- hoslem.test(logit1$y, fitted(logit1), g=10)
hls

library(ResourceSelection)
hls <- hoslem.test(logit1$y, fitted(logit1), g=20)
hls

## important note: measures like R^2 are measures of predictive power, that is, how well 
## you can predict the dependent variable based on the independent variables. 
## That may be an important concern, but it doesn't really address the question of whether 
## the model is consistent with the data.  By contrast, goodness-of-fit (GOF) tests help 
## you decide whether your model is correctly specified. They produce a p-value-if it's 
## low (say, below .05), you reject the model. If it's high, then your model passes the test.

## ref the very excellent articles here:
## http://statisticalhorizons.com/hosmer-lemeshow

***********************************************
  
# bootstrap confidence intervals for model, not necessary for this exercise...
confint(logit1)
confint.default(logit1)

# ------------------------------  
#Load library to do ROC calculations & plots

#url <- "https://cran.r-project.org/src/contrib/pROC_1.13.0.tar.gz"
#download.file(url, "pROC_1.13.0.tar.gz")
#install.packages("pROC_1.13.0.tar.gz", repos = NULL, type="source")
#system("rm pROC_1.13.0.tar.gz")

# library(pROC) 
# create initial ROC data array
# roc(mydata$rmaj, mydata$pred)

# create initial ROC object and plot.  Library brings all necessary functions
# rocobj <- plot.roc(mydata$rmaj, mydata$pred)
# plot(rocobj)

# compute bootstrap confidence intervals, create interval objects and plot
# ci.thresholds.obj <- ci.thresholds(rocobj)
# plot(ci.thresholds.obj)

#########################################################
# R code for in-sample/out of sample analysis

library(foreign)
rm(list = ls())
dev.off()
mydata <- read.dta("counties_old.dta")
mydata <- mydata[complete.cases(mydata[,15:17]),]
mydata$dmaj <- ifelse((mydata$democrat> mydata$republican & mydata$democrat> mydata$Perot), c(1), c(0) )
mydata$rmaj <- ifelse((mydata$republican > mydata$democrat & mydata$republican > mydata$Perot), c(1), c(0) )
mydata$imaj <- ifelse((mydata$Perot > mydata$republican & mydata$Perot > mydata$democrat), c(1), c(0) )
options(scipen=999)
mydata$col_inc <- mydata$college * mydata$income
mydata$col_crime <- mydata$college * mydata$crime


# code to build data for example, create random variable
mydata$rand <- runif(nrow(mydata))

# sort on random variable
mydata <- mydata[order(mydata$rand),]

# subset the data.  Note, this is a bit quick and dirty and one case may end up in, or out, of both files.  with repeated trials,
# it should have a virtually no impact.  this is just to illustrtae the principle
model <- mydata[1:((nrow(mydata)/3)*2),]
validate <- mydata[((nrow(mydata)/3)*2):nrow(mydata),]

# run basic regression spec and create deciles for comparison
logit1 <- glm(rmaj~white+farm+col_inc+col_crime+crime+college+income+
                popdensity+popchange+turnout+state, 
              data = model, family = "binomial")
logit1

## compute predicted values from logistic regression for the model data set
model$pred <- predict(logit1, model, type="response")
## and now compute predicted values from the model logit spec for the validation data set
validate$pred <- predict(logit1, validate, type="response")

## is the distribution of predicted values smiilar between the sample abd validation runs?
hist(model$pred, breaks = 12)
hist(validate$pred, breaks = 12)

## is the out out-of-sample MSE cmoparable to the in-sample MSE?
## substantively different error measures imply that the model is not specified correctly.  

library(Metrics)
mse(model$rmaj, model$pred)
mse(validate$rmaj, validate$pred)

mae(model$rmaj, model$pred)
mae(validate$rmaj, validate$pred)

#######################################################
rm(model, validate, logit1)

## a basic model for forward stepwise regression based on the AIC as a model inclusion term
## https://en.wikipedia.org/wiki/Akaike_information_criterion

# make new data set and remove columns that can be interpretted as NAs
mydata2 <- mydata
mydata2 <- mydata2[-c(1,3:4,14:16,20,22,25)]
colnames(mydata2)

# check data
sapply(mydata2,function(x) sum(is.na(x)))
sapply(mydata2, function(x) length(unique(x)))

# build the null model, nothing but dependent variable and intercept
null=logit1 <- glm(rmaj~1, data = mydata2, family = "binomial")
null

# build the saturated model, dependent variable and all possible independent vars
full=logit1 <- glm(rmaj~., data = mydata2, family = "binomial")
full

# use the step function to build incrementally on the null model
step(null, scope=list(lower=null, upper=full), direction="forward")

# the result: 
#Call:  glm(formula = rmaj ~ state + white + income + col_inc + black + 
#             farm + college + popchange + turnout + col_crime + popdensity, 
#           family = "binomial", data = mydata2)

### ### ### ### ### ### ### ### ### ### 

## note that 'required' variables could be included in the null model
## the *preferred* model did not include 

## we respecify the null model to include a specific variable
null=logit1 <- glm(rmaj~age75, data = mydata2, family = "binomial")
null

# use the step function as before, but now age75 will be in all builds.
step(null, scope=list(lower=null, upper=full), direction="forward")

