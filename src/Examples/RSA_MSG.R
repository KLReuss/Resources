rm(list = ls())

library("rio")
library("bit64")
library("Hmisc")
library(tidyverse)
library(gifski)
library(gapminder)
library(ggthemes)
library(ggthemr)
library("ggpubr")
library(plm)       # Panel data analysis library
library(car)       # Companion to applied regression 
library(gplots)    # Various programing tools for plotting data
library(tseries)   # For timeseries analysis
library(lmtest)    # For hetoroskedasticity analysis
library(RColorBrewer)
library(sjPlot)
library(gganimate)
#devtools::install_github("thomasp85/transformr")
library(transformr)
#install.packages('png')
#install.packages("ggrepel")
library(ggrepel)
install.packages("jtools")
library(jtools)

rsa <- import("C:\\Users\\Reuss.Kevin.L\\Documents\\Model Data\\RSA.csv", header = TRUE)

rsa <- rsa %>% 
      filter(MSG > 0.1) %>% 
      select(-Quarter, -Statecode, -fips_str, -fips, -cq)


fixed.dum <- lm(MSG~P_female + P_age16U + P_age1924 + P_age2544 + P_age4554 + P_age5559 + P_age60U + 
                  P_Amerindian_1 + P_Asian_1 + P_Black_1 + P_Hawaiian_1 + P_morerace_1 + P_Hispanic + 
                  P_PubSupYes + P_VAYes + P_visual + P_Communicative + P_physical + P_intellectual +
                  P_psychosocial + P_SignDis1 + P_SignDis2 + P_employedIPEYes + P_LongTermUnemp + P_TANF + 
                  P_FosterCareYouth + P_ExOffender + P_LowIncomeStatus + P_limitedEnglishlanguage + P_OneParent + 
                  P_DisHomemaker + P_MFarmworker + P_HomelessOrRunaway + P_trainingservices + P_careerservices + P_otherservices +
                  P_EDU0 + P_EDU1 + P_EDU2 + P_EDU3 + P_EDU4 + P_EDU5 + P_EDU6 + natresemp + constemp + manfemp +
                  tradetranutilemp + infoemp + financialemp + probusemp + edhealthemp + leishospemp + otherservemp +
                  ur + factor(statename)-1, data=rsa)
summary(fixed.dum)

fixed.dum <- lm(MSG~P_female + P_age16U + P_age1924 + P_age2544 + P_age4554 + P_age5559 + P_age60U + 
                  P_Amerindian_1 + P_Asian_1 + P_Black_1 + P_Hawaiian_1 + P_morerace_1 + P_Hispanic + 
                  P_PubSupYes + P_VAYes + P_visual + P_Communicative + P_physical + P_intellectual +
                  P_psychosocial + P_SignDis1 + P_SignDis2 + P_employedIPEYes + P_LongTermUnemp + P_TANF + 
                  P_FosterCareYouth + P_ExOffender + P_LowIncomeStatus + P_limitedEnglishlanguage + P_OneParent + 
                  P_DisHomemaker + P_MFarmworker + P_HomelessOrRunaway + P_trainingservices + P_careerservices + P_otherservices +
                  P_EDU0 + P_EDU1 + P_EDU2 + P_EDU3 + P_EDU4 + P_EDU5 + P_EDU6 + factor(statename)-1, data=rsa)
summary(fixed.dum)

#No Industry 
fixed.dum <- lm(MSG~P_female + P_age1618 + P_age1924 + P_age2544 + P_age4554 + P_age5559 + P_age60U + 
                  P_Asian_1 + P_Black_1 + P_White_1 + P_Hawaiian_1 + P_morerace_1 + P_Hispanic + 
                  P_PubSupYes + P_VAYes + P_Communicative + P_physical + P_intellectual + P_psychosocial + 
                  P_SignDis1 + P_SignDis2 + P_employedIPEYes + P_LongTermUnemp + P_TANF + P_FosterCareYouth + 
                  P_ExOffender + P_LowIncomeStatus + P_limitedEnglishlanguage + P_OneParent + P_DisHomemaker + 
                  P_MFarmworker + P_HomelessOrRunaway + P_trainingservices + P_careerservices + P_otherservices +
                  P_EDU1 + P_EDU2 + P_EDU3 + P_EDU4 + P_EDU5 + P_EDU6 + factor(statename)-1, data=rsa)
summary(fixed.dum)

fixed.dum <- plm(MSG~P_female + P_age1618 + P_age1924 + P_age2544 + P_age4554 + P_age5559 + P_age60U + 
                  P_Asian_1 + P_Black_1 + P_White_1 + P_Hawaiian_1 + P_morerace_1 + P_Hispanic + 
                  P_PubSupYes + P_VAYes + P_Communicative + P_physical + P_intellectual + P_psychosocial + 
                  P_SignDis1 + P_SignDis2 + P_employedIPEYes + P_LongTermUnemp + P_TANF + P_FosterCareYouth + 
                  P_ExOffender + P_LowIncomeStatus + P_limitedEnglishlanguage + P_OneParent + P_DisHomemaker + 
                  P_MFarmworker + P_HomelessOrRunaway + P_trainingservices + P_careerservices + P_otherservices +
                  P_EDU1 + P_EDU2 + P_EDU3 + P_EDU4 + P_EDU5 + P_EDU6, data=rsa, index=c("statename"), model="within")
fixef(fixed.dum)
summary(fixef(fixed.dum))
fixef(fixed.dum, type="dmean")

summary(fixed.dum$coefficients)
describe(fixed.dum$coefficients)


coefficents_rsa <- fixed.dum$coefficients

print(coefficents_rsa)

summ(fixed.dum)
