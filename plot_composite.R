# calculate the normal scores for each category
# I was going to calculate an index with a max of 50
# 5 points for followers
# 5 points for followers/following ratio (but this I omit for now)
# 10 point for favorite h-index
# 10 points for retweets h-index
# 10 points for tweet creation rate
# 10 points for mentions
# however, that doesn't work very well, as the data are so far from normal that a
# few accounts get almost all the points in each category. So I took the PGA Tour
# approach, ranked in each category, and added the ranks

# these have max potential of 5 each, 10 total
normalised_followers <- data_orderby_followers
normalised_followers$normalised_followers <- normalise(data_orderby_followers$followers_count, 5) 
normalised_followers$normalised_follow_ratio <- normalise(data_orderby_followers$follow_ratio, 5)

# these have max 10 each, 40 total
normalised_likes <- data_accounts_likes
normalised_likes$normalised_h_index_likes <- normalise(data_accounts_likes$h_index_likes)

normalised_mentions <- mentions_total
normalised_mentions$normalised_sum_mentions <- normalise(mentions_total$sum_mentions)

normalised_creation_rate <- data_tweetcreationrate
normalised_creation_rate$normalised_creation_rate <- normalise(data_tweetcreationrate$tweet_creation_rate)

normalised_retweets <- data_orderby_retweet_hindex
normalised_retweets$normalised_h_index_retweets <- normalize10(data_orderby_retweet_hindex$h_index_retweets)

# now can merge these based on user
# I want to intersect these

composite <- merge(data_accounts_working, normalised_likes, 
                   by.x = "screen_name", by.y = "screen_name")

composite <- merge(composite, normalised_mentions,
                   by.x = "screen_name", by.y = "user")

composite <- merge(composite, normalised_creation_rate,
                   by.x = "screen_name", by.y = "screen_name")

composite <- merge(composite, normalised_retweets,
                   by.x = "screen_name", by.y = "user")

composite <- merge(composite, normalised_followers,
                   by.x = "screen_name", by.y = "screen_name")


composite$total <- composite$normalised_followers +
  composite$normalised_follow_ratio +
  composite$normalised_h_index_likes +
  composite$normalised_h_index_retweets +
  composite$normalised_sum_mentions +
  composite$normalised_creation_rate

# not satisfied with this ranking, so I went to the all_around_rank

composite$screen_name <- reorder(composite$screen_name, 
                                 composite$total)

# order this, then select top 50
order_composite <- composite[with(composite, 
                                  order(-total)), ]

forPlot <- order_composite[1:50, ]

p <- ggplot(data = forPlot, aes(x = total, y = screen_name))  
p + theme_cowplot(font_family = "Avenir Next") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "Composite Score",
       y = "Twitter Username",
       title = paste("50 Most Influential Twitter Accounts in", subject_title),
       subtitle = "Compiled by Adrian Logue (@AdrianLogue)"
  )

