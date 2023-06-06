library(tidyverse)

###############################################################################################################################################################################################
# Chapter 10: Data Transformation
###############################################################################################################################################################################################
# 10.1 Introduction
###############################################################################################################################################################################################
# The package dplyr provides verbs (functions) to help solve the most common data manipulation problems
# The most important dplyr verbs are filter(), mutate(), group_by() and summarise()
# All of the verbs work the same way, they take a data frame as the first argument and return a modified data frame

###############################################################################################################################################################################################
# 10.2 Filter Observations
###############################################################################################################################################################################################
# A useful data analysis strategy is working with just one observation unit before attempting to work with the whole dataset 
# Filtering is useful for extracting outliers. Generally outliers shouldn't just be thrown away but its useful to partition data into the common and unusual

ggplot(diamonds, aes(x,y)) + geom_bin2d()

# The plot above has around 50,000 points in the dataset and have most of them lying in the diagonal, with only a handful of outlier, that can be removed with filter()

filter(diamonds, x == 0 | y == 0)

# filter() is very similar to subset with the key difference being that subset() can select both observations and variables, while filter() works exclusively with observations and select() with variables
# The main advantage for filter() is it behaves identically to other dplyr verbs and is a bit faster than subset()
# In real analysis, one would look at outliers in more detail to see if there is a data quality problem, however in this case, they will be filtered out from the dataset

diamonds_ok <- filter(diamonds, x > 0, y > 0, y < 20)
ggplot(diamonds_ok, aes(x,y)) + geom_bin2d() + geom_abline(slope = 1, color = "white", size = 1, alpha = 0.5) # plot shows a strong relationship between x and y
 
###############################################################################################################################################################################################
# 10.2.1 Useful Tools
###############################################################################################################################################################################################
# The first argument to filter() is a data frame, the second and subsequent arguments must be logical vectors
# filter() selects every row where all the logical expressions are TRUE
# The logical vectors must always be the same length as the data frame; if not an error occurs
# Logical vectors are created with comparison operators:
# x == y: x and y are equal.
# x != y: x and y are not equal.
# x %in% c("a", "b", "c"): x is one of the values in the right hand side.
# x > y, x >= y, x < y, x <= y: greater than, greater than or equal to, less than, less than or equal to.
# and then combined with logical operators:
# !x (pronounced “not x”), flips TRUE and FALSE so it keeps all the values where x is FALSE.
# x & y: TRUE if both x and y are TRUE.
# x | y: TRUE if either x or y (or both) are TRUE.
# xor(x, y): TRUE if either x or y are TRUE, but not both (exclusive or).

# Most real queries involve some combination of both 
# Price less than $500: price < 500
# Size between 1 and 2 carats: carat >= 1 & carat < 2
# Cut is ideal or premium: cut == "Premium" | cut == "Ideal", or cut %in% c("Premium", "Ideal") (note that R is case sensitive)
# Worst color, cut and clarity: cut == "Fair" & color == "J" & clarity =="SI2"

# Functions can also be used in filtering expressions:
# Size is between 1 and 2 carats: floor(carat) == 1
# An average dimension greater than 3: (x + y + z) / 3 > 3
# Using function is useful for simple expressions, but for more complicated functions it's better to create a new variable first to check that the computation was done correctly before subsetting

###############################################################################################################################################################################################
# 10.2.2 Missing Values
###############################################################################################################################################################################################
# NA, is R missing value indicator. R underlying philosophy forces one to recognize missing values in data sets and to make a deliberate choice in dealing with them
# Missing values never silently go missing and must be dealt with, due to them be infectious: with few exceptions, the result of any operation that includes a missing value will be a missing value
# This is because NA represents an unknown value, and there are few operations that turn an unknown value into a known one

x <- c(1,2,NA)
x == 1 # TRUE FALSE NA
x + 10 # 11 NA 12

# It may be tempting to use "==" when find NA values but that doesn't work

x == NA # NA NA NA

# This is because there's no way to compare how two unknown values. Instead use is.na(X) o determine if a value is missing

