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
library(directlabels)
library(nlme)
library(rmarkdown)
library(ggmap)

###############################################################################################################################################################################################
# Chapter 4: Mastering the Grammar
###############################################################################################################################################################################################
# 4.1 Introduction
###############################################################################################################################################################################################
# By understanding the underlying grammar and how its components fit together, will allow for an individual to create a wider range of visualizations, combine multiple sources of data, and customize to any extent
# The grammar makes it easier to iteratively update a plot, changing a single feature at a time
# The grammar is also useful because it suggests the high-level aspects of a plot that can be changed, providing a framework to think about the graphics and shortening the distance from mind to paper
# it also encourages the use of graphics customized to a particular problem, rather than relying on specific chart types

###############################################################################################################################################################################################
# 4.2. Building a Scatterplot
###############################################################################################################################################################################################
# To explore how engine size and fuel economy are related, a scatterplot of engine displacement and highway mpg with points colored by number of cylinders may be created

ggplot(mpg, aes(displ, hwy, color = factor(cyl))) + geom_point() 

# The plot is easy to make but how does ggplot2 draw this plot?

###############################################################################################################################################################################################
# 4.2.1 Mapping Aesthetics to Data
###############################################################################################################################################################################################
# A scatterplot represents each observation as a point, positioned according to the value of two variables. As well as a horizontal and vertical position each point also has a size, a color, and a shape
# The horizontal, vertical position, size, color, and shape are aesthetic attributes, and are the properties that can be perceived on the graphic
# Each aesthetic can be mapped to a variable, or set to a constant value
# In the previous graphic, displ is mapped to horizontal position, hwy to vertical position and cyl to color. Size and shaped are not mapped to variables, but remain at their constant default values
# With the mappings of the aesthetics it is possible to create a dataset that records this information:

df <- tibble(x = c(2.0, 2.0,2.8 , 2.8, 3.1, 1.8), y = c(31,30,26,26,27,26), color = c(4,4,6,6,6,4)) # This is an example of how the data mapping of aesthetics works

# This new dataset is a result of applying the aesthetic mappings to the original data. Many different types of plots can be created using this data
# Scatter plots uses points, but the data could instead be used to draw lines to create a line plot. Bars for a bar plot. These examples don't make sense for this data but can still be used to draw these plots

ggplot(mpg, aes(displ, hwy, color = factor(cyl))) + geom_line() + theme(legend.position = "none") # Line plot
ggplot(mpg, aes(displ, hwy, color = factor(cyl))) + geom_bar(stat = "identity", position = "identity", fill = NA) + theme(legend.position = "none") # Bar chart

# ggplot can produce many plots that don't make sense, yet are grammatically valid. 
# Points, line, and bars are all examples of geometric objects or geoms. Geoms determine the "type" of the plot. Plots that use a single geom are often given a special name:

df <- tibble("Plot" = c("Scatterplot", "Bubblechart", "Barchart", "Box-and-whisker plot", "Line chart"),
              "Geom" = c("Point", "Point", "Bar", "Boxplot", "Line"),
              "Features" = c("-", "Size mapped to a variable", "-", "-", "-")) 
df

# More complex plots with combination of multiple geoms don't have a special name, and must be described by hand. For example, a plot that overlays a per group regression line on top of a scatterplot

ggplot(mpg, aes(displ, hwy, color = factor(cyl))) + geom_point() + geom_smooth(method = "lm")

###############################################################################################################################################################################################
# 4.2.2 Scaling
###############################################################################################################################################################################################
# The values in the previous table have no meaning to the computer. They must be covert to data units (ex. litres, miles per gallon and number of cylinders) to graphical units (pixels and colors) that the computer can display
# This conversion process is called scaling and performed by scales. These values are relatively useless to humans but meaningful to computers. Colors are represented by a sex-letter hexadecimal string, sizes by a number and shapes by an integer
# In the mapping of aesthetics data, there are three aesthetics that need to be scaled:
# 1. Horizontal position
# 2. Vertical position
# 3. Color

# Scaling position is relatively trivial because the default linear scales can simply be used. The data range will be mapped to a linear map of [0,1]. [0,1] is used instead of exact pixels because the drawing system that ggplot employs, grid, takes care of the final conversion.
# The final step determines how the two positions (x and y) are combined to form the final location of the plot. This is done by the coordinate system (or coord). For a majority of cases this will be Cartesian coordinates, but may be polar coordinates or a spherical projection used for a map.

# The process for mapping the colors is a bit more complex, since it is a non-numeric result: colors. Colors can be thought of as giving three components, corresponding to the three types of color-detecting cells in the human eye.
# These three cell types give rise to a three-dimensional color space. Scaling then involves mapping the data values to points in this space. There are many ways to do this, but since cyl is a categorical variable the values are mapped to evenly spaced hues on the color wheel. A different mapping is used when the variable is continuous
# The results is a conversions is below. Including the aesthetics that have been mapped to a variable, the aesthetics include are the constant throughout the data. These aesthetics must be completely specified so R can draw the plot. The points will be filled circles (shape 19 in R) with a 1-mm diameter

