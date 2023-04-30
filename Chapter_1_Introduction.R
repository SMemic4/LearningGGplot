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
library(modelr)

###############################################################################################################################################################################################
# Chapter 1: Introduction
###############################################################################################################################################################################################
# 1.2 Grammar of Graphics
###############################################################################################################################################################################################
# Grammar tells refers to a statistical graphic mapping from data to aesthetic attributes (color, shape, and size) of geometric objects (points, lines, bars)
# Plots may also contain statistical transformations of the data and is drawn on a specific coordinate system
# Faceting can be used to generate the same plot for different subsets of the dataset. It is these combinations of these independent components that make up a graphic

# All plots contain the following components:
# Data to visualize  and a set of aesthetic mappings describing how variables in the data are mapped to aesthetic attributes 
# Layers made up of geometric elements and statistical transformation. Geometric objects, geoms for short, represent what are actually seen on the plot: points, lines, polygons. Statistical transformations, (stats) summarizing data in many useful ways. In example binning and counting observations to create a histogram or summarizing a 2d relationship with a linear model
# Scales map values in the data space to values in an aesthetic space through color, size, or shape. Scales draw a legend or axes, which provide an inverse mapping to make it possible to read original data values from the plot
# Coordinate system (coord) describes how data coordinates are mapped to the plane of the graphic. It also provides axes and gridlines to make it possible to read the graph. Normally a Cartesian coordinate system is used but there are other number of coordinate systems available
# Facets are a specification describing how to break up the data into subsets and how to display those subsets as small multiples. Also known as conditioning or latticing/trellising
# Themes control the finer points of display like font size and background color























