## Turf Twitter 2017 analysis

This is an explanation of how I selected the accounts and obtained the data used in [my analysis](https://twitter.com/asianturfgrass/status/948203012324864000) of turfgrass accounts on Twitter. 

I explain what I did for these calculations here in plain language. The [code -- click here or view on **GitHub** above](https://github.com/micahwoods/turf_twitter_2017) -- to see the line by line description of data collection and filtering and calculation and ranking. Any code below is excerpts to highlight some key points.

Results of these calculations are posted in a searchable data table in the [Turfgrass Twitter 2017](https://asianturfgrass.shinyapps.io/turf_twitter/) Shiny app.

### Getting started

The data were obtained using the [`rtweet`](https://cran.rstudio.com/web/packages/rtweet/) package which I first read about in [this post at rud.is](https://rud.is/b/2017/10/22/a-call-to-tweets-blog-posts/). That was a great introduction, and I agree that [`rtweet`](https://cran.rstudio.com/web/packages/rtweet/) is a great way to work with Twitter data.

I set out in this project wanting to find out which accounts were having the most impact or influence in the turf industry. What would be an *ideal* influential account? 

I think it would have a lot of followers, so that material shared from the account would go to a large audience. And this *ideal* account would have to send tweets too; an account that sends more tweets is going to reach more people than one that has a lot of followers but sends nothing out. Of course the content matters. The *ideal* account would tweet information that the audience both likes and reshares, and the *ideal* account would also be mentioned and part of the conversation. That's what I looked at.

Here's how I did it.

### Which accounts did I look at, or what is *Turf Twitter*?

My interest is turfgrass information, and I wanted to study accounts that are involved or have an interest in turfgrass information. I generally tweet about turfgrass information myself, but I wanted to look at more than the accounts that followed me -- I'm [@asianturfgrass](https://twitter.com/asianturfgrass), by the way.

I used the `get_followers` function to obtain followers from these accounts:

```r
# get id of accounts following 
atc <- get_followers("asianturfgrass", n = 20000, retryonratelimit = TRUE)
pace <- get_followers("paceturf", n = 20000, retryonratelimit = TRUE)
unl <- get_followers("unlturf", n = 20000, retryonratelimit = TRUE)
tomy <- get_followers("striturf_tomy", n = 20000, retryonratelimit = TRUE)
jyri <- get_followers("Amplify_Turf", n = 20000, retryonratelimit = TRUE)
jk <- get_followers("iTweetTurf", n = 20000, retryonratelimit = TRUE)
unruh <- get_followers("jbunruh", n = 20000, retryonratelimit = TRUE)

# get accounts following industry organizations, which I'll use as a confirmation
# that the account is probably interested in turf
gcsaa <- get_followers("gcsaa", n = 20000, retryonratelimit = TRUE)
bigga <- get_followers("BIGGAltd", n = 20000, retryonratelimit = TRUE)
canada <- get_followers("GolfSupers", n = 20000, retryonratelimit = TRUE)
agcsa <- get_followers("AGCSA2", n = 20000, retryonratelimit = TRUE)
iog <- get_followers("the_iog", n = 20000, retryonratelimit = TRUE)
stma <- get_followers("FieldExperts", n = 20000, retryonratelimit = TRUE)
```
Then I selected the unique accounts that followed at least one of the turf scientists and at least one of the industry organizations.

Next, I selected only the accounts that were set to public and that had more than 50 tweets.

```r
# this removes the private accounts, also the least active ones
turf_follower2 <- subset(turf_follower, protected == FALSE & statuses_count >= 50)
```

And I made one more cut, to remove the accounts that were following more than 10,000 accounts themselves. Those accounts tend to be bot-like and none were turf-related.

Now I had the list of 6,271 Twitter accounts to work with. Each of these, as of 31 Dec 2017 Bangkok time was following me or one of the other turf scientists listed above, and was also following one of the industry organizations, the account was set to public, the account had sent 50 or more tweets or retweets in its lifetime, and the account itself was following less than 10,000 other accounts.

### Getting the Tweets from each account for 2017

I looped through these accounts one by one, getting a maximum of 3,000 tweets from each account, selecting only those sent in 2017, and storing those tweets in a file. This collected a total of 1,493,849 tweets sent from these accounts last year.

```r
# at this point, it is 6271 accounts
# I want to loop through these, getting the tweets and making some calculations
# I'm fine with 3000

turf_timelines <- data.frame()

for (i in 1:6271) {
  new_timeline <- get_timeline(as.character(turf_follower3[i, 3]), n = 3000,
                               check = TRUE)
  new_timeline_2017 <- subset(new_timeline,
                              created_at >= "2017-01-01" &
                                created_at <= "2017-12-31")
  turf_timelines <- rbind(turf_timelines, new_timeline_2017)
  print(paste("completed", i, "/6271 accounts"))
  Sys.sleep(10) # probably not required because of check = TRUE, I wasn't in a hurry so 
  # I slowed it down a bit
}
```

With the exception of a couple accounts that block me, this got tweets from all those 6,271 accounts that sent tweets in 2017.

This was a lot of tweets -- 1,493,849 to be exact. For most accounts, I got all the tweets from 2017. For the accounts that sent more than 3,000 tweets, I didn't, but I was happy with the most recent 3,000 as an indication of that account's performance. I was most interested for this analysis in what the most influential accounts were, based on original content, so I removed all the retweets. 

After removing the retweets, 848,158 original tweets from 2017 remained. I made a couple more cuts. There was one particular bot account that I removed. I know there are some other bots in the remaining data, but they weren't showing up in the rankings -- at least overall rankings -- so I didn't manually remove any others. I also created a variable for the number of tweets sent by each account in 2017, and then I selected only those that sent on average once a month (12 or more tweets for the year).

```r
# remove this as a bot account
d2017 <- subset(d2017, screen_name != "KellyMPlumley1")

# get only those with 12+ tweets, for once a month
d2017$tweet_count <- ave(d2017$is_retweet, d2017$screen_name, FUN = length)
d17_active <- subset(d2017, tweet_count >= 12)
```
This gave me active accounts in 2017. Then based on the accounts that sent the tweets, and data about the tweets themselves, I made calculations of influence in these categories:

* **followers**, the accounts that have a lot of followers probably have more influence because when they send a tweet it has the potential to be seen by more people.
* **tweet creation rate**, how often does one tweet? I calculated this per hour. For the accounts that sent more than 3,000 tweets in 2017 (and thus I did not capture all of them), I calculated the tweet creation rate based on the number of tweets sent divided by the number of hours since the first tweet was sent until the end of the year.
* **favorites h-index**, this measure I first saw from [influencetracker.com](http://www.influencetracker.com/) and I thought it was a good measure to capture the *likeability* of an account. An h-index identifies the number of tweets that have been favorited at least that many times. As an example, if my favorites h-index was 13, that means I had 13 tweets in 2017 that each had 13 or more favorites. For more about the h-index, see [Wikipedia](https://en.wikipedia.org/wiki/H-index). If an account has a high favorites h-index, that means it is sharing a lot of material that other people like.
* **retweets h-index**, this value is the number of tweets that have been retweeted at least that many times. This is an indication of interest or quality of the content being shared. When others retweet something, there is an implication that they think the information is worth sharing, or that they would like to broaded the conversation on that topic.
* **mentions**, I added up all the mentions for each account, after putting all the mentions into a character vector. The `rtweet` package has a really clean delivery of these mentions. It took me a while to get the strings that matched exactly the username. I kept getting extra returns for GCSAA and striturf in particular, because people who work for those organizations often include that string in their username. I finally figured out the solution to put word boundaries on the usernames.

```r
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
```

### The ranking

In each of those categories -- followers, tweet creation rate, favorites h-index, retweets h-index, and total mentions -- I then ranked from those with the highest value to those with the lowest value. Then I added the rankings together. Those with the lowest total ranking I called the most influential.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Here are the overall rankings again, with top 50s for 3 categories to follow. Yesterday I wrote 6,721. It was actually 6,271 accounts studied. <a href="https://t.co/cnL20wRag1">pic.twitter.com/cnL20wRag1</a></p>&mdash; Micah Woods (@asianturfgrass) <a href="https://twitter.com/asianturfgrass/status/948568341450448897?ref_src=twsrc%5Etfw">January 3, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>






