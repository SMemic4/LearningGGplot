library(tidyverse)

###############################################################################################################################################################################################
# Chapter 9: Data Analysis
###############################################################################################################################################################################################
# 9.1 Introduction
###############################################################################################################################################################################################
# To use ggplot2 in practice, data wrangling skills are required to create tidy data
# Tidy data is the foundation for data manipulation and visualizing models

###############################################################################################################################################################################################
# 9.2 Tidy Data
###############################################################################################################################################################################################
# The principle behind tidy data is simple: storing data in a consistent way making it easier to work with. 
# Tidy data is a mapping between the statistical structure of a data frame (variables and observations) and the physical structure (columns and rows)
# Tidy data has two main principles:
# 1. Variables go in columns
# 2. Observations go in rows

# Sometimes, there will be datasets that will not be tidy and will be unplottable by ggplot. For example: data that is stored across columns and rows and even column names
# To make it possible to plot this type of data it needs to be tidy. There are two important tools:
# Spread and gather
# Separate and Unite

###############################################################################################################################################################################################
# 9.3 Spread and Gather
###############################################################################################################################################################################################
# Indexed data are data values that can be looked up using an index (the values of x and y)
# Cartesian data are data values that are found by looking at the intersection of a row and column
# Tidying data often requires translating Cartesian indexed forms, called gathering, and less commonly indexed Cartesian called spreading
# The tidyr package provides the spread() and gather() functions to perform these operations

###############################################################################################################################################################################################
# 9.3.1 Gather
###############################################################################################################################################################################################
# Gather() has four main arguments:
# data: the dataset to translate
# key and value: the key is the name of the variable that will be created from the column names, and the value is the name of the variable that will be created from the cell values
# ....: which variables to gather. These can be specified individually (A,B,C,D,E) or as a range (A:E). Alternatively, it can be specified which columns to NOT gather with - (-C, -F)
# Note that for columns that have names that are not standard variable names in R they must be surrounded with backticks
# convert = TRUE will automatically convert the key column into a different data type
# na.rm = TRUE will remove any data that is missing

###############################################################################################################################################################################################
# 9.3.2 Spread
###############################################################################################################################################################################################
# spread() is the opposite of gather()
# it is used when for pairs of columns that are in indexed for, instead of Cartesian form
# For example the following dataset contains three variables (day, rain, and temp) but rain and temp are stored in indexed form

weather <- dplyr::data_frame(
  day = rep(1:3, 2),
  obs = rep(c("temp", "rain"), each = 3),
  val = c(c(23, 22, 20), c(0, 0, 5))
)
weather

# Spread allows for the transformation of this indexed from into a tidy Cartesian form. It shares many of the arguments with gather()
# Spread() just needs to be supplied data to translate, as well as the name of the key column which gives the variable names, and the value column which contains the cell values
# In this example, the key is obs and the value is val

spread(weather, key = obs, value = val)

###############################################################################################################################################################################################
# 9.4 Separate and Unite
###############################################################################################################################################################################################
# Spread and gather helps when the variables are in the wrong place in the dataset
# Separate and unite help when multiple variables are crammed into one column, or spread across multiple columns

trt <- dplyr::data_frame(
  var = paste0(rep(c("beg", "end"), each = 3), "_", rep(c("a", "b", "c"))),
  val = c(1, 4, 2, 10, 5, 11)
)
trt

# The separate() function makes it easy to tease apart multiple variables stored in one column. It takes four arguments:
# data: the data frame to modify
# col: the name of the variable to split into pieces
# into: a character vector giving the names of the new variables
# sep: a description of how to split the variables apart. This can either be a regular expression (to split by underscores, or [^a-z] to split by any non-letter, or an integer giving a position)

separate(trt, var, c("Time", "Treatment"), "_")

# If the variables are combined in a more complex form use extract()
# Alternatively, it may be necessary to create columns individualy using other calculations. Use mutate() for this

# unite() is the inverse of separate() - it joins together multiple columns into one column

###############################################################################################################################################################################################
# End of Chapter 9
###############################################################################################################################################################################################




















