# do a ranking order and then sum the rankings
# this is similar to the PGA Tour All-Around statistic
# composite file is created in the normalize file

composite$follower_rank <- rank(-composite$followers_count, ties.method = "min")

composite$follow_ratio_rank <- rank(-composite$follow_ratio, ties.method = "min")

composite$tcr_rank <- rank(-composite$tweet_creation_rate, ties.method = "min")

composite$fav_rank <- rank(-composite$fav_h_index, ties.method = "min")

composite$rt_rank <- rank(-composite$rt_h_index, ties.method = "min")

composite$sum_mentions_rank <- rank(-composite$sum_mentions, ties.method = "min")

composite$all_around <- composite$follower_rank +
#  composite$follow_ratio_rank +   # I omit this ratio to avoid penalizing those who follow a lot of others
  composite$tcr_rank +
  composite$fav_rank +
  composite$rt_rank +
  composite$sum_mentions_rank

composite$screen_name <- reorder(composite$screen_name, 
                                 composite$all_around)

# order this, then select top 50
order_composite2 <- composite[with(composite, 
                                  order(all_around)), ]

forPlot <- order_composite2[1:50, ]

p <- ggplot(data = forPlot, aes(x = all_around, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "all around score (lowest score is best)",
       y = "Twitter username",
       caption = "based on the sum of ranks in 5 categories:\nnumber of followers, tweet creation rate, favorites h-index,\nretweets h-index, and total mentions",
       title = "2017 turfgrass Twitter influential accounts",
       subtitle = "top 50 of 6,721 active accounts") +
  scale_y_discrete(limits = rev(unique(sort(forPlot$screen_name))))
