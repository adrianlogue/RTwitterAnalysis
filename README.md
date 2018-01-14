## R Twitter Analysis for Golf Architecture

The initial concept for this model borrows heavily from the work of Micah Woods (https://github.com/micahwoods/turf_twitter_2017). While Micah's work was focused on "Turf Twitter" I'm more interested in broader golf twitter and in particular golf course architecture.

I may consider adapting this model for other golf industry segments such as golf journalism, golf equipment, golf fashion, professional golf etc...

I took on this project as an opportunity to learn R and to be able to modify Micah's rationale and ask and answer different types of questions for myself.

### Rationale

This application is created to analyse various segments of "golf twitter", but changing the seed accounts would allow it to be applied to pretty much any field.

The "seed" accounts need to be carefully considered. It's probably the most time consuming and difficult thing about this endeavour. The basic method I use is to have two lists of seed accounts:

- I choose accounts in the first list that have thousands or tens of thousands of followers and are broadly appealing to golfers in general, but also show an affinity for the segment of the golf industry I'm targeting. The followers of these accounts were pulled down, de-duped and kept to one side. Even with only a dozen or so accounts this casts a fairly wide net and brings in tens of thousands of followers who I pull down using the rtweet package, de-dupe and store in a data frame.
- The second list which is probably the more important one, I seek to bring in more segment specific accounts that pertain to Golf Architecture, but I bring in enough of these accounts that when I pull down their list of friends (not followers) I'll still have thousands of accounts. I figure the group of people who are followed by segment-specific influential people are likely to be fairly interested in the subject matter.
- I then get the intersection of the two lists. That eliminates most of the general golf fans from the first list and gets rid of the non-golf people from the second list.

I also have a mechanism for manually adding accounts that I know are of significance in the field that I'm analysing but for whatever reason have been excluded from the final list of target accounts.

Similarly I keep a list of accounts that I want to exclude because they've found their way into the list simply because my filtering technique isn't incredibly precise at weeding out all the non-Golf Architecture people. I spent a lot of time eyeballing accounts to go on this list and evaluating their relevance to Golf Architecture.

Once I have the list of target accounts I again use rtweet to pull down their detailed account information, then for each of them I get a big chunk of their tweets from the past 6-12 month period. That process of pulling down the tweets is very time consuming it took my machine almost a full day to get through it (there are rate-limit considerations with the Twitter API which you bump against frequently).

### Use

I don't see this ever being more than just a loose collection of files that contain a bunch of semi-organised snippets of R that you might use to selectively execute and create datasets then play with those datasets until you're satisified you've massaged it into something you can feed into the chart plotting code.

All very ad-hoc, but if you do want to go about it in some structured manner, then you should start be basically executing the files in the following order:

1. `init.R` - this loads various packages and sets up a few environment variables and utility functions
2. `data_get.R` - this pulls down the data from twitter. It can take a huge amount of time to run this so proceed with caution. Unless you spend a lot of time tidying up my script, I recommend really running each line of code individually and only when you have a fair idea of what the next line of code is achieving.
3. `plot_likes.R` - produces a graph of the top 50 accounts based on a h-index derived from likes
4. `plot_retweets.R` - plots a graph of the top 50 accounts based on a h-index derived from retweets
5. `plot_creation_rate.R` - plots a graph of the top 50 accounts based on frequency of original content posted
6.  `plot_followers.R` - this produces two charts one based simply on number of followers and one based on the follower-friend ratio.
7. `plot_mentions.R` - plots a graph of the top 50 accounts based on how often they're mentioned - this one is very time consuming to execute.
8. `plot_composite.R` - this produces two charts, one based on a normalised score across all the previous categories and one based on how low each account's summed rankings are in the other categories. (the latter I found to produce a slightly better result but the normalised score could maybe be improved with some weighting for the various categories).

### Ongoing

I'm going to work on an algorithm that would help to uncover some "hidden gem" accounts. Perhaps something based on an accounts ability to achieve a high engagement with a small number of followers. That would be an indication of an account thats on an upward trajectory.