df <- tibble(x = c(0.037, 0.074, 0.074, 0.074, 0.222, 0.222, 0.278, 0.037),
             y = c(0.531, 0.531, 0.594, 0.562, 0.438, 0.438, 0.469, 0.438),
             color = c("#F8766D", "#F8766D", "#F8766D", "#F8766D", "#00BFC4", "#00BFC4", "#00BFC4", "#F8766D"),
             size = c(1, 1, 1, 1, 1, 1, 1, 1),
             shape = c(19, 19, 19, 19, 19, 19, 19, 19))
df

# Finally the data is render to create the graphical objects that are displayed 
# To create a complete plot, a combination of graphical objects from three sources must be collected:
# 1. Data, represented by the point geom
# 2. Scales and coordinate system: Which generates axes and legends so that values can be read from the graph
# 3. Plot annotations, such as the background and plot title

###############################################################################################################################################################################################
# 4.3 Adding Complexity
###############################################################################################################################################################################################
# Here's a slightly more complex example:

ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_smooth() + facet_wrap(~year)

# The plot above adds three new components to the mix:
# 1. Facets
# 2. Multiple layers
# 3. Statistics 

# The facets and layers expand the data structure described. Each facet panel in each layer has its own dataset. 
# This can be though of as a 3d array: the panels of the facets form a 2d grid, and the layers extend upwards in the 3rd dimension. In this case the data in the layers is the same, but in general different datasets are plotted on different layers
# The smooth layer is different to the point layer because it doesn't display raw data, but rather a statistical transformation of the data. 
# Specifically, the smooth layers fits a smooth line through the middle of the data. This requires an additional step. 
# After mapping the data to aesthetics, the data is passed to a statistical transformation, or **stat**, which manipulates the data in a useful way 
# For the smooth line, the stat firs the data to a loess smoother, and then returns predictions from the evenly spaced points within the range of the data, 
# Other useful stats include 1 and 2d binning, group means, and quantile regression and contouring 

# There are additional steps to the scales. With multiple datasets (for the different facets and layers), the scales are adjusted so they are the same across all of them.
# Scaling occurs in three parts:
# 1. Transforming
# 2. Training
# 3. Mapping

# Scale transformation occurs before statistical transformation so that statistics are computed on the scale-transformed data. This ensures that a plot of log(x) vs log(y) on linear scales looks the same as x vs y on log scales
# After computing the statistics. Each scale is trained on every dataset from all the layers and facets. The training operation combines the ranges of the individual datasets to get the range of the complete data. 
# Without this step, scales could only make sense locally and it wouldn't be possible to overlay different layers because their positions wouldn't line up. 
# Finally the scales map the data values into aesthetic values, This is a local operation: the variables in each dataset are mapped to their aesthetic values, producing a new dataset that can then be rendered by the geoms

###############################################################################################################################################################################################
# 4.4 Components of the Layered Grammar
###############################################################################################################################################################################################
# The past examples have shown what components make up a plot: data, and aesthetic mappings, geometric objects(geoms), statistical transformations (stats), scales, and faceting 
# Additionally position adjustment is also another component that deals with overlapping graphic objects
# Together the data, mapping, stat, geom and position adjustment form a layer. A plot may have multiple layers, for example a smoothed line overlaid a scatterplot
# All together, the layered grammar defines a plot as the combination of:
# A default dataset and set of mappings from variables to aesthetics
# One or more layers, each composed of a geometric object, a statistical transformation, a position adjustment, and optionally, a dataset and aesthetic mappings
# One scale for each aesthetic mapping 
# A coordinate system
# The faceting specification 

###############################################################################################################################################################################################
# 4.4.1  Components of the Layered Grammar
###############################################################################################################################################################################################
# Layers are responsible for creating the objects that are perceived on the plot
# A layer is composed of five parts: 
# 1. Data
# 2. Aesthetic mappings
# 3. A statistical transformation (stat)
# 4. A geometric object (geom)
# 5. A position adjustment

###############################################################################################################################################################################################
# 4.4.2  Scales
###############################################################################################################################################################################################
# A **scale** control the mapping from data to aesthetic attributes, and a scale is needed for every aesthetic used on a plot.
# Each scale operates across all the data in the plot, ensuring a consistent mapping from data to aesthetics.
# A scale is a function and its inverse, along with a set of parameters. 
# For example, the color gradient scale maps a segment of the real line path through a color space. The parameters of the function define whether the path is linear or curved, which color space to use, and the colors at the start and end
# The inverse function is used to draw a guide, so values can be read from the graph. Most mappings have a unique inverse (the mapping function is one-to-one), but many do not.
# A unique inverse makes it possible to recover the original data, but this is not always desirable if the attention is directed on a single aspect

###############################################################################################################################################################################################
# 4.4.3 Coordinate System
###############################################################################################################################################################################################
# A coordinate system, or **coord**, maps the position of objects onto the plane of the plot. 
# Position is often specified by two coordinates (x,y) but potentially could be three or more (although this is not implemented in ggplot2).
# The Cartesian coordinate system is the most common coordinate system for two dimensions, while polar coordinates and various map projections are used less frequently
# 







