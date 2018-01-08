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

# normalize between 0 to 10
normalize10 <- function(x) {
  value <- (x - min(x)) * 10 / (max(x) - min(x))
  return(value)
}

# normalize between 0 to 5
normalize5 <- function(x) {
  value <- (x - min(x)) * 5 / (max(x) - min(x))
  return(value)
}

# these have max potential of 5 each, 10 total
active_now$normalized_follower <- normalize5(active_now$followers_count) 
active_now$normalized_follow_ratio <- normalize5(active_now$follow_ratio)

# these have max 10 each, 40 total
fav_index_file$normalized_fav_index <- normalize10(fav_index_file$fav_h_index)
mentions_total$normalized_sum_mentions <- normalize10(mentions_total$sum_mentions)
tcr$normalized_tweet_creation_rate <- normalize10(tcr$tweet_creation_rate)
rt_index_file$normalized_rt_index <- normalize10(rt_index_file$rt_h_index)

# now can merge these based on user
# I want to intersect these
composite <- merge(active_now, fav_index_file, 
                    by.x = "screen_name", by.y = "user")

composite <- merge(composite, mentions_total,
                   by.x = "screen_name", by.y = "user")

composite <- merge(composite, tcr,
                   by.x = "screen_name", by.y = "screen_name")

composite <- merge(composite, rt_index_file,
                   by.x = "screen_name", by.y = "user")

composite$total <- composite$normalized_follower +
  composite$normalized_follow_ratio +
  composite$normalized_fav_index +
  composite$normalized_rt_index +
  composite$normalized_sum_mentions +
  composite$normalized_tweet_creation_rate

# not satisfied with this ranking, so I went to the all_around_rank

composite$screen_name <- reorder(composite$screen_name, 
                               composite$total)

# order this, then select top 50
order_composite <- composite[with(composite, 
                                      order(-total)), ]

forPlot <- order_composite[1:50, ]

p <- ggplot(data = forPlot, aes(x = total, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "composite score",
       y = "Twitter username",
       title = "Overall influential accounts",
       subtitle = "top 50 of 6,721 active accounts in 2017")
