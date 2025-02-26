rm(list = ls())

library (tidyverse)
library (Hmisc)

df <- read_csv("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Peformance Training Data.csv")

df <- df %>% 
      mutate_each(funs(as.numeric), Ndiff, Adiff, Net)

df <- df %>% 
      select(State, Outcome, Ndiff, Adiff, Net) %>% 
      gather("Factor", "Percent", 3:4) %>% 
      mutate_if(is.numeric, round, digits = 3) %>% 
      mutate(is.character(State)) %>% 
      arrange(as.numeric(Net))

df_aq2e <- df %>% 
          filter(Outcome == "AQ2E") %>% 
          mutate(Net, Net = Net*100) %>% 
          mutate(Percent, Percent = Percent*100) %>% 
          arrange(Net)
df_ame <- df %>% 
          filter(Outcome =="AME") %>% 
          filter(Percent > -10000) %>% 
          filter(Net > -10000)
df_yq2e <- filter(df, Outcome == "YQ2E")
df_wpq2e <- filter(df, Outcome == "WPQ2E")


AQ2E <- ggplot(df_aq2e, aes(State, Percent)) +
  geom_bar(aes(reorder(State, Net), Percent, fill = Factor), stat = "identity", position = "dodge") +
  geom_point(aes(reorder(State, Net), Net), size = 2) +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.title=element_blank(),
        legend.justification=c(1,0), 
        legend.position=c(0.95, 0.05),  
        legend.background = element_blank(),
        legend.key = element_blank()) +
  scale_fill_discrete(name="", labels = c(" Adjusted Difference from Actual", " Negotiated Difference from Actual")) +
  xlab("States") + ylab("Percentage Points") + 
  ggtitle("WIOA Adult - Q2ER")
AQ2E

AME <- ggplot(df_ame, aes(State, Percent)) +
  geom_bar(aes(reorder(State, Net), Percent, fill = Factor), stat = "identity", position = "dodge") +
  geom_point(aes(reorder(State, Net), Net), size = 2) +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.title=element_blank(),
        legend.justification=c(1,0), 
        legend.position=c(0.95, 0.05),  
        legend.background = element_blank(),
        legend.key = element_blank()) +
  scale_fill_discrete(name="", labels = c(" Adjusted Difference from Actual", " Negotiated Difference from Actual")) +
  xlab("States") + ylab("Percentage Points") + 
  ggtitle("WIOA Adult - Median Earnings")
AME

YQ2E <- ggplot(df_yq2e, aes(State, Percent)) +
  geom_bar(aes(reorder(State, Net), Percent, fill = Factor), stat = "identity", position = "dodge") +
  geom_point(aes(reorder(State, Net), Net), size = 2) +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.title=element_blank(),
        legend.justification=c(1,0), 
        legend.position=c(0.95, 0.05),  
        legend.background = element_blank(),
        legend.key = element_blank()) +
  scale_fill_discrete(name="", labels = c(" Adjusted Difference from Actual", " Negotiated Difference from Actual")) +
  xlab("States") + ylab("Percentage Points") + 
  ggtitle("WIOA Youth - Q2ER")
YQ2E

WPQ2E <- ggplot(df_wpq2e, aes(State, Percent)) +
  geom_bar(aes(reorder(State, Net), Percent, fill = Factor), stat = "identity", position = "dodge") +
  geom_point(aes(reorder(State, Net), Net), size = 2) +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.title=element_blank(),
        legend.justification=c(1,0), 
        legend.position=c(0.95, 0.05),  
        legend.background = element_blank(),
        legend.key = element_blank()) +
  scale_fill_discrete(name="", labels = c(" Adjusted Difference from Actual", " Negotiated Difference from Actual")) +
  xlab("States") + ylab("Percentage Points") + 
  ggtitle("WIOA Wagner-Peyser - Q2ER")
WPQ2E

summary (df_aq2e)

df_aq2e1 <- subset(df_aq2e, Factor == "Ndiff")
df_aq2e2 <- subset(df_aq2e, Factor == "Adiff")

AQ2E <- ggplot() +
        geom_bar(data = df_aq2e1, aes(State, Percent, fill = Factor), stat = "identity", position = "dodge") +
        geom_bar(data = df_aq2e2, aes(State, Percent, fill = Factor), stat = "identity", position = "dodge") +
        xlab("States") + ylab("Percentage Points") +
        ggtitle("WIOA Adult - Q2ER") +
        theme_bw()
AQ2E

df_ame1 <- subset(df_ame, Factor == "Ndiff")
df_ame2 <- subset(df_ame, Factor == "Adiff")
AME <- ggplot(df_ame, aes(x = State, y = Percent)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("States") + ylab("Percentage Points") + 
  ggtitle("WIOA Adult - Q2ER") +
  theme_bw()
AME 