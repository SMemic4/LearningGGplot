library(tidyverse)
library(knitr)

###############################################################################################################################################################################################
# Chapter 6: Scales, Axes, and Legends
###############################################################################################################################################################################################
# 6.1 Introduction
###############################################################################################################################################################################################
# Scales control the mapping from data to aesthetics. They take data it turn it into something perceivable such as size, color, position, or shape.
# Scales provide the tools that let a plot to be read: the axes and legends.
# Formally, each scale is a function from a region in data space (the domain of the scale) to a region in aesthetic space (range of the scale)
# The axis or legends is the inverse function: it allows for the conversation of visual properties back into data

###############################################################################################################################################################################################
# 6.2 Modifying Scales
###############################################################################################################################################################################################
# A scale is required for every aesthetic used on the plot. When writing the following code:

ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = class))

# The full code looks like:

ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = class)) + scale_y_continuous() + scale_x_continuous() + scale_color_discrete()

# Default scales are named according to the aesthetic and the variable type: scale_y_continuous(), scale_color_discrete(), etc.

# ggplot2 automatically adds default scales for every new aesthetic. But to override the defaults, the scale must be manually added

ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = class)) + scale_x_continuous("The x axis") + scale_y_continuous("Y axis")

# The use of "+" to "add" scales is misleading. When using "+" to a scale, it's not being added to the plot, but overriding the existing scale

ggplot(mpg, aes(displ, hwy)) + geom_point() + scale_x_continuous("Label 1") + scale_x_continuous("Label 2") # In this case only the second label is applied to the graph

ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = class)) + scale_x_continuous("Label 2") # Equivalent plot to the one above

# A different scale can be used altogether

ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = class)) + scale_x_sqrt() + scale_color_brewer()

# The naming schemes for scales is straightforward. It is made up of 3 parts:
# 1. scale
# 2. The name of the aesthetic (color, shape, or x)
# 3. The name of the scale(continuous, discrete, brewer)

###############################################################################################################################################################################################
# 6.2.1 Exercises
###############################################################################################################################################################################################
# 1. What happens if you pair a discrete variable to a continuous scale? What happens if you pair a continuous variable to a discrete scale?

ggplot(mpg, aes(displ, hwy, color = class)) + geom_point() + scale_x_discrete() + scale_y_discrete() 

# Scaling a continuous variable on a discrete scale results in the number on the graph being removed and replaced with the name of the variable. Otherwise the graph is similar to as before

ggplot(mpg, aes(drv, hwy)) + geom_point() + scale_x_continuous() + scale_y_continuous()

# Attempting to scale a discrete variable to a continuous scale will result in an error and the graph will not be produced

# 2. Simplify the following plot specifications to make them easier to understand
# a. 
ggplot(mpg, aes(displ)) +
  scale_y_continuous("Highway mpg") +
  scale_x_continuous() +
  geom_point(aes(y = hwy))

# Simplified:

ggplot(mpg, aes(displ, hwy)) + geom_point() + ylab("Highway mpg")

# b. 

ggplot(mpg, aes(y = displ, x = class)) +
  scale_y_continuous("Displacement (l)") +
  scale_x_discrete("Car type") +
  scale_x_discrete("Type of car") +
  scale_colour_discrete() +
  geom_point(aes(colour = drv)) +
  scale_colour_discrete("Drive\ntrain")

# Simplified:

ggplot(mpg, aes(class, displ, color = drv)) +
  geom_point() +
  xlab("Type of car") +
  ylab("Displacement (l)") +
  scale_color_discrete("Drive\ntrain")

###############################################################################################################################################################################################
# 6.3 Guides: Legends and Axes
###############################################################################################################################################################################################
# The most likely component of a scale that is going to modified is **guide**, the axis or legend associated with the scale
# Guides allow for observations to be read from the plot and mapped back to their original values/
# ggplot guides are produced automatically based on the layers of the plot. 
# In ggplot2, the legend isn't directly controlled, instead the data is set up so there's a clear mapping between data and aesthetics that allow for the legend to be generated automatically

# Axis and legends are the same type of thing but while they look very different there are many natural correspondences between the two:
tibble(Axis = c("Label", "Tick and grid line", "Tick label"), Legend = c("Title", "Key", "Key label"), `Argument name` = c("name", "break", "labels"))

###############################################################################################################################################################################################
# 6.3.1 Scale Title
###############################################################################################################################################################################################
# The first argument to the scale function, *name*, is the axes/legend title. It can be supplied text strings (using \n for line breaks) or mathematical expressions in quote (as described in ?plotmath)

