
# Get rid of the NAs
data_timelines_mentions_temp <- subset(data_timelines_working, (!is.na(data_timelines_working[,"mentions_screen_name"])))
# data_timelines_mentions$mentions_screen_name_unlisted <- paste(unlist(data_timelines_mentions$mentions_screen_name), collapse = " ")

datalist <- list()
j <- nrow(data_timelines_mentions_temp)

for (i in 1:j) {
  tweet_temp <- data_timelines_mentions_temp[i, ]
  mentions_screen_name_temp <- tweet_temp[1, "mentions_screen_name"]
  
  mentions_screen_name_temp <- paste(unlist(mentions_screen_name_temp), collapse = " ")
  
  tweet_temp$mentions_screen_name_unlisted <- mentions_screen_name_temp
  datalist[[i]] <- tweet_temp
  if(i %% 100 == 0){
    print(paste("Completed", i, "of", j, "tweets"))
  }
}

data_timelines_mentions <- data.frame()
data_timelines_mentions <- do.call(rbind.data.frame, datalist)
beep(0)

clean_mentions <- data.frame()
clean_mentions <- cbind.data.frame(data_timelines_mentions$screen_name, data_timelines_mentions$mentions_screen_name_unlisted)

colnames(clean_mentions) <- c("screen_name", "mentions")

# convert to numeric and then remove the non-mentions
clean_mentions$mentions_factored <- as.numeric(clean_mentions$mentions)
clean_mentions <- subset(clean_mentions, mentions_factored > 1)

# now re-express this as a large character string
mention_data <- as.character(clean_mentions$mentions)

# now use sum of the count in a loop, searching the 'mention_data' 

# from the turf_twitter_2017_followers, I have an "active_now" file

mentions_total <- data.frame()

j <- length(data_accounts_working$screen_name)

for (i in 1:j) {
  user <- as.character(data_accounts_working[i, "screen_name"])
  
  # having problems with this stringr version as I
  # think it gets fragments such as "GCSAA_NW"
  # when counting for example "GCSAA" but the word boundaries fix this
  
  sum_mentions <- sum(str_count(mention_data, 
                                paste0("\\b", user, "\\b")))
  
  newline <- cbind.data.frame(user, sum_mentions)
  mentions_total <- rbind.data.frame(mentions_total, newline)
}
# beep(sound = 3) # beep when done, this takes a long time to run (10 minutes? for these data)

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
  labs(x = "Mentions",
       y = "Twitter Username",
       title = paste("50 Most Mentioned Twitter accounts in", subject_title),
       subtitle = "Compiled by Adrian Logue (@AdrianLogue)"
  )

