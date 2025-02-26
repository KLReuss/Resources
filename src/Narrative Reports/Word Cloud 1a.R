# clean up
rm(list = ls())

install.packages("tidyverse")
install.packages("tokenizers")
install.packages ('tm')
install.packages ('wordcloud')
install.packages ('RColorBrewer')
install.packages ('readbulk')
library(tidyverse)
library(tokenizers)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(readbulk)

input_loc <- "C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Word Cloud\\Documents\\" 

files <- dir(input_loc, full.names = TRUE)
text <- c()
for (f in files) {
  text <- c(text, paste(readLines(f), collapse = "\n"))
}

#Read file
words <- tokenize_words(text)

#Covert text file inot a Corpus
modi<-Corpus(VectorSource(words))
inspect(modi)[1:10]

#Clean data
modi_data<-tm_map(modi,stripWhitespace)
modi_data<-tm_map(modi_data,tolower)
modi_data<-tm_map(modi_data,removeNumbers)
modi_data<-tm_map(modi_data,removePunctuation)
modi_data<-tm_map(modi_data,removeWords, stopwords('english'))

modi_data<-tm_map(modi_data,removeWords, c('and','the','our','that','for','are','also','more','has','must','have','should','this','with','south','dakota'
                                           ,'dlr','sdworks'))

#Create a Term Document Matrix
tdm_modi<-TermDocumentMatrix (modi_data) #Creates a TDM

v = sort(rowSums(TDM1), decreasing = TRUE) #Gives yoTDM1<-as.matrix(tdm_modi) #Convert this into a matrix formatu the frequencies for every word
Summary(v)


#Create Word cloud
wordcloud (modi_data, scale=c(3,0.05), max.words=60, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(4, 'Dark2'))

