vignette("introduction", package = "dplyr")

if (!require(dplyr)) install.packages('dplyr')
library(dplyr)

# Developed by Hadley Wickham

# 5 basic verbs. also mutate_all, mutate_if, summarise_all, summarise_if
# select: subset columns. comes with helper functions like starts_with, ends_width, contains, etc.
# filter: subset rows
# summarise: aggregates - british spelling
# mutate: add column(s) to existing data
# arrange: orders data "desc"

# Utilize mtcars dataset for demo
mtcars <- mtcars
str(mtcars)

# glimpse(): expands str() to view more rows
glimpse(mtcars) # notice that the data frame is a tbl. Manipulate the same as a data.frame

# tbl_df # convert to a tbl. Changes how the data is viewed - fits in the console
print(mtcars)
mtcars <- tbl_df(mtcars)
print(mtcars)
str(mtcars)

#############
# select    #
#############
# select(df,var1,var2,...,varn)
# Reduce mtcars dataset to mpg, cyl, disp, and hp columns only
mtcars[,1:4] # traditional method
mtcars[,c("mpg","cyl","disp","hp")] # traditional method
select(mtcars,mpg,cyl,disp,hp) # no quotes around variable names
select(mtcars,mpg:hp)
select(mtcars,1:4)
select(mtcars,-(5:11))

#############
# filter    #
#############
# filter(df,exp1,exp2,..,exp3)
# Filter mtcars to cars that get over 18 mpg and are 4 cyl
mtcars[mtcars$mpg>18 & mtcars$cyl==4,] # traditional method
filter(mtcars,mpg>18,cyl==4)
filter(mtcars,mpg>18 & cyl==4)

#############
# summarise #
#############
# summarise(df,aggregator fn)
mean(mtcars$mpg)
summarise(mtcars,mean(mpg,na.rm=T))
summarise(mtcars,mn_mpg=mean(mpg,na.rm=T)) # can define variable
summarise(mtcars,mn_mpg=mean(mpg,na.rm=T),Total.Obs=n(), Unique.Cyl=n_distinct(cyl)) # multiple functions at a time
# various Aggregator Functions in dplyr
# first, last, nth(x,n), n(), n_distinct(x). Base aggregator functions are min, max, mean, median, etc.


#############
# mutate    #
#############
# mutate(df,new_var = var_1 + var_2)
# Find the ratio of mpg to hp for each observation and call this varirable ratio.mpg.hp
mtcars.ratio <- mtcars # create a new df
mtcars.ratio$ratio.mpg.hp <- mtcars$mpg/mtcars$hp # traditional method
mutate(mtcars,ratio.mpg.hp=mpg/hp)
# Also find the ratio of mpg to number of cyl for each variable. Do not give this variable a name
mutate(mtcars,ratio.mpg.hp=mpg/hp,mpg/cyl)
# Can perform complex operations inside mutate
mutate(mtcars,ratio.mpg.hp=mpg/hp,mpg/cyl, # ratio of mpg to hp for all observations
       ratio.cyl.4 = ifelse(cyl==4,mpg/hp,NA)) # ratio of mpg to hp for all observations that are 4 cyl
# ...or perform the simplest of operations
mutate(mtcars,1) # add a column of 1's

#############
# arrange   #
#############
# arrange(df,var1,var2,...,varn)
# Order mtcars by cyl then hp
mtcars[order(mtcars$cyl,mtcars$hp),] # traditional method
arrange(mtcars,mpg,cyl,hp)
arrange(mtcars,desc(mpg,cyl,hp)) # descending order

#############
# group_by  #
#############
# group_by(df,var1)
# When you then apply the verbs above on the resulting object they'll be automatically applied "by group".
by.cyl <- group_by(mtcars,cyl)
summarise(by.cyl, count=n())

#############
# piping  #
#############
# "piping" avoids nesting functions inside one another
# "piping" avids creating new data frames for each data manipulation
mtcars %>%
  select(mpg,cyl,disp,hp,wt,qsec,vs,gear) %>%
  group_by(cyl) %>%
  filter(mpg>15) %>%
  summarise(Count=n()) %>%
  mutate(position = rank(-Count)) %>%
  arrange(position)

# can be used outside normal dplyr functions
mtcars.reduced <- read.table(file='Clipboard',sep = "\t", header=F,colClasses = rep('character',5)) %>% unique()
mtcars.reduced

#############
# joining   #
#############
# left_join
# right_join
# inner_join
# full_join
# anti_join
?join
left_join(a,b,by='ID')
