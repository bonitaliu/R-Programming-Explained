---
title: "Specdata Functions Part 2 -- Complete() Explanation"
author: "Bonita Liu"
date: "9/18/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Introduction

Hi there! Welcome back to Part 2 of creating functions for analyzing the pollutant sensors data in the "specdata" folder. For Part 2, we are creating the **complete** function, which counts the number of completely observed cases in the .csv files for each sensor. Let's begin.



*Hey hold it!* Before you move further I just want to mention, sometimes your code can stop running properly if you save your Rmarkdown file somewhere other than your working directory -- I saved this Rmd file initally on my desktop and my code stopped working, though running them in the console worked. Why is this?

When you knit, notice that you can select the **knit directory**. My code stopped working because the directory had been selected to **document directory** where the specdata files are not. My code started working again when I changed it to **current working directory**. So always check your working directory!

```{r}
getwd()
```
# Pulling apart the **complete()** function

Let's first take a look at the complete function before we begin pulling it apart. 
```{r}
complete <- function(directory, id = 1:332){
      filelist <- list.files(path = directory, pattern = ".csv", full.names = TRUE)
      nobs <- numeric() 
      
      for(i in id) {
            data <- read.csv(filelist[i])
            nobs <- c(nobs, sum(complete.cases(data)))
      }
      
      df <- data.frame(id = c(id), nobs = c(nobs)) 
      return(df)                                  
}

complete("specdata", id = 1:4)

```
As you can see, it shows that Sensor 1 has 117 complete cases, Sensor 2 has 1041 complete cases, so on and so forth. Now that you know what this function does, let's break it down.

### *list.files* and creating an empty vector
As covered in part 1, we need to create a character vector called **filelist** which holds the path to each data file. 
```{r}
filelist <- list.files(path = "C:/Users/asus/Desktop/Working Directory for R/specdata", pattern = ".csv", full.names = TRUE)

head(filelist)
```
**nobs** variable (stands for number of observatios) is then created to hold values representing complete cases for each file. Remember, what we are aiming for is one column showing **id** and one column showing **nobs**.

### For-Loop

#### Line 1
Let's take a look at this for-loop. 
```{r}
complete <- function(directory, id = 1:332){
      filelist <- list.files(path = directory, pattern = ".csv", full.names = TRUE)
      nobs <- numeric() 
      
      for(i in id) {
            data <- read.csv(filelist[i])               # LINE 1
            nobs <- c(nobs, sum(complete.cases(data)))  # LINE 2
      }
      
      df <- data.frame(id = c(id), nobs = c(nobs)) 
      return(df)
}

```
For this for-loop, Line 1 does exactly the same as we'd covered in Part 1 of my notes. It stores all the data that's read by **read.csv**. Specifically, **data** gets the data from numbers specified in **id** argument i.e. if **id = 1:4** then **data** stores data from Sensor 1 to Sensor 4. 
```{r}
filelist <- list.files(path = "C:/Users/asus/Desktop/Working Directory for R/specdata", pattern = ".csv", full.names = TRUE)

filelist[1:4] # these files are read, then stored in *data*
```

#### Line 2
Okay, what's Line 2 all about then? Let's have a quick look at the vector **c(nobs, sum(complete.case(data)))**. 

First off, we already know that **data** is just a variable holding the read files (for below, it holds data from only file 1):
```{r}
filelist <- list.files(path = "C:/Users/asus/Desktop/Working Directory for R/specdata", pattern = ".csv", full.names = TRUE)

data <- read.csv(filelist[1])

head(data)
```
Now that we have the data from Sensor 1 which has a lot of NAs, we want to know how many complete cases there are. We can do that with **complete.cases** function, which returns a logical vector for each row, where TRUE means the row is complete, and FALSE means the row is incomplete.
```{r}
complete.cases(data)
```
Because TRUE = 1 and FALSE = 0, you can call **sum** function on the vector above to get the number of complete cases there are for file 1. Let's do that:
```{r}
sum(complete.cases(data))
```
Now you know there are 117 complete cases in file 1!

Now imagine if this process was done for more than just file 1; you'd get a sequence of numbers telling you the number of complete cases in each file. That's what the for-loop does.
```{r}
filelist <- list.files(path = "C:/Users/asus/Desktop/Working Directory for R/specdata", pattern = ".csv", full.names = TRUE)

# If id=1:4, this is what the for-loop would do essentially...
# a separate computation of sum of complete cases for each file
# which is then stored in nobs, along with whatever values nobs held before

data <- read.csv(filelist[1])
sum(complete.cases(data))

data <- read.csv(filelist[2])
sum(complete.cases(data))

data <- read.csv(filelist[3])
sum(complete.cases(data))

data <- read.csv(filelist[4])
sum(complete.cases(data))

```
Because a new computation begins for each loop every time, the old data needs to be stored somewhere. This is why empty numeric vector **nobs** needed to be created first.

Let me describe the loop shortly: 
* In loop 1, nothing from **nobs** is stored because it is empty  
* In loop 2, **117** from the first computation is stored along with the ouput of the new computation *1041* * In loop 3, **nobs** gets **c(117, 1041)** along with new computation of *243*  
* As the loop runs its iterations, nobs turns into a vector of values representing complete cases

NOw that you know what the loop does and what **nobs** holds, let's explore the last chunk of the function.

### Making the dataframe
```{r}
complete <- function(directory, id = 1:332){
      filelist <- list.files(path = directory, pattern = ".csv", full.names = TRUE)
      nobs <- numeric() 
      
      for(i in id) {
            data <- read.csv(filelist[i])
            nobs <- c(nobs, sum(complete.cases(data)))
      }
      
      df <- data.frame(id = c(id), nobs = c(nobs)) #Upper line
      return(df)                                   #Lower line
}

```
So if we specified **id=14**, we now know that **nobs** now holds values **117, 1041, 243, 474** in a vector. Let's create that:
```{r}
(nobs <- c(117, 1041, 243, 474))

```
And we also know that because **id=1:4**, when we use **id** in the function, it'll give us values **c(1, 2, 3, 4)**. Let's create that:
```{r}
(id = c(1, 2, 3, 4))
```
What the upper line does is it simply turns these two into a dataframe. Let's do that:
```{r}
nobs <- c(117, 1041, 243, 474)
id <- c(1, 2, 3, 4)
dframe <- data.frame(id, nobs)

dframe
          
```
And that is exactly what we want for our output! Now you simply call the return function on **dframe**, the dataframe we created, and you will get the output you want. 

# Running **complete()**

Now let's run this function:
```{r}
complete <- function(directory, id = 1:332){
      filelist <- list.files(path = directory, pattern = ".csv", full.names = TRUE)
      nobs <- numeric() 
      
      for(i in id) {
            data <- read.csv(filelist[i])
            nobs <- c(nobs, sum(complete.cases(data)))
      }
      
      df <- data.frame(id = c(id), nobs = c(nobs)) #Upper line
      return(df)                                   #Lower line
}

complete("specdata", id = 1:4)

complete("specdata", 50:55)
```
You can see that **complete()** tells you the complete cases for each file! Note that when **id = 1:4**, the same output is generated as when we pulled the code apart. 

Not so hard right? :)


