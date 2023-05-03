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
# The main tool for adding text to ggplot is geom_text(), which adds labels at the specified x and y positions
# geom_text() has the most aesthetics of any geom, because there are so many ways to control the appearance of a text:

# family gives the name of a font. There are only three fonts that are guaranteed to work everywhere: "sans" (the default), "serif", or "mono"

df <- data.frame(x = 1, y = 3:1, family = c("sans", "serif", "mono"))
ggplot(df, aes(x, y)) + geom_text(aes(label = family, family = family))

# It's much harder to include a system font on a plot because text drawing is done differently by each graphics device
# So to have a font that works everywhere it is necessary to configure five devices in five different ways. Two packages simplify this process "showtext" and "extrafonts"

# The font face argument specifies the face of text: "plain" (the default), "bold", or "italic"

df <- data.frame(x = 1, y = 3:1, face = c("plain", "bold", "italic"))
ggplot(df, aes(x, y)) + geom_text(aes(label = face, fontface = face))

# The alignment of the text can be adjusted with hjust ("left", "center", "right", "inward", "outward") and vjust("bottom", "middle", "top", "inward", "outward") aesthetics
# The default alignment is centered. The most useful alignment is "inward" since it aligns text towards the middle of the plot

df <- data.frame(x = c(1, 1, 2, 2, 1.5), y = c(1, 2, 1, 2, 1.5), text = c("bottom-left", "bottom-right", "top-left", "top-right", " center"))
ggplot(df, aes(x, y)) + geom_text(aes(label = text)) 
ggplot(df, aes(x, y)) + geom_text(aes(label = text), vjust = "inward", hjust = "inward") 

# Size controls the font size. Unlike most tools, ggplot2 uses mm, rather than usual points (pts). This makes it consistent with other size units in ggplot2
# There are 72.27 pts in a inch, so to convert from points to mm, multiply by 72.27/25.4
# Angle specifies the rotation of the text in degrees

ggplot(df, aes(x, y)) + geom_text(aes(label = text), vjust = "inward", hjust = "inward", size = 5, angle = 45) 

# Data values can be mapped to these aesthetics, but is discouraged. It becomes hard to perceive the relationship between variables mapped to these aesthetics 
# Geom_text() has only three parameters. Unlike the aesthetics, these only take single values, so they must be the same for all labels

# Often it is useful to label existing points on a plot. To avoid overlapping the points, it's useful to slightly offset the label. The nudge_x and nudge_y parameters allow for the text to be moved a little either horizontally or vertically

df <- data.frame(trt = c("a", "b", "c"), resp = c(1.2, 3.4, 2.5))
ggplot(df, aes(resp, trt))  + geom_point() + geom_text(aes(label = paste0("(", resp, ")")), nudge_y = 0.1) + xlim(1, 3.6)

# If check_overlap = TRUE, overlapping labels will be automatically removed.
# The algorithm is simple: labels are plotted in the order they appear in the data frame, if a label would overlap with an existing point, it's omitted. This is not incredibly useful, but can be handy

ggplot(mpg, aes(displ, hwy)) + geom_text(aes(label = model)) + xlim(1,8) # A large amount of overlap within this graph making the graph hard to read 
ggplot(mpg, aes(displ, hwy)) + geom_text(aes(label = model), check_overlap = TRUE) + xlim(1,8) # Removes the overlapping labels if they occupy the same coordinates as another point, thus making this graph easier to read

# A variation on geom_text() is geom_label(): it draws a rounded rectangle behind the text, This makes it useful for adding labels to plots with busy background

label <- data.frame(waiting = c(58, 80), eruptions = c(2, 4.3), label = c("peak one", "peak two"))
ggplot(faithfuld, aes(waiting, eruptions)) + geom_tile(aes(fill = density)) + geom_label(data = label, aes(label = label))

# Labeling data well poses some challenges:
# Text does not affect the limits of the plot. All labels have an absolute size (3 cm) regardless of the size of the plot. This means that the limits of the plot would need to be different depending on the size of the plot
# ggplot has no way to deal with issue, thus the axes must be tweaked using xlim() and ylim()
# When labeling many points, it is difficult to avoid overlap. check_overlap = TRUE is useful, but has little control in determining which labels to remove
# There are not too many options to help label the points. Often times they must be manually edited within a drawing tool

# Text labels can serve as an alternative to a legend. This makes the plot easier to read since the data is closer to the labels
# The "directlabels" package is a useful package for task

ggplot(mpg, aes(displ, hwy, color = class)) + geom_point()
ggplot(mpg, aes(displ, hwy, color = class)) + geom_point(show.legend = FALSE) + geom_dl(aes(label = class), method = "smart.grid")

# Directlabels provides a number of position methods
# smart.grid is a reasonable place to start for scatter plots, but there are other methods that more useful for frequency polygons and line plots

