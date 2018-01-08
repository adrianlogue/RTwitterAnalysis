# this script loads libraries and functions 
# then runs the files in sequence

# load libraries
library(rtweet)
library(dplyr)
library(ggplot2)
library(lubridate)
library(cowplot)
library(beepr)
library(stringr)

# This function returns the H-INDEX when the favorite or retweet count
# is a sorted vector, with the favorites or retweet count in descending order
H_INDEX <- function(x) {
  y <- 1:length(x)
  step1 <- x >= y
  step2 <- max(which(step1 == TRUE))
  return(step2)
}

# one will need to get the oauth token before making any calls to the API
source("get_data.R")

# this gets the data ready for analysis and calculates the fav h-index
source("r/turf_twitter_2017_startup.R")
