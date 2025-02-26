# clean up
rm(list = ls()) 

install.packages('textreadr')
install.packages('tidytext')
install.packages('dplyr')
install.packages('stringr')

library(textreadr)
library(tidytext)
library(dplyr)
library(stringr)

#read in files
reports <- textreadr::read_dir("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Narrative Reports\\Documents\\")

#convert to single words
tidy_reports <- reports %>%
  unnest_tokens(word, content)

tidy_reports

#Clean
data("stop_words")
tidy_reports <- tidy_reports %>%
  anti_join(stop_words)

#word count
tidy_reports %>%
  count(word, sort = TRUE)

#sentiment analysis
library(tidyr)
bing <- sentiments %>%
  filter(lexicon == "bing") %>%
  select(-score)

bing

reportsentiment <- tidy_reports %>%
  inner_join(bing) %>% 
  count(document, sentiment) %>% 
  spread(sentiment, n, fill = 0) %>% 
  mutate(sentiment = positive - negative)

reportsentiment$percent_positive<-(reportsentiment$positive/(reportsentiment$positive + reportsentiment$negative))*100
reportsentiment$state <- reportsentiment$document
reportsentiment <- select(reportsentiment, -document)
reportsentiment <- reportsentiment[order(reportsentiment$sentiment),]
reportsentiment



#create chart
sentimentchart <- select(reportsentiment, -sentiment, -percent_positive)
library(reshape2)
sentimentchart <- melt(sentimentchart, id.var="state")

sentimentchart <- sentimentchart[order(-sentimentchart$value),]
library(ggplot2)
ggplot(sentimentchart, aes(x = state, y = value, fill = variable)) + 
  geom_bar(stat = "identity")

sentimentchart


#chart with line (sorted, titled, axis renamed)
plotS1 <- ggplot(sentimentchart) 
plotS1 +  geom_bar(aes(x=reorder(state,value),y=value,factor=variable,fill=variable,
                       order=-as.numeric(variable)), stat="identity") +
  geom_line(data=reportsentiment, aes(x=state,y=sentiment, group = 1)) +
  labs(title= "Sentiment of Narrative Reports") +
  labs(colour= "Sentiment") +
  labs(y="Sentiment Words", x="States")


#chart of percent positive
options(scipen=999)  # turn-off scientific notation like 1e+48
library(ggplot2)
theme_set(theme_bw())  # pre-set the bw theme.
data("reportsentiment", package = "ggplot2")


# Scatterplot
library(ggplot2)
gg <- ggplot(reportsentiment, aes(x=sentiment, y=percent_positive)) + 
  geom_point(aes(col=state), size = 5) + 
  geom_text(aes(label=state), size = 1.9) +
  xlim(c(50, 500)) + 
  ylim(c(50, 100)) + 
  stat_smooth(method = 'lm', aes(colour = 'linear'), se = FALSE) +
  labs(subtitle="Sentiment Score Vs Percent Positive", 
       y="Percent Positive", 
       x="Sentiment Score", 
       title="Scatterplot", 
       caption = "Source: PY17 Annual Reports")+
  theme(legend.position="none")
plot(gg)
 
 
  