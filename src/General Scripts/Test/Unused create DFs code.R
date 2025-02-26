
############# code tried in the creating dfs script


data.table(y[[1]], y[[2]] ,y[[3]]) 
y <- rbindlist(y, fill=TRUE)
y <- data.table(y[[1]], y[[2]] ,y[[3]])
Reduce(function(...) merge(..., all=TRUE), list(y))
y <- merge(y[[1]], y[[2]] ,y[[3]], all=TRUE)


program_no_na <- (function(z){
  all(!is.na(z))
  select_if(z)
})



#program_no_na <- program %>% 
# lapply(function(z){
#  all(!is.na(z))
# select_if(z)
#})
# program_no_na <- function(z) all(!is.na(z))

#lapply(select_if(program_no_na))

install.packages("skimr")
library(skimr)
wp <- import("C:\\Users\\Reuss.Kevin.L\\Documents\\Data\\Program_PY\\wp_PY18.csv", header = TRUE)
skim(wp)

youth <- import("C:\\Users\\Reuss.Kevin.L\\Documents\\Data\\Program\\youth.csv", header = TRUE)
skim(youth)
library(Hmisc)
describe(youth)
y <- names(youth)
y
skim(youth$Source_Data)
describe(youth$Source_Data)
youth$Source_Data

youth1 <- import("C:\\Users\\Reuss.Kevin.L\\Documents\\Data\\Program\\youth_files.csv", header = TRUE)
skim(youth1)

data_exporter <- "C:/Users/Reuss.Kevin.L/Documents/Data/Test/"
test <- function(p){for (wp_file in wp_files) {
  df <- import(wp_file, header=TRUE)
  not_all_na <- function(x) {all(!is.na(x), df)}
  df %>% select_if(not_all_na)
  dfname <- deparse(substitute(wp_file))
  dfname <- str_sub(dfname, -12,-6)
  out_wp <- paste0(data_exporter,dfname,"_reduced.csv")
  print(out_wp)
  export(df, out_wp)
}
}
test(wp_files)
c <- import("C:/Users/Reuss.Kevin.L/Documents/Data/Test/wp_files_reduced.csv")
c <- filter(data, undesirable == 0)
not_all_na <- function(x) {all(!is.na(x), c)}
c %>% select_if(not_all_na)


library(Hmisc)
summary(c)
describe(c)


data_exporter <- "C:/Users/Reuss.Kevin.L/Documents/Data/Test/"
test <- function(p){for (wp_file in wp_files) {
  df <- import(wp_file, header=TRUE)
  not_all_na <- function(x) {all(x == 0)}
  df %>% select_if(not_all_na)
  dfname <- deparse(substitute(wp_file))
  dfname <- str_sub(dfname, -12,-6)
  out_wp <- paste0(data_exporter,dfname,"_reduced.csv")
  print(out_wp)
  export(df, out_wp)
}
}
test(wp_files)

