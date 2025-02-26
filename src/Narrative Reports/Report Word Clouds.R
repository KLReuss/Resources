# clean up
rm(list = ls()) 

library(textreadr)
library(tidytext)
library(dplyr)
library(stringr)
library(wordcloud)
library(RColorBrewer)
library(tidyr)

#read in files
reports <- textreadr::read_dir("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Narrative Reports\\Documents\\")

#convert to single words
tidy_reports <- reports %>%
  unnest_tokens(word, content)

tidy_reports

# tokenize
tidy_reports <- tidy_reports %>% 
  unnest_tokens(word, word) %>% 
  dplyr::count(word, sort = TRUE) %>% 
  ungroup()
tidy_reports

#Clean
data("stop_words")
tidy_reports <- tidy_reports %>%
  anti_join(stop_words)
tidy_reports

# remove unique stop words that snuck in there
uni_sw <- data.frame(word = c("1","based"))

tidy_reports <- tidy_reports %>% 
  anti_join(uni_sw, by = "word")
tidy_reports

#word count
tidy_reports %>%
  count(word, sort = TRUE)

# define a nice color palette
pal <- brewer.pal(8,"Dark2")

# plot the 50 most common words
tidy_reports %>% 
  with(wordcloud(word, n, scale=c(4,.5), random.order = FALSE, max.words = 50, colors=pal))

#Refine words
uni_sw2 <- data.frame(word = c("training","services","service","program","programs","workforce","employment","2","3","0","wioa","job"))

tidy_reports2 <- tidy_reports %>% 
  anti_join(uni_sw2, by = "word")
tidy_reports2

#Plot again
tidy_reports2 %>% 
  with(wordcloud(word, n, scale=c(3,.4), random.order = FALSE, max.words = 60, colors=pal))


##create dynamic table
library(DT)
tidy_reports %>%
  DT::datatable()


#####STATES#######
#SD
#read in file
path <- 'C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Narrative Reports\\Documents\\SD.txt'
SDreport <- read.table(path, header = FALSE, fill = TRUE)

# reshape the .txt data frame into one column
tidy_reportSD <- tidyr::gather(SDreport, key, word) %>% select(word)
tidy_reportSD$word %>% length()

unique(tidy_reportSD$word) %>% length() 

tidy_reportSD

# tokenize
tidy_reportSD <- tidy_reportSD %>% 
  unnest_tokens(word, word) %>% 
  dplyr::count(word, sort = TRUE) %>% 
  ungroup()
tidy_reportSD

#Clean
data("stop_words")
tidy_reportSD <- tidy_reportSD %>%
  anti_join(stop_words)
tidy_reportSD

# remove unique stop words that snuck in there
uni_sw <- data.frame(word = c("1","based","."))

tidy_reportSD <- tidy_reportSD %>% 
  anti_join(uni_sw, by = "word")
tidy_reportSD

#word count
tidy_reportSD %>%
  count(word, sort = TRUE)

#comparison cloud
par(mfrow=c(1,1))
comparison.cloud(tdm, random.order=FALSE, colors = c("indianred3","lightsteelblue3"),
                 title.size=2.5, max.words=400)


#WA
#read in file
path <- 'C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Narrative Reports\\Documents\\WA.txt'
WAreport <- read.table(path, header = FALSE, fill = TRUE)

# reshape the .txt data frame into one column
tidy_reportWA <- tidyr::gather(SDreport, key, word) %>% select(word)
tidy_reportWA$word %>% length()

unique(tidy_reportWA$word) %>% length() 

tidy_reportWA

# tokenize
tidy_reportWA <- tidy_reportWA %>% 
  unnest_tokens(word, word) %>% 
  dplyr::count(word, sort = TRUE) %>% 
  ungroup()
tidy_reportWA

#Clean
data("stop_words")
tidy_reportWA <- tidy_reportWA %>%
  anti_join(stop_words)
tidy_reportWA

# remove unique stop words that snuck in there
uni_sw <- data.frame(word = c("1","based","."))

tidy_reportWA <- tidy_reportWA %>% 
  anti_join(uni_sw, by = "word")
tidy_reportWA

#word count
tidy_reportWA %>%
  count(word, sort = TRUE)

#Create two panels to add the word clouds to
par(mfrow=c(1,2))
#Create word cloud of USA
wordcloud(tidy_reports, min.freq =3, scale=c(5, .2), random.order = FALSE, random.color = FALSE, colors= c("indianred1","indianred2","indianred3","indianred"))
#Create word cloud of WA
wordcloud(col(1), tidy_reportWA, min.freq =3, scale=c(5, .2), random.order = FALSE, random.color = FALSE, colors= c("lightsteelblue1","lightsteelblue2","lightsteelblue3","lightsteelblue"))



#WA

