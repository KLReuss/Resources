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
reports <- textreadr::read_dir("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Word Cloud\\Documents\\")

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

reportsentiment
