library(tidyverse)
library(tidyr)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(nycflights13)
library(Lahman)
library(ggstance)
library(lvplot)
library(ggbeeswarm)
library(heatmaply) 
library(hexbin)
library(modelr)
library(forcats)
library(stringr)
library(lubridate)
library(purrr)
library(readxl)
library(writexl)
library(modelr)
library(gt)
library(ggthemes)
library(mgcv)

###############################################################################################################################################################################################
# Chapter 3: Toolbox
###############################################################################################################################################################################################
# 3.1 Introduction
###############################################################################################################################################################################################
# The layered structure of ggplot2 encourages an individual to design and construct graphics in a structured manner 
# There are three purposes for a layer:
# 1. Ti display the data. When plotting raw data, skills at pattern detection are used to spot gross structure, local structure, and outliers. This layer appears on virtually every graphic
# 2. To display a statistical summary of the data. It is useful to display model predictions in the context of data. Showing the data helps improve the model and showing the model helps reveal subtleties of the data that may be missed. Summaries are usually drawn on top of data
# 3. To add additional metadata: context, annotations, and references. A metadata layer displays background context, annotations that help to give meaning to raw data or fixed references that aid comparisons across panels
# Metadata can be useful in the background and foreground. A map is often used as a background later with spatial data.
# Background metadata is rendered so it doesn't interfere with the perception of the data, so it is usually underneath the data and formatted so it's minimally perceptible. That is if focused on, it can be spotted with ease, but otherwise it blends into the background of the plot
# Metadata can also be used to highlight important features of the data. Such as Explanatory labels to couple inflection points or outliers that they are rendered clearly to the viewer

###############################################################################################################################################################################################
# 3.2 Basic Plot Types
###############################################################################################################################################################################################
# The following geoms are the fundamental building blocks of ggplot2. They are useful on their own but are also used to construct more complex geoms
# Each of the following geoms is two dimensional and requires both x and y aesthetics. All of them understand color and size aesthetics and the filled geoms (bar, tile, and polygon) also understand fill\

# geom_area() draws an area plot. A line plot filled to the y-axis (filled lines). Multiple groups will be stacked on top of each other
# geom_bar(stat = "identity") makes a bar chart. stat = "identity" is required because the default stat automatically counts values (thus becomes a 1d geom). The identity stat leaves the data unchanged. Multiple bars in the same location will be stacked on top of one another
# geom_line() makes a line plot. The group aesthetic determines which observations are connected. Geom_line() connects points from left to right; geom_path)_ is similar but connects points in the order they appear in the data. Both geom_line() and geom_path() also understand the aesthetic linetype, which maps a categorical variable to solid, dotted, and dashed lines
# geom_point() produces a scatterplot. geom_point() also understands the shape aesthetic
# geom_polygon() draws polygons, which are filled paths. Each vertex of the polygon requires a separate row in the data, It is often useful to merge a data frame of polygon coordinates with the data prior to plotting
# geom_rect(), geom_tile() and geom_raster() draw rectangles. Geom_rect() is parameterised by the four corners of the rectangle, xmin, ymin, x,max and ymax. geom_tile() is exactly the same, but parameterised by the center of the rect and its size, x, y, width and height. geom_raster() is a fast special case of geom_tile() used when all the tiles are the same size

df <- data.frame(x = c(3,1,5), y = c(2,4,6), label = c("a", "b", "c"))

p <- ggplot(df, aes(x, y, label = label)) + 
  labs(x = NULL, y = NULL) +  # This code hides the axis labels
  theme(plot.title = element_text(size = 12)) # Shrinks the plot title
p + geom_point() + ggtitle("point") # Regular scatterplot with points at the 3 pairs of coordinates
p + geom_text() + ggtitle("text") # Similar to the scatterplot but each of the points is replaced with the letter of the coordinate (3,2) = "a"
p + geom_bar(stat = "identity") + ggtitle("bar") # Bar graph that uses the y column values instead of count
p + geom_tile() + ggtitle("raster") # A geom_tile graph that displays 3 rectangles of the same size 
p + geom_line() + ggtitle("line") # Line graph that connects the 3 points together 
p + geom_area() + ggtitle("area") # An area graph where everything under the coordinates is filled in
p + geom_path() + ggtitle("path") # A line plot that connects the points in the order that they appear in the data frame
p + geom_polygon() + ggtitle("polygon") # Creates a filled in triangle whose points are the coordinates found within the data frame

###############################################################################################################################################################################################
# 3.1. Exercises
###############################################################################################################################################################################################
# 1. What geoms would you use to draw each of the following named plots?
# a. Scatter plot

# geom_point() 

# b. Line chart

# geom_line() or geom_path() depending on how the points would need to be connected

# c. Histogram

# geom_histogram() or geom_freqpoly() depending on how the data should be displayed

# d. Bar chart

# Either geom_col() or geom_bar() depending on the stat

# e. Pie chart

# Use pie() and then use geom_bar and use coord_polar() to make it circular 

pie <- ggplot(mpg, aes(manufacturer, fill = manufacturer )) + geom_bar()
pie + coord_polar(theta = "y")

# 2. What’s the difference between geom path() and geom polygon()? What’s the difference between geom path() and geom line()?

p + geom_path() + ggtitle("path") 
p + geom_polygon() + ggtitle("polygon") 

# The difference between geom_path() and geom_polygon() is that geom_path will connect the coordinates in order of appearance within the data. It will not connect the first and last coordinate. 
# However, geom_polygon will connect to all coordinates in order and will make an additional line between the first and last point to create a filled in polygon

p + geom_path() + ggtitle("path") 
p + geom_line() + ggtitle("line")

# Geom_path() connects points in the order they appear in the data, geom_line() move left to right to connect the points and goes up or down in value compared to geom_path() which can go sideways(horizontal)

# 3. What low-level geoms are used to draw geom_smooth()? What about geom_boxplot() and geom_violin()?

ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_smooth(span = 0.3)

# Geom smooth uses geom_line() probably three times or geom_polygon to create the shadow

# Geom_boxplot() uses geom_rectangle to make the square
# geom_violin() uses geom_path()

###############################################################################################################################################################################################
# 3.3. Labels
###############################################################################################################################################################################################


