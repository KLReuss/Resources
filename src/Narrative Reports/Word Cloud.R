# clean up
rm(list = ls())

#Installing Packages
install.packages ('tm')
install.packages ('wordcloud')
install.packages ('RColorBrewer')
install.packages ('readbulk')

#Loading Packages
library(tm)
library(wordcloud)
library(RColorBrewer)
library(readbulk)

# Location of files
mypath = "C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Word Cloud\\Documents\\" 
setwd(mypath)

# Create list of text files
txt_files_ls = list.files(path=mypath, pattern="*.txt") 

# Read the files in, assuming comma separator
txt_files_df <- lapply(txt_files_ls, function(x) {read.table(file = x, header = T, sep =",")})
# Combine them
combined_df <- do.call("rbind", lapply(txt_files_df, as.data.frame)) 

# Merge files with file extension ".txt"
raw_data <- read_bulk(directory = "mypath",
                      extension = ".txt")

#Read file
sd = "C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Word Cloud\\Documents\\SD.txt" 
co = "C:\\Users\\Reuss.Kevin.L\\OneDrive - US Department of Labor - DOL\\R\\Word Cloud\\Documents\\CO.txt"
modi_txt = readLines(raw_data)

#Covert text file inot a Corpus
modi<-Corpus(VectorSource(modi_txt))
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
wordcloud (modi_data, scale=c(4,0.05), max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, 'Dark2'))


