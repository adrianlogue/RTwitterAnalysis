# followers and follow_ratio analysis
data_orderby_followers <- data_accounts_working

data_orderby_followers$screen_name <- reorder(data_orderby_followers$screen_name, data_orderby_followers$followers_count)

# order this, then select top 50
data_orderby_followers <- data_orderby_followers[with(data_orderby_followers, order(-followers_count)), ]

forPlot <- data_orderby_followers[1:50, ]

p <- ggplot(data = forPlot, aes(x = followers_count, y = screen_name))  
p + theme_cowplot(font_family = "Avenir Next") +
  background_grid(major = "xy") +
  geom_point(shape = 0) +
  labs(x = "Followers",
       y = "Twitter Username",
       title = paste("50 Most Followed Twitter Accounts in", subject_title),
       subtitle = "Compiled by Adrian Logue (@AdrianLogue)"
  )

# TODO: Work out how to set the friends_count to 1 where it is zero to avoid divide by zero

# I also want to look at the follow ratio
data_orderby_followers$follow_ratio <- data_orderby_followers$followers_count / data_orderby_followers$friends_count

data_orderby_followers$screen_name <- reorder(data_orderby_followers$screen_name, data_orderby_followers$follow_ratio)

# order this, then select top 50
data_orderby_followers <- data_orderby_followers[with(data_orderby_followers, order(-follow_ratio)), ]

forPlot <- data_orderby_followers[1:50, ]

p <- ggplot(data = forPlot, aes(x = follow_ratio, y = screen_name))  
p + theme_cowplot(font_family = "Avenir Next") +
  background_grid(major = "xy") +
  geom_point(shape = 0) +
  labs(x = "Followers/Friends Ratio",
       y = "Twitter Username",
       title = paste("High Follower-Friend Ratio Twitter Accounts in", subject_title),
       subtitle = "Compiled by Adrian Logue (@AdrianLogue)",
       caption = "The ratio of followers to friends. A higher number indicates more popularity."
  )

