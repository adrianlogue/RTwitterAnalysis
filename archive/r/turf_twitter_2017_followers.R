# followers and follow_ratio analysis
# I want to make sure the accounts are active

active_users <- as.data.frame(unique(d17_active$screen_name))

colnames(active_users) <- "active_users"

# these are the accounts from the turf_follower3 file in get_data.R
turf_accounts <- turf_follower3

# I want to intersect these
active_now <- merge(turf_accounts, active_users, 
                    by.x = "screen_name", by.y = "active_users")
  

active_now$screen_name <- reorder(active_now$screen_name, 
                                  active_now$followers_count)

# order this, then select top 50
order_active <- active_now[with(active_now, order(-followers_count)), ]

forPlot <- order_active[1:50, ]

p <- ggplot(data = forPlot, aes(x = followers_count, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "followers count",
       y = "Twitter username",
       title = "Some of the most followed turf twitter accounts in 2017",
       subtitle = "from turf community")

# I also want to look at the follow ratio
active_now$follow_ratio <- active_now$followers_count / active_now$friends_count

active_now$screen_name <- reorder(active_now$screen_name, 
                                  active_now$follow_ratio)

# order this, then select top 50
order_active <- active_now[with(active_now, order(-follow_ratio)), ]

forPlot <- order_active[1:50, ]

p <- ggplot(data = forPlot, aes(x = follow_ratio, y = screen_name))  
p + theme_cowplot(font_family = "Fira Sans Light") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "followers/following ratio",
       y = "Twitter username",
       title = "Some of the most interesting twitter accounts in 2017",
       subtitle = "from turf community")

