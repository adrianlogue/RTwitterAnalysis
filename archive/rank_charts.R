# a bunch of rank charts

# first, followers
composite$screen_name <- reorder(composite$screen_name, 
                                 composite$follower_rank)

# order this, then select top 50
order_composite2 <- composite[with(composite, 
                                   order(follower_rank)), ]

forPlot <- order_composite2[1:50, ]

p <- ggplot(data = forPlot, aes(x = follower_rank, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "all around composite score (rank)",
       y = "Twitter username",
       title = "Overall influential accounts",
       subtitle = "top 50 of 6,721 active accounts in 2017") + 
  scale_y_discrete(limits = rev(unique(sort(forPlot$screen_name))))

# then, favorites

composite$screen_name <- reorder(composite$screen_name, 
                                 composite$fav_rank)

# order this, then select top 50
order_composite2 <- composite[with(composite, 
                                   order(fav_rank)), ]

forPlot <- order_composite2[1:50, ]

p <- ggplot(data = forPlot, aes(x = fav_rank, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "all around composite score (rank)",
       y = "Twitter username",
       title = "Overall influential accounts",
       subtitle = "top 50 of 6,721 active accounts in 2017") + 
  scale_y_discrete(limits = rev(unique(sort(forPlot$screen_name))))

# then, retweets

composite$screen_name <- reorder(composite$screen_name, 
                                 composite$rt_rank)

# order this, then select top 50
order_composite2 <- composite[with(composite, 
                                   order(rt_rank)), ]

forPlot <- order_composite2[1:50, ]

p <- ggplot(data = forPlot, aes(x = rt_rank, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "all around composite score (rank)",
       y = "Twitter username",
       title = "Overall influential accounts",
       subtitle = "top 50 of 6,721 active accounts in 2017") + 
  scale_y_discrete(limits = rev(unique(sort(forPlot$screen_name))))

# then, tweet creation rate

composite$screen_name <- reorder(composite$screen_name, 
                                 composite$tcr_rank)

# order this, then select top 50
order_composite2 <- composite[with(composite, 
                                   order(tcr_rank)), ]

forPlot <- order_composite2[1:50, ]

p <- ggplot(data = forPlot, aes(x = tcr_rank, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "all around composite score (rank)",
       y = "Twitter username",
       title = "Overall influential accounts",
       subtitle = "top 50 of 6,721 active accounts in 2017") + 
  scale_y_discrete(limits = rev(unique(sort(forPlot$screen_name))))

# then, mentions rate

composite$screen_name <- reorder(composite$screen_name, 
                                 composite$sum_mentions_rank)

# order this, then select top 50
order_composite2 <- composite[with(composite, 
                                   order(sum_mentions_rank)), ]

forPlot <- order_composite2[1:50, ]

p <- ggplot(data = forPlot, aes(x = sum_mentions_rank, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "all around composite score (rank)",
       y = "Twitter username",
       title = "Overall influential accounts",
       subtitle = "top 50 of 6,721 active accounts in 2017") + 
  scale_y_discrete(limits = rev(unique(sort(forPlot$screen_name))))
