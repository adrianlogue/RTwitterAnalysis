# this takes the previous data from the startup file
# now we look at retweet h-index

d17_active_order_rt <- d17_active[with(d17_active, order(screen_name, -retweet_count)), ]

# I will get the same results if I remove all tweets with no retweets
# this will save processing time
d17_active_order_rt <- subset(d17_active_order_rt, retweet_count > 0)

# I expect that I can slice this up by screen_name, then output to a new file of screen_name + h-index
rt_index_file <- data.frame()

d17_active_order_rt$screen_name <- factor(d17_active_order_rt$screen_name)
d17_active_order_rt$user_integer <- as.numeric(d17_active_order_rt$screen_name)

j <- max(d17_active_order_rt$user_integer)

for (i in 1:j) {
  # this gets us a single user to work with
  working_user <- subset(d17_active_order_rt, user_integer == i)
  user <- as.character(working_user[1, 4])
  
  # now we will calculate the retweet h-index for working_user
  rts <- working_user[, 13]
  
  rt_h_index <- H_INDEX(rts)
  
  # now for that user we should have a rt_h_index
  # I'd like to now write that
  newline <- cbind.data.frame(user, rt_h_index)
  rt_index_file <- rbind.data.frame(rt_index_file, newline)
}
beep(sound = 3)

rt_index_file$user <- reorder(rt_index_file$user, rt_index_file$rt_h_index)

# order this, then select top 25
order_rt <- rt_index_file[with(rt_index_file, order(-rt_h_index)), ]

forPlot <- order_rt[1:50, ]

p <- ggplot(data = forPlot, aes(x = rt_h_index, y = user))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "retweets h-index",
       y = "Twitter username",
       caption = "h-index: number of tweets in 2017 (n) each being retweeted at least (n) times\nan h-index of 20 means that account had 20 tweets in 2017 that were retweeted 20 or more times",
       title = "Some of the most shareable content turf twitter accounts in 2017",
       subtitle = "6721 active accounts in 2017")

