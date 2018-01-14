## R Twitter Analysis for Golf (or any subject really)

The initial concept for this model borrows heavily from the work of Micah Woods (https://github.com/micahwoods/turf_twitter_2017). While Micah's work was focused on "Turf Twitter" I'm more interested in broader golf twitter and other other specific segments of golf twitter such as golf course architecture, or golf journalism, or golf equipment.

Also I wanted to use this project as an opportunity to learn R and to be able to modify Micah's rationale and ask and answer different types of questions for myself.


### Rationale

This application is created to analyse "golf twitter", but changing the seed accounts would allow it to be applied to pretty much any field.

The "seed" accounts need to be carefully considered. It's probably the hardest thing about this endevour. The basic method I use is to have two lists of seed accounts, each seed list only needs a handful of accounts, as long as they have a decent number of followers (thousands or tens of thousands):

- I choose accounts in the first list that have thousands of followers and are broadly appealing to golfers in general, but also show an affinity for the segment of the golf industry I'm targeting. This casts a fairly wide net.
- The second list which is probably the more important one, it is much more segment specific and targets accounts that would generally only be followed by people in the specific segment that I'm analysing. e.g. for Golf Architecture, I chose the majory Golf Architecture industry groups from Australia, US and Europe. There's generally far fewer followers of these organisations.

I then get the intersection of these two lists. That eliminates most of the general golf fans from the first list and gets rid of the non-golf people from the second list.

Finally I have a mechanism for manually adding accounts that I know are of significance in the field that I'm analysing but for whatever reason have been excluded from the final list of target accounts.



### Use

I don't see this ever being more than just a loose collection of files that contain a bunch of semi-organised snippets of R that you might use to selectively execute and create datasets then play with those datasets until you're satisified you've massaged it into something you can feed into the chart plotting code.

All very ad-hoc, but if you do want to go about it in some structured manner, then you should start be basically executing the files in the following order:

1. `init.R` - this loads various packages and sets up a few environment variables and utility functions
2. `data_get.R` - this pulls down the data from twitter. It can take a huge amount of time to run this so proceed with caution. Unless you spend a lot of time tidying up my script, I recommend really running each line of code individually and only when you have a fair idea of what the next line of code is achieving.
3. `plot_likes.R` - produces a graph of the top 50 accounts based on a h-index derived from likes
4. `plot_retweets.R` - plots a graph of the top 50 accounts based on a h-index derived from retweets
5. `plot_creation_rate.R` - plots a graph of the top 50 accounts based on frequency of original content posted
6. `plot


WORK IN PROGRESS