is.na(x) # FALSE FALSE  TRUE

# filter() only includes observations where all arguments are TRUE, so NA values are automatically dropped
# To include missing values, it must be explicitly stated: x > 10 | is.na(x).

###############################################################################################################################################################################################
# 10.2.3 Exercises
###############################################################################################################################################################################################
# 1. Practice your filtering skills by:
# a. Finding all the diamonds with equal x and y dimensions.

diamonds %>% filter(x == y)

# b. A depth between 55 and 70.

diamonds %>% filter(depth >= 55 & depth <= 70)

# c. A carat smaller than the median carat.

median(diamonds$carat) # 0.7
diamonds %>% filter(carat < median(carat))

# d. Cost more than $10,000 per carat

diamonds %>% filter(price/carat > 10000)

# e. Are of good or better quality

diamonds %>% filter(cut != "Fair")

# Repeat the analysis of outlying values with z. Compared to x and y, how would you characterize the relationship of x and z, or y and z?

diamonds %>% filter(x > 0, y > 0, y < 20, z < 30, z > 0) %>% ggplot(aes(x, z)) + geom_bin2d() + geom_abline(slope = 1, color = "white", size = 1, alpha = 0.5) # There appears to be a strong correlation between x and z

diamonds %>% filter(x > 0, y > 0, y < 20, z < 30, z > 0) %>% ggplot(aes(y, z)) + geom_bin2d() + geom_abline(slope = 1, color = "white", size = 1, alpha = 0.5) # There appears to be a strong correlation between x and z

# 3.Install the ggplot2movies package and look at the movies that have a missing budget. How are they different from the movies with a budget?

movies_na <- movies %>% filter(is.na(budget))

movies %>% ggplot(aes(length), color = "red") + geom_freqpoly() + geom_freqpoly(data = movies_na, aes(x = length), color = "blue") # Length doesn't seem to be a contributing factor
movies %>% ggplot(aes(year), color = "red") + geom_freqpoly() + geom_freqpoly(data = movies_na, aes(x = length), color = "blue") # it appears that most movies without budgets were made prior to the year 2000

# 4. What is NA & FALSE and NA | TRUE? Why? Why doesn’t NA * 0 equal zero? What number times zero does not equal 0? What do you expect NA ˆ 0 to equal? Why?
NA | FALSE # NA. This is always NA because it isn't possible to evaluate an unknown and thus defaults to always being unknown
NA | TRUE  # TRUE. This works because the equation will always be TRUE no matter the condition of the first, even if the value is unknown
NA * 0 # NA. Can't multiply an unknown value by zero because NA can be thought of as a placeholder but what that number is evaluated by 0 it is unknown
NA ^ 0 # 1. This is because any number raised to the power of 0 will be 1 even if that value is unknown

###############################################################################################################################################################################################
# 10.3 Create New Variables
###############################################################################################################################################################################################
# To better explore the relationship between x and y, it’s useful to “rotate” the plot so that the data is flat, not diagonal.
# This can do that by creating two new variables: 
# one that represents the difference between x and y (which in this context represents the symmetry of the diamond) 
# one that represents its size (the length of the diagonal).

# New variables can be created using mutate(). Like filter() it takes a data frame as its first argument and returns a data frame
# Its second subsequent arguments are named expressions that generate new variables

diamonds_ok2 <- mutate(diamonds_ok, sym = x - y, size = sqrt(x ^ 2 + y ^ 2))
diamonds_ok2
ggplot(diamonds_ok2, aes(size, sym)) + stat_bin2d()

# The plot above has two advantages
# It can easily showcase the pattern followed by most diamonds
# The outliers can be easily selected 
# It doesn't matter that whether the outliers are positive (x is bigger than y) or negative ( y is bigger than x). The absolute value of the symmetry variable can be used to pull out the outliers

ggplot(diamonds_ok2, aes(abs(sym))) + geom_histogram(binwidth = 0.10) # 0.2 seems to be an appropriate threshold to remove the outliers 

