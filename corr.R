# Corr Function
## This calculates correlation between sulfate and nitrate ...
## for monitor locations where there are enough complete cases

corr <- function(directory, threshold = 0){
      filelist <- list.files(path = directory, pattern = ".csv", full.names = TRUE)
      df <- complete(directory)
      id_nobs_greater_than_threshold <- df[df["nobs"] > threshold, ]$id 
      # basically the subsetting gives you all values in nobs column with value > specified
      # $id then gives you their id number.. this of $ as 's
      correlates_vector <- numeric()
    
      
      for(i in id_nobs_greater_than_threshold) {
            mydata <- read.csv(filelist[i]) # reads all files in specdata into one 
            dff <- mydata[complete.cases(mydata), ] # dff only gets complete.cases in data read above
            correlates_vector <- c(correlates_vector, cor(dff$sulfate, dff$nitrate))
      } 
      return(correlates_vector)
}




