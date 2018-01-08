clean_mentions <- data.frame()
clean_mentions <- cbind.data.frame(data_timelines$screen_name, data_timelines$mentions_screen_name)

colnames(clean_mentions) <- c("screen_name", "mentions")

# convert to numeric and then remove the non-mentions
clean_mentions$factor_num <- as.numeric(clean_mentions$mentions)
clean_mentions <- subset(clean_mentions, factor_num > 1)

# now re-express this as a large character string
mention_data <- as.character(clean_mentions$mentions)

# now use sum of the count in a loop, searching the 'mention_data' 

# from the turf_twitter_2017_followers, I have an "active_now" file

mentions_total <- data.frame()

j <- length(active_now$screen_name)

for (i in 1:j) {
  user <- as.character(active_now[i, 1])
  
  # having problems with this stringr version as I
  # think it gets fragments such as "GCSAA_NW"
  # when counting for example "GCSAA" but the word boundaries fix this
  
  sum_mentions <- sum(str_count(mention_data, 
                                paste0("\\b", user, "\\b")))
  
  newline <- cbind.data.frame(user, sum_mentions)
  mentions_total <- rbind.data.frame(mentions_total, newline)
}
beep(sound = 3) # beep when done, this takes a long time to run (10 minutes? for these data)

mentions_total$user <- reorder(mentions_total$user, 
                               mentions_total$sum_mentions)

# order this, then select top 50
order_mentions <- mentions_total[with(mentions_total, 
                                      order(-sum_mentions)), ]

forPlot <- order_mentions[1:50, ]

p <- ggplot(data = forPlot, aes(x = sum_mentions, y = user))  
p + theme_cowplot(font_family = "Avenir Next") +
  background_grid(major = "xy") +
  geom_point(shape = 1) +
  labs(x = "total mentions",
       y = "Twitter username",
       title = "Most-mentioned turf Twitter accounts in 2017",
       subtitle = "top 50 out of 6,721 active accounts")