diamonds_ok3 <- filter(diamonds_ok2, abs(sym) < 0.20)
ggplot(diamonds_ok3, aes(abs(sym))) + geom_histogram(binwidth = 0.01) # The graph shows that most diamonds are close to being symmetrical, there are very few that are close to being perfectly symmetrical 

###############################################################################################################################################################################################
# 10.3.1 Useful Tools
###############################################################################################################################################################################################
# There are a few types of transformations that are useful in a multifarious amount of circumstances
# Log transformations. They turn multiplicative relationships into additive relationships and compress data that varies over orders of magnitudes. They also convert power relationships to linear relationships
# Relative difference: If one is interested in the relative difference between two variables, use log(x / y). It’s better than x / y because it’s symmetric
# Sometimes integrating or differentiating might make the data more interpretable (Note that integration makes data more smooth; differentiation makes it less smooth.)
# Partition a number into magnitude and direction with abs(x) and sign(x)
# Partitioning into overall size and difference is often useful, as seen above
# If there is a strong trend, use a model to partition it into pattern and residuals is often useful.

###############################################################################################################################################################################################
# 10.3.2 Exercises
###############################################################################################################################################################################################
# 1. Practice your variable creation skills by creating the following new variables:
# a. The approximate volume of the diamond (using x, y, and z).

diamonds %>% mutate(volume = x * y * z)

# b. The approximate density of the diamond.

diamonds %>% mutate(volume = x * y * z, density = carat/volume)

# c. The price per carat.

diamonds %>% mutate(pricepercarat = price / carat)

# d.  Log transformation of carat and price.

diamonds %>% mutate(relation = log(price / carat))

# 2. How can you improve the data density of ggplot(diamonds, aes(x, z)) + stat bin2d(). What transformation makes it easier to extract outliers?

ggplot(diamonds, aes(x, z)) + stat_bin2d()
diamonds %>% mutate(relation = log(x/z)) %>% ggplot()

# 3. The depth variable is just the width of the diamond (average of x and y) divided by its height (z) multiplied by 100 and round to the nearest integer. Compute the depth yourself and compare it to the existing depth variable. Summarise your findings with a plot.

diamonds_ok %>% mutate(depth2 = ceiling(((x + y)/2)/z * 100)) %>% ggplot(aes(x, depth2)) + geom_line() + geom_line(aes(x, depth), color = "red") # The average depth is much higher than expected. It follows the same trend but at a different magnitude

###############################################################################################################################################################################################
# 10.4 Group-wise Summaries
###############################################################################################################################################################################################
# Many insightful visualizations require that you reduce the full dataset down to a meaningful summary
# dplyr does summaries in two steps:
# Define the grouping variables with group_by()
# Describe how to summarise each group with a single row with summarize() 

# For example, to look at the average price per clarity, first group by clarity, then summarise:

by_clarity <- group_by(diamonds, clarity)
sum_clarity <- summarise(by_clarity, price = mean(price))
sum_clarity

ggplot(sum_clarity, aes(clarity, price)) + geom_line(aes(group = 1), colour = "grey80") + geom_point(size = 2) # Surprising pattern to see that diamonds with better clarity have lower prices

# Supply additional variables to group_by() to create groups based on more than one variable. 
# The following example shows how cut and depth interact
# The special summary function n() counts the number of observations in each group

cut_depth <- summarise(group_by(diamonds, cut, depth), n = n())
cut_depth <- filter(cut_depth, depth > 55, depth < 70)
cut_depth
ggplot(cut_depth, aes(depth, n, colour = cut)) + geom_line()

# A grouped mutate() can be used to convert counts to proportions, os it's easier to compare across the cuts. Summarize() strips one level of grouping off so cut_depth will be grouped by cut

cut_depth <- mutate(cut_depth, prop = n / sum(n))
ggplot(cut_depth, aes(depth, prop, colour = cut)) + geom_line()

