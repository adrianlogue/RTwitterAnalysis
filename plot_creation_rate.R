# this to calculate the tweet rate
# find the hours between end of year and first tweet
# divide to represent as tweets per hour
# start by working with d17_active, this includes accounts with > 10 tweets in 2017

# this will work from end of year to first tweet, but if there were more than 3000 tweets
# in the year, then it is calculated based on hours between end of year and time of 
# the first of those 3000 tweets
data_timelines_creation_rate <- subset(data_timelines_working, is_retweet == FALSE)
data_timelines_creation_rate$tweet_count <- ave(data_timelines_creation_rate$is_retweet, data_timelines_creation_rate$screen_name, FUN = length)

data_tweetcreationrate <- data_timelines_creation_rate %>% group_by(screen_name) %>%
  summarise(
    tweet_creation_rate = min(tweet_count) / as.numeric(24 * (ymd_hms(20171231235959) - min(created_at)))
  )

data_tweetcreationrate$screen_name <- reorder(data_tweetcreationrate$screen_name, data_tweetcreationrate$tweet_creation_rate)

# order this, then select top 50
data_orderby_tweetcreationrate <- data_tweetcreationrate[with(data_tweetcreationrate, order(-tweet_creation_rate)), ]

forPlot <- data_orderby_tweetcreationrate[1:50, ]

p <- ggplot(data = forPlot, aes(x = tweet_creation_rate, y = screen_name))  
p + theme_cowplot(font_family = "Avenir Next") +
  background_grid(major = "xy") +
  geom_point(shape = 0) +
  labs(x = "Tweet Creation Rate (tweets per hour)",
       y = "Twitter Username",
       title = paste("Top 50 Accounts Creating Content on", subject_title),
       subtitle = "Compiled by Adrian Logue (@AdrianLogue)")

