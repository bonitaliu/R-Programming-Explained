---
title: "Specdata Functions Part 1 -- Pollutantmean() Explanation"
author: "Bonita Liu"
date: "9/17/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Introduction

In week 2 of the Coursera programming assignment, I had to make three functions. These functions use the .csv files within the 'specdata' folder located in my normal working directory. This data consists of 332 pollution sensors in 332 different areas. Each sensor has an ID of 1 to 332, and each detects nitrate and sulfate pollutants. 

The functions I made consisted of:

* **pollutantmean(directory, pollutant, id = 1:332)** - calculates the mean of pollutants (sulfate or nitrate) across specified sensors. Outputs single value.  

* **complete(directory, id = 1:332)** - gives the number of complete cases for each sensor. Outputs a dataframe.  

* **corr(directory, threshold = 0)** - gives correlation between nitrate and sulfate for sensors with amount of complete cases that reaches specified threshold. Outputs a vector.  


# Pulling apart the pollutantmean() function

Below is the code that initiates **pollutantmean()**. Confusing? Sure is. Let's pull it apart and see how it works. 

```{r}

pollutantmean <- function(directory, pollutant, id = 1:332) {
    filelist <- list.files(path = directory, pattern = ".csv", full.names = T)
    pollut <- numeric() # creates empty numeric vector
    for(i in id) {
        data <- read.csv(filelist[i]) # merges all data in directory
        pollut <- c(pollut, data[[pollutant]])
    } 
    mean(pollut, na.rm = T)
}

```

### List Files

So right now, I am in my normal directory which is: **"C:/Users/asus/Desktop/Working Directory for R"**
The data I want to use is in the "specdata" folder where there are 332 data files, so that'll be used as my directory.

**NOTE** that in the code below I am using the file **"specdata_short"** consisting of only 6 files, because I don't want to bombard you with a long piece of code!

Let's see what list.files does then, shall we?

```{r}
list.files(path = "C:/Users/asus/Desktop/Working Directory for R/specdata_short", pattern = ".csv", full.names = T)
```
As you can see, list.files basically prints all the files in **specdata_short** folder as a character vector. In the **pollutantmean** function, this is stored inside variable **filelist**.

### Creating an empty numeric vector 

**pollut <- numeric()** creates an empty numeric vector which is straightforward enough.

```{r}
pollut <- numeric()
pollut
```

### Creating the For Loop for iterations of argument **id**

Time for the stuff of nightmares! Just kidding. But what the heck does the stuff below mean? The lines I want you to look at have been marked with THIS LINE.

```{r}
pollutantmean <- function(directory, pollutant, id = 1:332) {
    filelist <- list.files(path = directory, pattern = ".csv", full.names = T)
    pollut <- numeric() 
    for(i in id) {                      # THIS LINE
        data <- read.csv(filelist[i])   # THIS LINE
        pollut <- c(pollut, data[[pollutant]])
    } 
    mean(pollut, na.rm = T)
}
```

Basically, because the function takes the following arguments **(directory, pollutant, id = 1:332)**, you know that the argument **id** will be a numeric value/sequence. The beginning of the for-loop above tells you that for whatever number iteration is being specified in **id** argument -- whether that's 3 or 1:332 or 4 -- **read.csv** will read that file. 

Let me show you below. Let's say **id = 1:3**. When you subset **filelist** with 1:3, you get back files 1 to 3.
```{r}
filelist <- list.files(path = "C:/Users/asus/Desktop/Working Directory for R/specdata", pattern = ".csv", full.names = T)

filelist[1:3]
```
However, you want to read these files to access the data. Let's do this by subsetting only the first file:
```{r}
filelist <- list.files(path = "C:/Users/asus/Desktop/Working Directory for R/specdata", pattern = ".csv", full.names = T)

head(read.csv(filelist[1])) # head() used so as not to bombard you with long list
data <- read.csv(filelist[1])
```
Now that you see that whatever is put into **[ ]** is basically pulled out of the vector, and that **read.csv** reads whatever is pulled out by **[ ]**, you understand what the for-loop is for. It says: for numbers specified in **id**, read the corresponding file (in above example, file 1) and store the data in **data** variable. 
```{r}
head(data)
class(data)
```
You can see that the **data** variable consists of the same dataframe as what's read by **read.csv**.

Now that that's done, let's look at the bottom half of the for-loop, once again marked THIS LINE:
```{r}
pollutantmean <- function(directory, pollutant, id = 1:332) {
    filelist <- list.files(path = directory, pattern = ".csv", full.names = T)
    pollut <- numeric() 
    for(i in id) {
        data <- read.csv(filelist[i]) 
        pollut <- c(pollut, data[[pollutant]]) # THIS LINE
    } 
    mean(pollut, na.rm = T)
}
```
   
So you know that the **data** variable is where the data for each sensor is kept.
**pollut** gets its values from the already made **data** variable. As you can see from the subsetting, it only gets a subset of this data -- namely, whatever pollutant is named in the argument. If **pollutant = "sulfate"** then you only get the sulfate column:
```{r}
data[["sulfate"]]
```
And that's stored in **pollut**. However, every time that the function runs through an iteration, calculations will be lost. That's why I included **c(pollut**, data[[pollutant]]), so that whatever calculations were done before would saved. 

Let me demonstrate this with a simpler function called **demo** which is supposed to sum the values in every row:
```{r}
demo <- function(data, id = 1:10){
      for(i in id){
            result <- sum(data[i, ])
      }
      return(result)
}
```
Right now, **demo** lacks the bit that **pollut** has, where **pollut** gets **c(pollut,** .......) before something else in the argument. Let's see what this does with the dataframe below:

```{r}
b <- c(1:10)
c <- c(1:10)
d <- c(1:10)

bcd <- data.frame(b,c,d)

bcd

demo(bcd)
```
You can see it behaves quite strangely and only returns the sum of the last row. We don't want that. We want it to return the sum of every row:

```{r}
demo2 <- function(data, id = 1:10){
     result <- numeric()
      for(i in id){
            result <- c(result, sum(data[i, ]))
      }
      return(result)
}

demo2(bcd)

```
So what did I do differently? I added **c(result,**.....) so that the function saves the previous calculations Let's go back to **pollutantmean** now.

## Taking the mean of *pollut* and getting rid of NAs 

To remind you of the whole function, this is what **pollutantmean** looks like:
```{r}
pollutantmean <- function(directory, pollutant, id = 1:332) {
    filelist <- list.files(path = directory, pattern = ".csv", full.names = T)
    pollut <- numeric()                          # creates empty numeric vector
    for(i in id) {
        data <- read.csv(filelist[i])            # merges all data in directory for iterations
        pollut <- c(pollut, data[[pollutant]])   # reads pollutant subset from 'data' and stores it
    } 
    mean(pollut, na.rm = T)                      # calculates mean of 'pollut' and removes NAs
}
```
Now that you know **pollut** after looping consists of the values for the specified pollutant, we can take its mean outside of the for loop. This is easily done with **mean(pollut, na.rm =T)**. The **na.rm** argument simply leaves NA values outside of the calculation. 

*voila!*

NOTE: for in depth information on the **complete()** and **corr()** functions, please see part 2 and 3 of my Specdata Functions Rmarkdown pages.
