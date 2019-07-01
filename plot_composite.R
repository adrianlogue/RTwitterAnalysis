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
normalised_followers$normalised_followers <- normalise(data_orderby_followers$followers_count, 3) 
normalised_followers$normalised_follow_ratio <- normalise(data_orderby_followers$follow_ratio, 5)

# these have max 10 each, 40 total
normalised_likes <- data_accounts_likes
normalised_likes$normalised_h_index_likes <- normalise(data_accounts_likes$h_index_likes, 10)

normalised_mentions <- mentions_total
normalised_mentions$normalised_sum_mentions <- normalise(mentions_total$sum_mentions, 8)

# normalised_creation_rate <- data_tweetcreationrate
# normalised_creation_rate$normalised_creation_rate <- normalise(data_tweetcreationrate$tweet_creation_rate)

normalised_retweets <- data_orderby_retweet_hindex
normalised_retweets$normalised_h_index_retweets <- normalise(data_orderby_retweet_hindex$h_index_retweets, 7)

# now can merge these based on user
# I want to intersect these

# composite <- data.frame()
composite <- merge(data_accounts_working, normalised_likes, 
                   by.x = "screen_name", by.y = "screen_name")

composite <- merge(composite, normalised_mentions,
                   by.x = "screen_name", by.y = "user")

# composite <- merge(composite, normalised_creation_rate,
#                   by.x = "screen_name", by.y = "screen_name")

composite <- merge(composite, normalised_retweets,
                   by.x = "screen_name", by.y = "user")

composite <- merge(composite, normalised_followers,
                   by.x = "screen_name", by.y = "screen_name")


# Added weightings to this total
composite$total <- as.numeric(composite$normalised_followers) +
  as.numeric(composite$normalised_follow_ratio) +
  as.numeric(composite$normalised_h_index_likes) +
  as.numeric(composite$normalised_h_index_retweets) +
  as.numeric(composite$normalised_sum_mentions) # +
#  composite$normalised_creation_rate

# not satisfied with this ranking, so I went to the all_around_rank

# clean_composite <- data.frame()
# clean_composite <- cbind.data.frame(composite$screen_name, composite$total)

# composite <- clean_composite
composite$screen_name <- reorder(composite$screen_name, 
                                 composite$total)

# order this, then select top 50
order_composite <- composite[with(composite, 
                                  order(-total)), ]

# dedup
order_composite <- unique(order_composite)

forPlot <- data.frame(total=order_composite$total, screen_name=order_composite$screen_name)

forPlot <- forPlot %>%
  group_by(screen_name) %>%
  top_n(n = 1, wt = total)

forPlot <- unique(forPlot)
forPlot <- forPlot[1:50, ]

p <- ggplot(data = forPlot, aes(x = total, y = screen_name))  
p + theme_cowplot(font_family = "Avenir Next") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "Composite Score",
       y = "Twitter Username",
       title = paste("50 Most Influential Twitter Accounts in", subject_title),
       subtitle = "Compiled by Adrian Logue (@AdrianLogue)"
  )


# alternate method of getting an overall rank
composite$rank_followers <- rank(-composite$followers_count.x, ties.method = "min")
composite$rank_follow_ratio <- rank(-composite$follow_ratio, ties.method = "min")
# composite$rank_creation_rate <- rank(-composite$tweet_creation_rate, ties.method = "min")
composite$rank_likes <- rank(-composite$h_index_likes, ties.method = "min")
composite$rank_retweets <- rank(-composite$h_index_retweets, ties.method = "min")
composite$rank_mentions <- rank(-composite$sum_mentions, ties.method = "min")

composite$all_around <- composite$rank_followers +
  composite$rank_follow_ratio +   # maybe omit this ratio to avoid penalizing those who follow a lot of others
#   composite$rank_creation_rate +
  composite$rank_likes +
  composite$rank_retweets +
  composite$rank_mentions

composite$screen_name <- reorder(composite$screen_name, 
                                 composite$all_around)

# order this, then select top 50
order_composite2 <- composite[with(composite, 
                                   order(all_around)), ]
# dedup
order_composite2 <- unique(order_composite2)
# order_composite2$screen_name_rank <- paste(order_composite2$all_around, order_composite2$screen_name, sep=" ")

forPlot <- data.frame(all_around=order_composite2$all_around, screen_name=order_composite2$screen_name)

forPlot <- forPlot %>%
  group_by(screen_name) %>%
  top_n(n = 1, wt = all_around)

forPlot <- unique(forPlot)
forPlot <- forPlot[1:50, ]

p <- ggplot(data = forPlot, aes(x = all_around, y = screen_name))  
p + theme_cowplot(font_family = "Avenir Next") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "Overall Score (lower is better)",
       y = "Twitter Username",
       caption = "Based on the sum of ranks in 5 categories:\nNumber of followers, tweet creation rate, h-index of likes,\nh-index of retweets, and mentions",
       title = paste("50 Most Influential Twitter Accounts in", subject_title),
       subtitle = "Compiled by Adrian Logue (@AdrianLogue)"
  ) +
  scale_y_discrete(limits = rev(unique(sort(forPlot$screen_name))))

