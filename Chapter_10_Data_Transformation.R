library(tidyverse)

###############################################################################################################################################################################################
# Chapter 10: Data Transformation
###############################################################################################################################################################################################
# 10.1 Introduction
###############################################################################################################################################################################################
# The package dplyr provides verbs (functions) to help solve the most common data manipulation problems
# The most important dplyr vers are filter(), mutate(), group_by() and summarise()
# All of the verbs work the same way, they take a data frame as the first argument and return a modified ddata frame

###############################################################################################################################################################################################
# 10.2 Filter OBservations
###############################################################################################################################################################################################
# A useful data analysis strategy is working with just one observation unit before attempting to work with the whole dataset 
# Filtering is useful for extracting outliers. Generally outliers shouldn't just be thrown away but its useful to partition data into the common and unusual

ggplot(diamonds, aes(x,y)) + geom_bin2d()

# THe plot above has around 50,000 points in the dataset and have most of them lying in the diagonal, with only a handful of outlier, that can be removed with filter()

filter(diamonds, x == 0 | y == 0)

# filter() is very similar to subset with the key difference being that subset() can select both observations and variables, while filter() works exclusively with observations and select() with variables
# THe manin advantage for filter() is it behaves identically to other dplyr verbs and is a bit faster than subset()
# In real analysis, one would look at outliers in more detail to see if there is a data quality problem, however in this case, they will be filtered out from the dataset

diamonds_ok <- filter(diamonds, x > 0, y > 0, y < 20)
ggplot(diamonds_ok, aes(x,y)) + geom_bin2d() + geom_abline(slope = 1, color = "white", size = 1, alpha = 0.5) # plot shows a strong relationship between x and y
 
###############################################################################################################################################################################################
# 10.2.1 Useful Tools
###############################################################################################################################################################################################
# The first argument to filter() is a data frame, the second and subsequent arguments must be logical vectors
# filter() selects every row where all the logical expressions are TRUE
# The logical vectors must always be the same length aas the data frame; if not an error occurs
# Logical vectors are created with comparsion operators:
# x == y: x and y are equal.
# x != y: x and y are not equal.
# x %in% c("a", "b", "c"): x is one of the values in the right hand side.
# x > y, x >= y, x < y, x <= y: greater than, greater than or equal to, less than, less than or equal to.
# and then combined with logical operators:
# !x (pronounced “not x”), flips TRUE and FALSE so it keeps all the values where x is FALSE.
# x & y: TRUE if both x and y are TRUE.
# x | y: TRUE if either x or y (or both) are TRUE.
# xor(x, y): TRUE if either x or y are TRUE, but not both (exclusive or).

# Most real queries invovle some combination of both 
# Price less than $500: price < 500
# Size between 1 and 2 carats: carat >= 1 & carat < 2
# Cut is ideal or premium: cut == "Premium" | cut == "Ideal", or cut %in% c("Premium", "Ideal") (note that R is case sensitive)
# Worst colour, cut and clarity: cut == "Fair" & color == "J" & clarity =="SI2"

# Functions can also be used in filtering expressions:
# Size is between 1 and 2 carats: floor(carat) == 1
# An average dimension greater than 3: (x + y + z) / 3 > 3
# Using function is useful for simple expressions, but for more complicated functions it's better to create a new variable first to check that the computation was done correctly before subsetting

###############################################################################################################################################################################################
# 10.2.2 Missing Values
###############################################################################################################################################################################################