###############################################################################################################################################################################################
# 3.4 Annotations
###############################################################################################################################################################################################
# Annotations add metadata to a plot. But, metadata is just data, so they are multiple options to choose from:
# geom_text() to add test descriptions or to label points. Most plots will not benefit from adding text to every single observation on the plot, but labeling outliers and other important points is useful
# geom_rect() to highlight interesting rectangular regions of the plot. geom_rect() has aesthetics xmin, xmax, ymin, and ymax
# geom_line(), geom_path(), and geom_segment() to add lines. All these geoms have an arrow parameter, which allows for the placement of an arrowhead on the line. 
# Arrowheads can be created with arrow(), which has arguments angle, length, ends and type
# geom_vline(), geom_hline() and geom_abline() allow for the addition of reference lines, that span the full range of the plot

# Typically annotations are placed in the foreground (using alpha if needed) or in the background.
# With the default background, a thick white line makes a useful reference

ggplot(economics, aes(date, unemploy)) + geom_line()

# The plot above can be annotated with which president was in power at the time

presidential <- subset(presidential, start > economics$date[1])

ggplot(economics) + 
  geom_rect(aes(xmin = start, xmax = end, fill = party), ymin = -Inf, ymax = Inf, alpha = 0.2, data = presidential) + # This line creates rectangular bars to signify what party was in power at a given time
  geom_vline(aes(xintercept = as.numeric(start)), data = presidential, color = "grey50", alpha = 0.5) +
  geom_text(aes(x = start, y = 2500, label = name), data = presidential, size = 3, vjust = 0, hjust = 0, nudge_x = 50) +
  geom_line(aes(date, unemploy)) +
  scale_fill_manual(values = c("blue", "red"))

# In the second line the Inf and -Inf are used to expand the rectangular prism to the edge of the plot
# geom_vline() adds a reference line at the start of presidents term
# geom_text() simply adds the president name to the plot, but it's positions are adjusted so they appear at the bottom of the graph and are slightly adjusted to the right of the reference line
# geom_line simply adds the unemployment trend line based off of the data
# scale_fill_manual defines which colors to assign for the parties

# The same technique can be used to a single annotation to the plot, but it's tricky because a single row data frame must be created

yrng <- range(economics$unemploy)
xrng <- range(economics$date)
caption <- paste(strwrap("Unemployment rates in the US have varied a lot over the years", 40), collapse = " ")

ggplot(economics, aes(date, unemploy)) +
  geom_line() +
  geom_text(aes(x, y, label = caption),
            data = data.frame(x = xrng[1], y = yrng[2], caption = caption),
            hjust = 0, vjust = 1, size = 4)

# It's much easier to use the annotate() helper function which creates the data frame:

ggplot(economics, aes(date, unemploy)) +
  geom_line() +
  annotate("text", x = xrng[1], y = yrng[2], label = caption, hjust = 0, vjust = 1, size = 4)

# Annotations, particularly reference lines, are also useful for comparing groups across facets

ggplot(diamonds, aes(log10(carat), log10(price))) + geom_bin2d() + facet_wrap(~cut, nrow  = 1)

# Same plot but with the reference line added

mod_coef <- coef(lm(log10(price) ~ log10(carat), data = diamonds))
ggplot(diamonds, aes(log10(carat), log10(price))) + geom_bin2d() + 
  geom_abline(intercept = mod_coef[1], slope = mod_coef[2], color = "ivory", size = 2) +
  facet_wrap(~cut, nrow  = 1)

###############################################################################################################################################################################################
# 3.5 Collective Geoms
###############################################################################################################################################################################################
# Geoms can be roughly divided into two groups: individual and collective geoms
# An individual geoms draws a distinct graphical object for each observation (row). For example, a point geom draws one point per row
# A collective geom displays multiple observations with one geometric object. This may be the result of a statistical summary (boxplot) or may be a fundamental to the display of a the geom like a polygon
# Lines and paths fall somewhere in between: Each line is composed of a set of straight segments, but each segment represents two points
# To control the assignment of observations to graphical elements use the group aesthetic
# By default, the group aesthetic is mapped to the interaction of all discrete variables in the plot. This often partitions the data correctly, but when it does not, or when no discrete variables is used in a plot, it'll need to explicitly define the grouping structure by mapping group to a variable that has a different value for each group
# There are three common cases where the default is not enough, and each one will be considered down below with longitudinal dataset "Oxboys" from the "nlme" package
# The oxboys dataset records the heights (heights) and centered ages (age) of 26 boys (Subject), measured on nine occasions (Occasion). Subject and Occasion are stored as ordered factors

head(Oxboys)

###############################################################################################################################################################################################
# 3.5.1 Multiple Groups, One Aesthetic
###############################################################################################################################################################################################
# In many situations, it's desirable to separate data into groups, but render them in the same way. In other words, the data should distinguish individual subjects, but not identify them. A common occurance in longitudianal studies with many subjects, where plots are often descriptively called spaghetti plots
# The following plot shows the growth trajectory for each boy/subject


ggplot(Oxboys, aes(age, height, group = Subject)) + geom_point() + geom_line()

# Incorrectly specifying the grouping variable will result in a characteristic saw tooth appearance:

ggplot(Oxboys, aes(age, height)) + geom_point() + geom_line() # Not the intended graph that should be displayed