df <- data.frame(x = 1:2, y = 1, z = "a")
p <- ggplot(df, aes(x,y)) + geom_point()
p + scale_x_continuous("X axis")
p + scale_x_continuous(quote(a + mathematical ^ expression))

# Because changing labels is such a common task, there are three helper functions: xlab(), ylab(), and labs()

p <- ggplot(df, aes(x,y)) + geom_point(aes(color = z))
p + xlab("X axis") + ylab("Y axis") 
p + labs(x = "X axis", y = "Yaxis", color = "Color\nlegend")

# There are two ways to remove the axis label:
# 1. Setting it to "" omits the label but still allocates space
# 2. NULL removes the label and its space

P <- ggplot(df, aes(x,y)) + geom_point() + theme(plot.background = element_rect(color = "grey50"))
p + labs(x = "", y ="")
p + labs(x = NULL, y = NULL)

###############################################################################################################################################################################################
# 6.3.2 Breaks and Labels
###############################################################################################################################################################################################
# The **breaks** argument controls which values appear as tick marks on axes and keys on legends.
# Each break has an associated label, controlled by the **labels** argument. If **labels** is set, than **breaks** must also be set, otherwise the data changes, the breaks will no longer align with the labels

df <- data.frame(x = c(1, 3, 5) * 1000, y = 1)
axs <- ggplot(df, aes(x, y)) + geom_point() + labs(x = NULL, y = NULL)
axs
axs + scale_x_continuous(breaks = c(2000, 4000))
axs + scale_x_continuous(breaks = c(2000, 4000), labels = c("2k", "4k"))

leg <- ggplot(df, aes(y, x, fill = x)) + geom_tile() + labs(x = NULL, y = NULL)
leg
leg + scale_fill_continuous(breaks = c(2000, 4000))
leg + scale_fill_continuous(breaks = c(2000, 4000), labels = c("2k", "4k")) # Adjusts the scale legend with custom labels

# To relabel the breaks in a categorical scale, use a named labels vector:

df2 <- data.frame(x = 1:3, y = c("a", "b", "c"))
ggplot(df2, aes(x, y)) + geom_point()
ggplot(df2, aes(x, y)) + geom_point() + scale_y_discrete(labels = c(a = "apple", b = "banana", c = "carrot"))

# To suppress breaks (and for axes, grid lines) or labels set them to NULL:

axs + scale_x_continuous(breaks = NULL)
axs + scale_x_continuous(labels = NULL)

leg + scale_fill_continuous(breaks = NULL)
leg + scale_fill_continuous(labels = NULL)

# Additionally, a function can be supplied to **breaks** or **labels**.
# The **breaks** function should have one argument, the limits ( a numeric vector of length two), and should return a numeric vector of breaks
# The **labels** function should accept a numeric vector of breaks and return a character vector of labels (the same length as the input)
# The scales package provides a number of useful labeling functions

# The scales package provides a number of useful labeling functions:
# scales::comma_format() - Adds commas to make it easier to read large numbers
# scales::unit_format(unit, scale) - Adds a unit suffix, optionally scaling
# scales::dollar_format(prefix, suffix) - Displays currency values, rounding to two decimal places and adding a prefix or suffix
# scales::wrap_format() - Wraps long labels into multiple lines

axs + scale_y_continuous(labels = scales::percent_format()) # Coverts the y axis to a percentage scale
axs + scale_y_continuous(labels = scales::dollar_format()) # Adds $ signs to the y axis and converts scale to dollar amount

# The minor breaks (the faint grid lines that appear between the major grid lines) can be adjusted by supplying a numeric vector of positions to the minor_breaks argument

df <- data.frame(x = c(2, 3, 5, 10, 200, 3000), y = 1)
ggplot(df, aes(x, y)) +
  geom_point() +
  scale_x_log10()

mb <- as.numeric(1:10 %o% 10 ^ (0:4))
ggplot(df, aes(x, y)) +
  geom_point() +
  scale_x_log10(minor_breaks = log10(mb))

###############################################################################################################################################################################################
# 6.3.3 Exercises
###############################################################################################################################################################################################
# Recreate the following graph

ggplot(mpg, aes(displ, hwy)) + geom_point() + 
  scale_x_continuous(breaks = c(2,3,4,5,6,7), labels = c("2 L", "3 L", "4 L", "5 L", "6 L", "7 L")) +
  scale_y_continuous(quote(Highway  (Miles/Gallon)))

# 2.List the three different types of object you can supply to the breaks argument. How do breaks and labels differ?

