library(tidyverse)
library(rmarkdown)

###############################################################################################################################################################################################
# Chapter 5: Build a Plot Layer by Layer
###############################################################################################################################################################################################
# 5.1 Introduction
###############################################################################################################################################################################################
# One of the by aspects of ggplot is that it allows for the creation of complex graphs that are built one layer at a time
# Each layer can come from a different dataset and can have different aesthetic mappings, creating a sophisticated graph that displays data from multiple sources
# This chapter will discuss how to control all five components of a layer:
# 1. The data
# 2. The aesthetic mappings
# 3. The geom
# 4. The stat
# 5. The position adjustments

###############################################################################################################################################################################################
# 5.2 Building a Plot
###############################################################################################################################################################################################
# Often times when creating a plot, a layer with a geom function is applied to the plot.
# However it is important to realize there are two distinct steps.

p <- ggplot(mpg, aes(displ, hwy)) # A simple plot with only the grid and no other layers
p

# Nothing is on the plot yet without adding further layers

p + geom_point()

# geom_point() is a shortcut. Behind the scene, it calls the layer() function to create a new layer

p + layer(mapping = NULL, data = NULL, geom = "point", stat = "identity", position = "identity") # Creates the exact same figure as geom_point()

# This call fully specifies the five components to the layer
# 1. Mapping: A set of aesthetic mappings, specified using the aes() function. If NULL it uses the default mapping set in ggplot()
# 2. Data: A dataset that overrides the default plot dataset. It is usually omitted and inherits the default dataset in the ggplot() call
# 3. Geom: The name of the geometric object used to draw the observations. All geoms take aesthetics as parameters. If supplied an aesthetic (color) as a parameter it will not be scaled, allowing for the appearance of the plot to be controlled
# 4. Stat: The name of statistical transformation to use. Stats perform statistical summaries of the data provided. Every geom has a default stat and every stat a default geom. Stats can take additional parameters to specify the details of statistical transformation.
# 5. Position: The method used to adjust overlapping objects, like jittering, stacking, or dodging

# It's useful to understand the layer() function to have a mental model of the layer, but it will be rarely used due to it being so verbose. The geom_functions are exactly equivalent to layer and can be used instead.

###############################################################################################################################################################################################
# 5.3 Data
###############################################################################################################################################################################################
# Every layer must have must data associated with it, and that data must be in a tidy data frame
# A tidy data frame has variables in the columns and observations in the rows. This is a strong restriction but for good reason:
# Data should be explicit
# A single data frame is easier to save and reproduce than a multitude of vectors

# The data on each layer doesn't need to be the same, and it's often useful to combine multiple datasets in to a single plot: As an example:

mod <- loess(hwy ~ displ, data = mpg) # Creates a loess model based on the data (Note the formula is followed as y ~ x)
grid <- data.frame(displ = seq(min(mpg$displ), max(mpg$displ), length = 50)) # This line creates a sequence of 50 values from the minimum value of displ to max 
grid$hwy <- predict(mod, newdata = grid) # Predicts the values from the generated data set above
grid

#  Next, the observations that are particularly far from the predicted values will be isolated

std_resid <- resid(mod) / mod$s # The observations created from loess formula are dived by the residual standard error found in the loess object
outlier <- filter(mpg, abs(std_resid) > 2) # Filtering to select the residual values that have a high RSME
outlier

# These datasets were generated to enhance the display of raw data with a statistical summary and annotations

ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_line(data = grid, color = "blue", linewidth = 1.5) + geom_text(data = outlier, aes(label = model))

# Note the explicit data call in the layers but not in the ggplot. This is due to the argument order being different. 
# In the example above, every layer uses a different dataset. The same plot could be defined in another way by omitting the default dataset, and specifying a dataset for each layer

ggplot(mapping = aes(displ, hwy)) + geom_point(data = mpg) + geom_line(data = grid) + geom_text(data = outlier, aes(label = model))

# The code is confusing because it doesn't make clear what the primary dataset is. 

###############################################################################################################################################################################################
# 5.3.1 Exercises
###############################################################################################################################################################################################
# 1. The first two arguments to ggplot are data and mapping. The first two arguments to all layer functions are mapping and data. Why does the order of the arguments differ? (Hint: think about what you set most commonly.)
# ggplot sets the data first, while geom layers set their aesthetics first.
# 2. The following code uses dplyr to generate some summary statistics about each class of car. Use the data to recreate this plot:

class <- mpg %>% group_by(class) %>% summarise(n = n(), hwy = mean(hwy))

ggplot(mpg, aes(class, hwy)) + geom_jitter(size = 5, width = 0.1, height = 0.1) + geom_point(data = class, color = "red", size = 8) + geom_text(data = class, aes(y = 10, x = class, label = paste0("n =", n)))

###############################################################################################################################################################################################
# 5.4 Aesthetic Mappings
###############################################################################################################################################################################################
# Aesthetic mappings defined with aes(), describe how variables are mapped to visual properties or **aesthetics**
# Aes() takes a sequence of aesthetic-variable pairs like:

ggplot(mpg, aes(x = displ, y = hwy, color = class))

# In this scenario the x position is mapped to displ, the y-position to hwy, and color to class
# The first two argument names can be omitted, in which they would still correspond to the x and y variables

ggplot(mpg, aes(displ, hwy, color = class))



