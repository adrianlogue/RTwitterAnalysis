# this to calculate the tweet rate
# find the hours between end of year and first tweet
# divide to represent as tweets per hour
# start by working with d17_active, this includes accounts with > 10 tweets in 2017

# this will work from end of year to first tweet, but if there were more than 3000 tweets
# in the year, then it is calculated based on hours between end of year and time of 
# the first of those 3000 tweets
tcr <- d17_active %>%
  group_by(screen_name) %>%
  summarise(tweet_creation_rate =
              min(tweet_count) / as.numeric(24 * (ymd_hms(20171231235959) -
                                               min(date))))


tcr$screen_name <- reorder(tcr$screen_name, tcr$tweet_creation_rate)

# order this, then select top 50
order_tcr <- tcr[with(tcr, order(-tweet_creation_rate)), ]

forPlot <- order_tcr[1:50, ]

p <- ggplot(data = forPlot, aes(x = tweet_creation_rate, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "tweet creation rate (original tweets per hour)",
       y = "Twitter username",
       title = "Accounts sharing the most original content",
       subtitle = "top 50 of 6,721 turfgrass accounts in 2017")