###############################################################################################################################################################################################
# 10.4.1 Useful Tools
###############################################################################################################################################################################################
# summarise() needs to be used with functions that take a vector of n values and always return a single value. Those functions include:
# Counts: n(), n distinct(x).
# Middle: mean(x), median(x).
# Spread: sd(x), mad(x), IQR(x).
# Extremes: quartile(x), min(x), max(x).
# Positions: first(x), last(x), nth(x, 2).

# An extremely useful technique is to use sum() or mean() with a logical vector
# When a logical vector is treated as numeric, TRUE becomes 1 and FALSE becomes 0. This means that sum() reveals the number of TRUEs, and mean() gives the proportion of TRUEs
# For example, the following code counts the number of diamonds with carat greater than or equal to 4, and the proportion of diamonds that cost less than $1000

diamonds %>% summarize(count = sum(carat >= 4), prop = mean(price < 1000))

# Most summary functions have a na.rm argument: na.rm = TRUE that tells the summary function to remove any missing values prior to summariziation

###############################################################################################################################################################################################
# 10.4.2 Statistical Considerations
###############################################################################################################################################################################################
# When summarizing with the mean or median, its always a good idea to include a count and measure of spread. This helps calibrate assessments of the data

by_clarity <- diamonds %>%
  group_by(clarity) %>%
  summarise(
    n = n(),
    mean = mean(price),
    lq = quantile(price, 0.25),
    uq = quantile(price, 0.75)
  )
by_clarity # This data suggests that the mean may be a bad summary for this data due to the distributions of price being highly skewed to the point where the mean is higher than the upper quartile for some groups

ggplot(by_clarity, aes(clarity, mean)) +
  geom_linerange(aes(ymin = lq, ymax = uq)) +
  geom_line(aes(group = 1), colour = "grey50") +
  geom_point(aes(size = n))

###############################################################################################################################################################################################
# 10.4.3 Exercises
###############################################################################################################################################################################################
# 1. For each year in the ggplot2movies::movies data determine the percent of movies with missing budgets. Visualize the result.

movies %>% group_by(year) %>% summarise(no_budget = sum(is.na(budget)/n())) %>% ggplot(aes(year, no_budget)) + geom_line() + scale_y_continuous(expand = c(0,0), limits = c(0, 1))

# Interestingly the data shows two important trends:
# Over time, there have been more movies created that have had a budget
# The vast majority of movies over history and even today were created without a budget. 

# 2. How does the average length of a movie change over time? Display your answer with a plot, including some display of uncertainty.

movies %>% group_by(year) %>% summarize(avglength = mean(length), n = n(), lq = quantile(length, 0.25), uq = quantile(length, 0.75)) %>%
  ggplot(aes(year, avglength), color = "red") + geom_line(size = 2) + theme_tufte() 

# The plot shows that overtime the average length of movies has increased over the last 100 years

# 3. For each combination of diamond quality (e.g. cut, color and clarity), count the number of diamonds, the average price and the average size. Visualize the results.

diamonds %>% group_by(cut, color, clarity) %>% summarise(n = n(), avgprice = mean(price), avgsize = mean(carat)) %>%
  ggplot(aes(avgprice, avgsize), color = cut) + geom_point() + geom_smooth() # We see overall there is a moderate trend between avgprice and avgsize for most diamonds

###############################################################################################################################################################################################
# 10.5 Learning More
###############################################################################################################################################################################################
# dplyr provides a number of other verbs that are less useful for visualization but important to know in general:
# arrange() orders observations according to variable(s). This is most useful when you’re looking at the data from the console. It can also be useful for visualizations if you want to control which points are plotted on top.
# select() picks variables based on their names. Useful when you have many variables and want to focus on just a few for analysis.
# rename() allows you to change the name of variables.
# Grouped mutates and filters are also useful, but more advanced. See vignette("window-functions", package = "dplyr") for more details.
# dplyr can work directly with data stored in a database - you use the same, R code as you do for local data and dplyr generates SQL to send to the database. See vignette("databases", package = "dplyr") for the details.

###############################################################################################################################################################################################
# End of Chapter 10
###############################################################################################################################################################################################


