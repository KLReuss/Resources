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

#Get all state files
input_loc <- read("C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Word Cloud\\Documents\\") 

files <- dir(input_loc, full.names = TRUE)
text <- c()
for (f in files) {
  text <- c(text, paste(readLines(f), collapse = "\n"))
}


#Read all state file
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
TDM1<-as.matrix(tdm_modi) #Convert this into a matrix format
v = sort(rowSums(TDM1), decreasing = TRUE) #Gives yoTDM1<-as.matrix(tdm_modi) #Convert this into a matrix formatu the frequencies for every word
Summary(v)




#Repeat for each state
  #SD
SD = "C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Word Cloud\\Documents\\SD.txt"
modi_txtSD= readLines(SD)


#Covert text file inot a Corpus
modiSD<-Corpus(VectorSource(modi_txtSD))
inspect(modiSD)[1:10]

#Clean data
modi_dataSD<-tm_map(modiSD,stripWhitespace)
modi_dataSD<-tm_map(modi_dataSD,tolower)
modi_dataSD<-tm_map(modi_dataSD,removeNumbers)
modi_dataSD<-tm_map(modi_dataSD,removePunctuation)
modi_dataSD<-tm_map(modi_dataSD,removeWords, stopwords('english'))

modi_dataSD<-tm_map(modi_dataSD,removeWords, c('and','the','our','that','for','are','also','more','has','must','have','should','this','with','south','dakota'
                                           ,'dlr','sdworks'))

#Create a Term Document Matrix
tdm_modiSD<-TermDocumentMatrix (modi_dataSD) #Creates a TDM
TDM1SD<-as.matrix(tdm_modiSD) #Convert this into a matrix format
vSD = sort(rowSums(TDM1SD), decreasing = TRUE) #Gives yoTDM1<-as.matrix(tdm_modi) #Convert this into a matrix formatu the frequencies for every word
Summary(vSD)

#Create Word cloud
wordcloud (modi_dataSD, scale=c(4,0.05), max.words=60, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(4, 'Dark2'))

par(mfrow=c(1,2))
#Create word cloud of Bush speech
wordcloud (modi_dataSD, scale=c(3, .4), max.words=75, random.order = FALSE, random.color = FALSE, colors= c("indianred1","indianred2","indianred3","indianred"))
          
  

#Create Bush and Obama word clouds and plot them side-by-side
#Create two panels to add the word clouds to
par(mfrow=c(1,2))
#Create word cloud of Bush speech
wordcloud(rownames(modi_data), modi_data, min.freq =3, scale=c(5, .2), random.order = FALSE, random.color = FALSE, colors= c("indianred1","indianred2","indianred3","indianred"))
#Create word cloud of Obama speech
wordcloud(rownames(modi_dataSD), modi_dataSD, min.freq =3, scale=c(5, .2), random.order = FALSE, random.color = FALSE, colors= c("lightsteelblue1","lightsteelblue2","lightsteelblue3","lightsteelblue"))
