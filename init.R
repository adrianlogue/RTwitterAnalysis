library(ggplot2)
library(cowplot)
library(dplyr)
library(lubridate)
library(beepr)
library(stringr)

#################################
# SETTINGS

# Specify the subject area title that will be used to label your graphs
subject_title <- "Golf Architecture"

# Enter around 5-10 accounts that are representative of the golf industry in general for the segments
# you want to target
accounts_of_interest <- c(
  "LOBBandPARTNERS",
  "gcamagazine",
  "JasonWay1493",
  "GolfDesignNews",
  "RTJ2GolfDesign",
  "MichaelClayto15",
  # "the_fried_egg",
  "OCCMGolf",
  "DeVriesDesigns",
  "coorecrenshaw",
  "Planet_Golf",
  "KylePhillipsGCD",
  "DavidMcLayKidd",
  "BobHarrisonGolf",
  "EdwinRoald",
  "Hainesy76",
  # "LinksGems",
  "sjoman_jacob"
)

# accounts who may somehow miss out but I want to ensure they're explicitly in
accounts_to_add <- c(
  "GolfersJournal",
  "LOBBandPARTNERS",
  "gcamagazine",
  "JasonWay1493",
  "GolfDesignNews",
  "RTJ2GolfDesign",
  "MichaelClayto15",
  "the_fried_egg",
  "OCCMGolf",
  "DeVriesDesigns",
  "coorecrenshaw",
  "Planet_Golf",
  "KylePhillipsGCD",
  "DavidMcLayKidd",
  "BobHarrisonGolf",
  "EdwinRoald",
  "Hainesy76",
  "LinksGems",
  "sjoman_jacob"
)

# Enter another 5-10 accounts that are much narrower in focus on the sub-segment of the
# golf industry that you want to target. e.g. golf architecture, or golf managers etc...
narrower_accounts_of_interest <- c(
  "TheSAGCA",
  "ASGCA",
  "EIGCA",
  "LOBBandPARTNERS",
  "gcamagazine",
  "JasonWay1493",
  "GolfDesignNews",
  "RTJ2GolfDesign",
  "MichaelClayto15",
  "the_fried_egg",
  "OCCMGolf",
  "DeVriesDesigns",
  "coorecrenshaw",
  "Planet_Golf",
  "KylePhillipsGCD",
  "DavidMcLayKidd",
  "BobHarrisonGolf",
  "EdwinRoald",
  "Hainesy76",
  "LinksGems",
  "sjoman_jacob",
  "GolfersJournal",
  "TheBuckClub",
  "IanAndrewGolf",
  "HochsteinDesign",
  "IntegrativeGolf",
  "DavidMcLayKidd"
)

# Enter how many followers you are intending to retrieve from the above mentioned accounts
# note that you might want to start with a pretty small number to test with then for your
# big run then ramp it up to 10s of thousands
max_sample_size <- 20000 # 20000

# The max number of tweets to retrieve for each of the accounts we're querying
max_tweet_count <- 3000 # 3000

# The start and end date for our analysis
start_date <- "2018-06-01"
end_date <- "2018-12-28"

# Inactivity cutoff - any target accounts with less than this number of status updates
# won't be considered (you should consider this relative to the date range given above
# try to work out a reasonable number of tweets within that date range)
min_status_updates <- 50

# Max number of friends before we treat the account as a bot
max_friend_count <- 1e4 # 10,000

# Account names to explicitly exclude
add_to_exclude_list <- c(
  
)

# END SETTINGS
#################################


h_index <- function(x) {
  y <- 1:nrow(x)
  step1 <- x >= y
  step2 <- max(which(step1 == T))
  return(step2)
}

remove_accounts <- function(x, accounts_to_remove){
  # this assumes the data frame passed in has a column called "screen_name"
  x$screen_name_tolower <- tolower(x$screen_name)
  return(x[!x$screen_name_tolower %in% tolower(accounts_to_remove), ])
}

normalise <- function(x, scale = 10) {
  value <- (x - min(x)) * scale / (max(x) - min(x))
  return(value)
}
