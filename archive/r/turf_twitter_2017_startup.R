# this gets the data organized and calculates the favorites h-index

# we read the data in from a file, or have the turftimelines file 
# created by the get_data.R script

# start off removing all retweets, selecting only original tweets
d2017 <- subset(turftimelines, is_retweet == FALSE)

d2017$date <- ymd_hms(as.character(d2017$created_at))

# remove this as a bot account
d2017 <- subset(d2017, screen_name != "KellyMPlumley1")

# get only those with 12+ tweets in 2017, for once a month
d2017$tweet_count <- ave(d2017$is_retweet, d2017$screen_name, FUN = length)
d17_active <- subset(d2017, tweet_count >= 12)

# order the file by favorites by screen_name
d17_active_order_fav <- d17_active[with(d17_active, order(screen_name, -favorite_count)), ]

# I will get the same results if I remove all tweets with no faves
# this will save processing time
d17_active_order_fav <- subset(d17_active_order_fav, favorite_count > 0)

# I expect that I can slice this up by screen_name, 
# then output to a new file of screen_name + h-index

# refactor the screen names and number them for easy subsetting
d17_active_order_fav$screen_name <- factor(d17_active_order_fav$screen_name)
d17_active_order_fav$user_integer <- as.numeric(d17_active_order_fav$screen_name)

# create a file to hold the output
fav_index_file <- data.frame()

j <- max(d17_active_order_fav$user_integer)

for (i in 1:j) {
  # this gets us a single user to work with
  working_user <- subset(d17_active_order_fav, user_integer == i)
  user <- as.character(working_user[1, 4])
  
  # get the vector now of favorites for the working user
  favs <- working_user[, 12]
  
  fav_h_index <- H_INDEX(favs)
  
  # now for that user we should have a fav_h_index
  # I'd like to now write that
  newline <- cbind.data.frame(user, fav_h_index)
  fav_index_file <- rbind.data.frame(fav_index_file, newline)
}
beep(sound = 3)  # this takes minutes to run so I beep when it is done

# match the user names in order of the fav_h_index
fav_index_file$user <- reorder(fav_index_file$user, fav_index_file$fav_h_index)

# order this, then select top 50
order_fav <- fav_index_file[with(fav_index_file, order(-fav_h_index)), ]

forPlot <- order_fav[1:50, ]

p <- ggplot(data = forPlot, aes(x = fav_h_index, y = user))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "favorites h-index",
       y = "Twitter username",
       caption = "h-index: number of tweets in 2017 (n) with at least (n) favorites\nan h-index of 50 means that account had 50 tweets\nin 2017 that were favorited 50 or more times",
       title = "Most likeable turfgrass Twitter accounts in 2017",
       subtitle = "top 50 of 6,721 accounts")
  