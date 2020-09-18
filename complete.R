# Complete Function
## This function counts the number of completely observed cases in each data file

## This is what I wrote, which is not the most concise. Better answer given at bottom

complete <- function(directory, id = 1:332){
      filelist <- list.files(path = directory, pattern = ".csv", full.names = TRUE)
      nobs <- numeric() # creates empty numeric vector
      
      for(i in id) {
            data <- read.csv(filelist[i])
            nobs <- c(nobs, sum(complete.cases(data)))
      }
      
      df <- data.frame(id = c(id), nobs = c(nobs)) 
      return(df)
}


# nobs is added into nobs again in the for loop so that it can save calculations from before
## the first time, it saves nothing because it was empty
## the second time, it saves what's been calculated plus the new calculation so on..

# Breaking down `sum(complete.cases(read.csv(filelist[i])))`
## filelist is a character vector giving paths to specdata files:
###      [1] "C:/Users/asus/Desktop/Working Directory for R/specdata/001.csv"
###      [2] "C:/Users/asus/Desktop/Working Directory for R/specdata/002.csv"
## when you subset a number in there [1], it reads that csv file
## complete.cases gives a logical vector for each observation, where TRUE=complete
## because 1=TRUE and 0=FALSE, sum() gives you number of complete cases
## I made it more simple by putting the iterations of filelists being read into 'data'


# Better Answer

# complete <- function(directory, id = 1:332){
 #     filelist <- list.files(path = directory, pattern = ".csv", full.names = TRUE)
 #     nobs <- numeric() # creates empty numeric vector
 #     
 #     for(i in id) {
 #           data <- read.csv(filelist[i])
 #           nobs <- c(nobs, sum(complete.cases(data)))
 #     }
 #     
 #     data.frame(id, nobs)

#}