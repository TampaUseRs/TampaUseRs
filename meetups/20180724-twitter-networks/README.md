---
title: Analyzing Social Networks with rtweet and special guestr
presenter: Dr. Thomas Keller 
date: 2018-07-24
email: tekeller@usf.edu
twitter: "@tek_keller"
web: http://thomas-keller.github.io/
---

[rtweet]: http://rtweet.info/

## Description

I will walk us through social network analysis of Twitter data using [rtweet] and tidy principles. 
What does that actually mean?
Building a network out of contact information (mentions or retweets), and then identifying important accounts in the network. 
Also some other miscellaneaus text analysis like sentiment analysis, as well as an approximation of influence based on number of followers.

I'm a research scientist at the University of South Florida, working on projects like this, but mostly on things more aligned to my academic background in computational biology. 

## Setup

Included files:

- [20180724-twitter-networks.pdf](20180724-twitter-networks.pdf) is the presentation slides
- [20180724-twitter-networks.Rmd](20180724-twitter-networks.Rmd) is the source code for the slides
- [useR2018.Rmd](useR2018.Rmd) and [useR2018.R](useR2018.R) provide an example analysis using tweets about the [UseR!2018 Conference](https://user2018.r-project.org/) as an example

## Data

[search-ids.Rds](data/search-ids.Rds) contain the tweet IDs necessary to regenerate the full [rtweet] data using `rtweet::lookup_tweets()`

## Packages Used

```r
cran_pkgs <- c(
  "tidyverse",
  "devtools",
  'ggraph',
  'syuzhet',
  'visNetwork'
)

install.packages(cran_pkgs)

github_pkgs <- c(
  "mkearney/rtweet",
  "mkearney/chr",
  "gadenbuie/xaringanthemer"
)

devtools::install_github(github_pkgs)
```
