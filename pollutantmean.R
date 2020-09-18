# Programming Assignment 1 -- pollutantmean function


#pollutantmean(...) {
    
    # obtain list of sensor files in specdata directory
    
    # create empty data frame
    
    # subset list of sensor files
    
    # loop through files in subset list and
    #    * read the csv file
    #    * bind to "collector" data frame
    
    # calculate mean and return to parent environment
#}



pollutantmean <- function(directory, pollutant, id = 1:332) {
    filelist <- list.files(path = directory, pattern = ".csv", full.names = T)
    x <- numeric() # creates empty numeric vector
    for(i in id) {
        data <- read.csv(filelist[i]) # merges all data in directory
        x <- c(x, data[[pollutant]])
    } 
    mean(x, na.rm = T)
}

# Explanation of pollutantmean()
# list.files produces character string of everything in the directory with.csv attached; this is stored in filelist
# x <- gets a numeric vector
# for loop: iterations 1:322 in id argument, data gets what's read by read.csv()
##   what is read by read.csv are strings of '001.csv', '002.csv' such as listed in 'filelist'
##   for example, if you assign 'b <- c("014.csv")', then read.csv(b) would print data from 014.csv file
# x, the premade numeric vector, then gets itself and the [[pollutant]] column in 'data'
# you then ask for the mean, with NAs removed