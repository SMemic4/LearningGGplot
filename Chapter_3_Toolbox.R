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

# IF a group isn't defined by a single variable, but instead by a combination of multiple variables, use interaction() to combine them, aes(group = interaction(school_id, student_id))

###############################################################################################################################################################################################
# 3.5.2 Different Groups on Different Layers
###############################################################################################################################################################################################
# There are times it is necessary to plot summaries that use different levels of aggregation: one layer might display individuals while another displays an overall summary

ggplot(Oxboys, aes(age, height, group = Subject)) + geom_line() + geom_smooth(method = "lm", se = FALSE)

# This display is displaying the summary in an unintended matter. A smoothed line was added for each boy. Grouping controls both the display and the operation of the stats. One statistical transformation is run for each group
# To counteract this effect, instead of applying the grouping aesthetic in ggplot(), where it will apply to all layers, set it in geom_line() so it applies only to the lines
# There are no discrete variables in the plot so the default grouping variable will be a constant and will display one smooth line

ggplot(Oxboys, aes(age, height)) + geom_line(aes(group = Subject)) + geom_smooth(method = "lm", linewidth = 2, se = FALSE)

###############################################################################################################################################################################################
# 3.5.3 Overriding the Default Grouping
###############################################################################################################################################################################################
# Some plots have a discrete x scale, but it can still be useful to draw lines connecting across groups. This is useful for interaction plots, profile plots, and parallel coordinate plots, among others

ggplot(Oxboys, aes(Occasion, height)) + geom_boxplot()

# Within this plot is one discrete variable, Occasion, so a boxplot is create for each unique x value. 
# To overlay lines that connect each individual boy,simply adding geom_line() does not work; the lines are drawn within each occasion not across each subject:

ggplot(Oxboys, aes(Occasion, height)) + geom_boxplot() + geom_line(color = "red", alpha = 0.5)

# To create the intended plot, override the grouping to specific that each line is dedicated to each boy

ggplot(Oxboys, aes(Occasion, height)) + geom_boxplot() + geom_line(aes(group = Subject), color = "maroon")

###############################################################################################################################################################################################
# 3.5.4 Matching Aesthetics to Graphic Objects
###############################################################################################################################################################################################
# The last issue with collective geoms is how the aesthetics of the individual observations are mapped to the aesthetics of of the complete entity
# Lines and paths operate on an off-by-one principle: there is one more observation than line segment, and so the aesthetic for the first observation is used for the first segment, second observation for the second segment and so on. This means that the aesthetic for the last observation is not used:

df <- data.frame(x = 1:3, y = 1:3, color = c(1,3,5))

ggplot(df, aes(x, y, color = factor(color))) + geom_line(aes(group = 1), size = 2) + geom_point(size = 5)
ggplot(df, aes(x, y, color = color)) + geom_line(aes(group = 1), size = 2) + geom_point(size = 5)

# It's possible to imagine a more complicated system where segments smoothly blend from one aesthetic to another
# This is possible for continuous variables like size or color, but not for discrete variables, and is not used in ggplot2
# However, this behavior can be captured by performing linear interpolation:

xgrid <- with(df, seq(min(x), max(x), length = 50))
interp <- data.frame(x = xgrid, y = approx(df$x, df$y, xout = xgrid)$y, color = approx(df$x, df$color, xout = xgrid)$y)
ggplot(interp, aes(x, y, color = color)) + geom_line(size = 2) + geom_point(data = df, size = 5)

# An additional limitation for paths and lines is that line type must be constant over each individual line. In R there is no way to draw a line which had varying line type
# For all other collective geoms like polygons, the aesthetics from the individual components are only used if the are all the same, otherwise the default value is used
# These issues are most relevant when mapping aesthetics to continuous variables, because, as described above, when you introduce a mapping to a discrete variable, it will by default split apart collective geoms into smaller pieces
# This works particularly well for bar and area plots, because stacking the individual pieces produces the same shape as the original ungrouped data

ggplot(mpg, aes(class)) + geom_bar()
ggplot(mpg, aes(class, fill = drv)) + geom_bar()

# Trying to map fill a continuous variable in the same way doesn't work. The default grouping will only be based on class, so each bar will be given multiple colors
# Since a bar can only display one color, it will use the default grey. To show multiple colors, we need multiple bars for each class, which we can get by overriding the groupings

ggplot(mpg, aes(class, fill = hwy)) + geom_bar()
ggplot(mpg, aes(class, fill = hwy , group = hwy)) + geom_bar()

# The bars will be stacked in the order defined by the grouping variable. if you need fine control, you'll need to create a factor with levels ordered as needed

###############################################################################################################################################################################################
# 3.5.5 Exercises
###############################################################################################################################################################################################
# 1. Draw a boxplot of hwy for each value of cyl, without turning cyl into a factor. What extra aesthetic do you need to set?

ggplot(mpg, aes(cyl, hwy, group = cyl, fill = cyl)) + geom_boxplot()

# The aesthetic "group = cyl" is needed 

# 2. Modify the following plot so that you get one boxplot per integer value of dispel

ggplot(mpg, aes(displ, cty)) + geom_boxplot() # Before
ggplot(mpg, aes(displ, cty)) + geom_boxplot(aes(group = displ)) # After. One boxplot for each value of displ

# 3. When illustrating the difference between mapping continuous and discrete colors to a line, the discrete example needed aes(group = 1). Why? What happens if that is omitted? What’s the difference between aes(group = 1) and aes(group = 2)? Why?

ggplot(df, aes(x, y, color = factor(color))) + geom_line(aes(group = 1), size = 2) + geom_point(size = 5)
ggplot(df, aes(x, y, color = factor(color))) + geom_line(size = 2) + geom_point(size = 5)
ggplot(df, aes(x, y, color = factor(color))) + geom_line(aes(group = 2), size = 2) + geom_point(size = 5)

# It is important to specify grouping for the line aesthetic otherwise the color wont be applied and the line wont be drawn for discrete variables. If it is omitted then no line will be drawn between the points. However even if group = 2 is used in place the line will be drawn since a grouping is specified

# 4. How many bars are in each of the following plots?

ggplot(mpg, aes(drv)) + geom_bar() # There bars. One for each of the drv
ggplot(mpg, aes(drv, fill = hwy, group = hwy)) + geom_bar() # Three bars. Because the grouping is a discrete variable 

mpg2 <- mpg %>% arrange(hwy) %>% mutate(id = seq_along(hwy))
ggplot(mpg2, aes(drv, fill = hwy, group = id)) + geom_bar() # Still three bars. Not possible to group a discrete variable and continuous variable
ggplot(mpg2, aes(drv, fill = hwy, group = id, color = "white")) + geom_bar() # There are three bars, but each bar is composed of several smaller bars laid horizontally

# 5. Install the babynames package. It contains data about the popularity of babynames in the US. Run the following code and fix the resulting graph. Why does this graph make me unhappy?

library(babynames)

hadley <- babynames %>% filter(name == "Hadley")
ggplot(hadley, aes(year, n)) + geom_line() # The issue with the graph is that it a saw tooth graph because there are two different groups of babies with the name hadley. Male and females. This can be fixed by grouping them together
ggplot(hadley, aes(year, n, group = sex, color = sex)) + geom_line() + geom_point() # Better representation of the data and graph is much easier to read

###############################################################################################################################################################################################
# 3.6 Surface Plots
###############################################################################################################################################################################################
# ggplot2 does not support true 3d surfaces, However, it does support many common tools for representing 3d surfaces in 2d: contours, colored tiles, and bubble plots
# These all work similarly, differing only in the aesthetic used for the third dimension

ggplot(faithfuld, aes(eruptions, waiting)) + geom_contour(aes(z = density, color = after_stat(level)))
ggplot(faithfuld, aes(eruptions, waiting)) + geom_raster(aes(fill = density))

# Bubble plots work better with fewer observations

small <- faithfuld[seq(1, nrow(faithfuld), by = 10),]
ggplot(small, aes(eruptions, waiting)) + geom_point(aes(size = density), alpha = 1/3) + scale_size_area()

# To work with true 3d plots, including true 3d surfaces use the "RGL" package 

###############################################################################################################################################################################################
# 3.7 Drawing Maps
###############################################################################################################################################################################################
# There are four types of map data that may be useful to visualize:
# Vector boundaries
# Point metadata
# Area metadata
# Raster images

# The hardest challenge with drawing maps is assembling the datasets
# ggplot2 lacks any useful features with that part of the analysis, but they are other packages that may help

###############################################################################################################################################################################################
# 3.7.1 Vector Boundaries
###############################################################################################################################################################################################
# Vector boundaries are defined by a data frame with one row for each corner of a geographical region like a country, state, or county. It requires four variables:
# lat and long, giving the location of a point
# group, a unique identifier for each contiguous region
# id, the name of the region
# Separate group and id variables are necessary because sometimes a geographical unit isn't a contiguous polygon. For example, Hawaii is composed of multiple islands that can't be drawn using a single polygon
# The following code extracts data from the built in maps package. However, this package isn't particularly accurate or up to date, but is fine to practice with

mi_counties <- map_data("county", "michigan") %>% select(lon = long, lat, group, id = subregion)

# A vector boundary data can be visualized with geom_polygon()

ggplot(mi_counties, aes(lon, lat)) + geom_polygon(aes(group = group), fill = NA, color = "black") + coord_quickmap()

# coord_quickmap() is a quick and dirty adjustment that ensures that the aspect ratio of the plot is set correctly
# Other useful sources of vector boundary data are:
# The USAboundaries package which contains state, county and zip code data for the US. As well as current boundaries, it also had state and county boundaries going back to the 1600's
# The tigris package, which makes it easy to access the US census tigris shapefiles. it contains state, county, zip code, and census tract boundaries as well as many other useful datasets
# The rnaturalearth package, which contains country borders, and borders for the top-level region within each country (states in US, regions in France)
# The osmar package wraps up the openstreetmap API allowing access to a wide range of vector data including individual streets and buildings
# Custom shape files (.shp) can be loaded into r with maptools::radShapeSpatial()

library(USAboundaries)
c18 <- us_boundaries(as.Date("1820-01-01"))
c18df <- fortify(c18)
head(c18df)

ggplot(c18df, aes(long, lat)) + geom_polygon(aes(group = group), colour = "grey50", fill = NA) + coord_quickmap()

###############################################################################################################################################################################################
# 3.7.2 Point Metadata
###############################################################################################################################################################################################
# Point metadata connects locations (defined by lat and lon) with other variables

mi_cities <- maps::us.cities %>% as_tibble() %>% filter(country.etc == "MI") %>% select(-country.etc, lon = long) %>% arrange(desc(pop))
mi_cities

# The data can be shown on a scatter plot but wont be terribly useful. However, point metadata can be combined with another layer to make it interpretable

ggplot(mi_cities, aes(lon, lat)) + geom_point(aes(size = pop)) + scale_size_area() + coord_quickmap()

ggplot(mi_cities, aes(lon, lat)) + geom_polygon(aes(group = group), mi_counties, fill = NA, color = "grey50") +
  geom_point(aes(size = pop), color = "red") + scale_size_area() + coord_quickmap()

###############################################################################################################################################################################################
# 3.7.3 Raster Images
###############################################################################################################################################################################################
# Instead of displaying context with vector boundaries, it may be useful to draw a traditional map underneath. This is called a raster image
# The easiest way to obtain a raster map of a given area is to use the ggmap package, which allows downloading of data from a variety of online mapping sources including OPenStreetMap and Google Maps
# Downloading the raster data is often time consuming so it's a good idea to cache it in a rds file

if (file.exists("mi_raster.rds")) {
  mi_raster <- readRDS("mi_raster.rds")
} else {
  bbox <- c(
    min(mi_counties$lon), min(mi_counties$lat),
    max(mi_counties$lon), max(mi_counties$lat)
  )
  mi_raster <- ggmap::get_openstreetmap(bbox, scale = 8735660)
  saveRDS(mi_raster, "mi_raster.rds")
}

ggmap::ggmap(mi_raster) +
  geom_point(aes(size = pop), mi_cities, colour = "red") +
  scale_size_area()

df <- as.data.frame(raster::rasterToPoints(x))
names(df) <- c("lon", "lat", "x")
ggplot(df, aes(lon, lat)) + geom_raster(aes(fill = x))

###############################################################################################################################################################################################
# 3.7.4 Area Metadata
###############################################################################################################################################################################################
# Sometimes the metadata is associated not with a point, but an area. For example, creating mi_census provides census information about each country in MI

mi_census <- midwest %>% tibble() %>% filter(state == "MI") %>% mutate(county = tolower(county)) %>% select(county, area, poptotal, percwhite, percblack)
mi_census

# However, this data cannot be directly map due to it lacking a spatial component. To fix this, first join the data to the vector boundaries data

census_counties <- left_join(mi_census, mi_counties, by = c("county" = "id"))

ggplot(census_counties, aes(lon, lat, group = county)) + geom_polygon(aes(fill = poptotal)) + coord_quickmap()

ggplot(census_counties, aes(lon, lat, group = county)) + geom_polygon(aes(fill = percwhite)) + coord_quickmap()

###############################################################################################################################################################################################
# 3.8 Revealing Uncertainty
###############################################################################################################################################################################################
# Information about the uncertainty in the data is useful to present on plot
# There are four basic families of geoms that can be used depending on whether the x values are discrete, or continuous, and whether or not they display the middle of the interval or just the extent:
# 1. Discrete x, range: geom_errorbar(), geom_linerange()
# 2. Discrete x, range and center: geom_crossbar(), geom.pointrange()
# 3. Continuous x, range: geom_ribbon()
# 4. Continuous x, range and center: geom_smooth(stat = "identity")
# These geoms assume that there is interest in the distribution of y conditionals on x and there is use of aesthetics ymin and ymax to determine the range of y values

y <- c(18, 11, 16)
df <- data.frame(x = 1:3, y = y, se = c(1.2, 0.5, 1.0))

base <- ggplot(df, aes(x, y, ymin = y - se, ymax = y + se)) # Whenever working with standard error or error bars in is necessary to have the standard error already calculated before attempting to plot onto a graph
base + geom_crossbar() # Creates a rectangular prism with a line in the middle of the rectangle. The line indicates the value of the x while the top and bottom edges of the square indicate standard error
base + geom_pointrange() # Similar to the previous graph, but each value is represented by a singular point and has lines extending from the top and bottom to represent standard error
base + geom_smooth(stat = "identity") # Creates a line graph connecting the points from left to right, and has a shadow extending outwards from the line to show standard error
base + geom_errorbar() # Creates a standard error bar with one vertical line in between two horizontal lines
base + geom_linerange() # Creates a single vertical line that extends from the lower standard error to the upper standard error
base + geom_ribbon() # Creates a line similar to geom_smooth() but the difference is the shadow and line are completely filled in 

# There are many different ways to calculate standard errors, thus choice is up to the creator

###############################################################################################################################################################################################
# 3.9 Weighted Data
###############################################################################################################################################################################################
# When a dataset contains aggregated data in which each row in the dataset represents multiple observations, it is important to take into account the weighting variable
# The choice of a weighting variable profoundly affect what is seen in the plot and the conclusions that will be drawn from it
# There are two aesthetic attributes that can be used to adjust for weights: Firstly, for simple geoms like lines and points, the size aesthetic

ggplot(midwest, aes(percwhite, percbelowpoverty)) + geom_point() # This plot shows the unweighted data

ggplot(midwest, aes(percwhite, percbelowpoverty)) + geom_point(aes(size = poptotal / 1e6)) + scale_size_area("Population\n(millions)", breaks = c(0.5, 1, 2, 4)) # This plot shows the weighted population totals and how they correlate with poverty rates within the white community 

# For more complicated transformations which involve statistical transformations, specify weight with the weight aesthetic
# The weights will be passed on to the statistical summary function. Weights are supported for every case which makes sense, smoothers, quantile regressions, boxplots, histograms, and density plots
# The weighting variable will not be able to be seen directly, but will change the results of the statistical summary
# The following code shows how weighting by population density affects the relationship between percent white and percent below the poverty line

ggplot(midwest, aes(percwhite, percbelowpoverty)) + geom_point() + geom_smooth(method = lm, size = 1) # The unweighted relationship

ggplot(midwest, aes(percwhite, percbelowpoverty)) + geom_point(aes(size = poptotal / 1e6)) + geom_smooth(aes(weight = poptotal), method = lm, size = 1) + scale_size_area(guide = "none")

# When weighing a histogram or density plot by total population, the distribution is changed from the number of counties to the distribution of the number of people

ggplot(midwest, aes(percbelowpoverty)) + geom_histogram(binwidth = 1) + ylab("Counties") # Unweighted graph showing the number of counties at their various poverty levels

ggplot(midwest, aes(percbelowpoverty)) + geom_histogram(aes(weight = poptotal), binwidth = 1, ) + ylab("Population (1000s)") # There appears to be a trend with poverty levels increasing with population growth 

###############################################################################################################################################################################################
# 3.10 Diamonds Data
###############################################################################################################################################################################################
# To demonstrate tools for large datasets, the diamonds dataset will be used. It consists of price and quality information for ~54,000 diamonds

diamonds

# The data contains the four characteristics of diamond quality: carat, cut, color, and clarity
# The data also contains five physical measurements: depth, table, x, y, and z
# The dataset is not well cleaned, so in addition to demonstrating interesting facts about diamonds, it also shows some data quality issues

###############################################################################################################################################################################################
# 3.11 Displaying Distributions
###############################################################################################################################################################################################
# There are a multitude of geoms that can be used to display distributions, depending on the dimensionality of the distribution, whether it is continuous or discrete, and whether the interest is in the conditional or joint distribution 
# For one dimensional distributions the most important geom is the histogram, geom_histogram()

ggplot(diamonds, aes(depth)) + geom_histogram() # The histogram shows that all diamonds fall between a depth of 55 and ~70. With the largest distribution of diamonds falling in between 60 to 65 depth. The data appears to be symmetric 
# The symmetrical distribution is supported by the fact that mean and median are very close to one another (Mean: 61.75, Median: 61.80)
# However, the binwidth is too large and can be further refined by picking a bin value

ggplot(diamonds, aes(depth)) + geom_histogram(binwidth = 0.1) + xlim(55, 70) # This graphs shows a a clear symmetrical distribution of diamond depth 

# It is important to experiment with binning to reveal new patterns within the data. 
# It is possible to change the binwidth, specify the number of bins, or even specify the exact locations of breaks
# Never rely on default parameters to get a revealing view of the distribution. Zooming on the x axis and selecting a smaller binwidth reveals far greater level of detail
# When publishing figures it is important to include information about important parameters (such as binwidth) in the caption 

# To compare the distribution between groups there are a few options:
# Showing small multiple of the histogram, facet_wrap(~ var)
# Use color and a frequency polygon, geom_freqpoly() 
# Use a "conditional density plot" geom_histogram(position = "fill")

ggplot(diamonds, aes(depth)) + geom_histogram(binwidth = 0.1) + facet_wrap(~cut) # Facet wrapped histogram. Facet wrapped around the variable cut

ggplot(diamonds, aes(depth)) + geom_freqpoly(aes(color = cut), binwidth = 0.1, na.rm = TRUE) + xlim(58,68) # Frequency polygon divided into groups by "color"

ggplot(diamonds, aes(depth)) + geom_histogram(aes(fill = cut), binwidth = 0.1, position =  "fill", na.rm = TRUE) + xlim(58,68) # Conditional density plot

# The conditional density plot uses position_fill() to stack each bin, scaling it to the same height
# The plot is perceptually challenging to read, because one must compare bar heights, not positions, but it displays the strongest patterns in the graph

# Both the histogram and frequency polygon geom use the same underlying statistical transformation (stat = "bin")
# This statistic produces two output variables: count and density
# By default, count is mapped to y-position, due to it being more interpretable. 
# The density is the count divided by the total count multiplied by the bin width. it is useful when you want to compare the shape of the distribution, not the overall size

# An alternative to a bin-based visualization is a density estimate
# Geom_density() places a little normal distribution at each data point and sums up all the curves. It has desirable theoretical properties, but is more difficult to relate back to the data
# Only use a density plot when the data is known to be smooth, continuous, and unbounded 


ggplot(diamonds, aes(depth)) + geom_density(na.rm = TRUE) + xlim(58, 68) + theme(legend.position = "none") # Density plot for the general data. It appears smooth, continuous, and unbounded 

ggplot(diamonds, aes(depth, fill = cut, color = cut)) + geom_density(alpha = 0.2, na.rm = TRUE) + xlim(58, 68) # Density plot of the depth of diamonds for each of the cut qualities 

# Note that the area of each density estimate is standardized to one so information is lost about the relative size of each group 

# The histogram, frequency polygon, and density plot all display a detailed view of the distribution.
# However, sometimes it may be useful to compare many distributions and it's useful to have alternative options that sacrifice quality for quantity. Here are three options:

# 1. goem_boxplot(): The box and whisker plot shows five summary statistics along with individual outliers. It displays far less information than a histogram but takes up much less space
# A boxplot can be used with both continuous and discrete x values. For continuous x values, use the group aesthetic to define how the x variable is broken up into bins
# A useful helper function to cut up the continuous x variable is cut_width()

ggplot(diamonds, aes(clarity, depth)) + geom_boxplot() # A regular boxplot that shows the summary of the depth for different groups of diamonds based on clarity 

ggplot(diamonds, aes(carat, depth)) + geom_boxplot(aes(group = cut_width(carat, 0.1))) + xlim(NA, 2.05) # This boxplot shows the statistical summary of the depth of diamonds based on carats. The carat length is divided into 0.1 groupings. Not all data is included since the x axis was limited

# 2. geom_violin(): The violin plot is a compact version of the density plot. The underlying computation is the same but the results are displayed in a similar fashion to the boxplot 

ggplot(diamonds, aes(clarity, depth)) + geom_violin() # A violin plot. Note that there are exactly 8 violins just like they were exactly 8 box plots on the previous graph 

ggplot(diamonds, aes(carat, depth)) + geom_violin(aes(group = cut_width(carat, 0.1))) + xlim(NA, 2.05) # Violin plot of the the depth of carats based on a subset of carat values divided into 0.1 groups

# 3. geom_dotplot(): Draws one point for each observation, carefully adjusted in space to avoid overlaps and shows the distribution it is useful for smaller datasets

###############################################################################################################################################################################################
# 3.11.1  Exercises
###############################################################################################################################################################################################
# 1. What binwidth tells you the most interesting story about the distribution of carat?

ggplot(diamonds, aes(carat)) + geom_histogram() # It appears that large majority of carats fall under the 1.5 carats with a vast majority of diamonds being 0.5 carats
ggplot(diamonds, aes(carat)) + geom_histogram(binwidth = .01) # A majority of diamonds usually fall under a specific carat number. There are several large peaks at approximately 0.25, 0.5, 0.75, and 1
ggplot(diamonds, aes(carat)) + geom_histogram(binwidth = .1)

# Comparing the plots above it is shown that diamonds are usually under 1 carat but under that group there are several large peaks of how many carats a diamonds is worth

# 2. Draw a histogram of price. What interesting patterns do you see?

ggplot(diamonds, aes(price)) + geom_histogram() # Based on the histogram the vast majority of diamonds are worth less than 5000 dollars
ggplot(diamonds, aes(price)) + geom_histogram(binwidth = 100) # Similar conclusion to the graph above
ggplot(diamonds, aes(price)) + geom_histogram(binwidth = 1000) # Similar conclusion
ggplot(diamonds, aes(price)) + geom_histogram(binwidth = 5000) # Even stronger conclusion of the previous theory

# 3. How does the distributions of price vary with clarity

ggplot(diamonds, aes(price, group = clarity, color = clarity)) + geom_freqpoly() # A bit hard to read on the default graph
ggplot(diamonds, aes(price, group = clarity, color = clarity)) + geom_freqpoly(binwidth = 1000, size = 1)
ggplot(diamonds, aes(price, group = clarity, color = clarity)) + geom_freqpoly(binwidth = 2500, size = 1)
ggplot(diamonds, aes(price, group = clarity, color = clarity)) + geom_freqpoly(binwidth = 5000, size = 1)

# It appears that at lower prices there are a higher distribution of lower quality diamonds. At 5000+, lower clarity diamonds are still the largest group there but at much smaller proportion compared to at lower prices. Higher clarity diamonds are more rare at increasing prices

# 4. Overlay a frequency polygon and density plot of depth. What computed variable do you need to map to y to make the two plots comparable? (You can either modify geom freqpoly() or geom density().)

ggplot(diamonds, aes(depth, group = cut, fill = cut)) + geom_freqpoly(binwidth = 1) + geom_density(aes(group = cut))
ggplot(diamonds, aes(depth)) + geom_density()
ggplot(diamonds, aes(depth)) + geom_freqpoly()

###############################################################################################################################################################################################
# 3.12  Dealing with Overplotting
###############################################################################################################################################################################################
# The scatterplot is a very important tool for assessing the relationship between two continuous variables
# However, when the data is large, point will be often plotted on top of each other obscuring the true relationship
# In extreme cases, only the extent of the data will be displayed, and any conclusions drawn from the graphic will be suspect. This is the problem of overplotting
# There are a number of ways to deal with it depending on the size of the data and the severity of the overplotting
# The first set of techniques involves tweaking aesthetic properties:
# Very small amounts of overplotting can sometimes be alleviated by making points smaller or using hollow glpyhs

df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x, y)) + xlab(NULL) + ylab(NULL)
norm + geom_point() # Regular scatter point graph
norm + geom_point(shape = 1) # Scatterplot graph where the points are replaced with hollow circles
norm + geom_point(shape = ".") # Scatterplot graph where the points are replaced with a period 
norm + geom_point(shape = "X") # Scatterplot graph where the points are replaced with an X

# For larger datasets with more overplotting, use alpha blending (transparency) to make the points transparent. 
# Specifying alpha as a ratio, the denominator gives the number of points that must be over plotted to give a solid color. Values smaller than ~1/500 are rounded down to zero, giving completely transparent points

norm + geom_point(alpha = 1/3)
norm + geom_point(alpha = 1/5)
norm + geom_point(alpha = 1/10)

# If there is some discreteness in the data, using geom_jitter() will randomly jitter the points to alleviate some overlaps with geom_jitter()
# This is particularly useful in conjunction with transparency. By default, the amount of jitter added is 40% of the resolution of the data, which leaves a small gap between adjacent regions. This can be changed with the default width and height arguments 

norm + geom_jitter()

# Alternatively overplotting can be thought of as a 2d density estimation problem, which gives rise to two more approaches:
# Bin the points and count the number in each bin, then visualize that count with geom_bin2d(). Breaking the plot into many small squares can produce distracting visual artifacts 
# It is recommended to use hexagons instead using geom_hex() in the hexbin package

norm + geom_bin2d() 
norm + geom_bin2d(bins = 10) 
norm + geom_hex()
norm + geom_hex(bins = 10)

# Estimate the 2d density with stat_density2d(), and then display using one of the techniques for showing 3d surfaces
# Another approach to dealing with overplotting is to add data summaries to help guide the true shape of the pattern within the data
# For example, adding a smooth line showing the center of the data with geom_smooth() or using a statistical summary 

###############################################################################################################################################################################################
# 3.13  Statistical Summaries
###############################################################################################################################################################################################
# geom_histogram() and geom_bin2d use a familiar geom, geom_bar() and geom_raster(), combined with a new statistical transformation, stat_bin() and stat_bin2d(). stat_bin() and stat_bin2d() combine the data into bins and count the number of observations in each bin
# Use stat_summary_bin() and stat_summary_2d() to compute different statistical summaries and override the default geoms

ggplot(diamonds, aes(color)) + geom_bar() # Default bar graph that counts the number of observations for each color
ggplot(diamonds, aes(color, price)) + geom_bar(stat = "summary_bin", fun = "mean") # Bar graph that shows the average price for each color of diamond

ggplot(diamonds, aes(table, depth)) + geom_bin2d(binwidth = 1, na.rm = TRUE) + xlim(50,70) + ylim(50,70)
ggplot(diamonds, aes(table, depth, z = price)) + geom_raster(binwidth = 1, stat = "summary_2d", fun = mean,  na.rm = TRUE) + xlim(50,70) + ylim(50,70)

# stat_summary_bin() can control the size of the bins and the summary functions. It can produce y, ymin and y max aesthetics also making it useful for displaying measures of spread
# The summary functions are quite constrained but are often useful for a quick first pass at a problem. For less restraining in summaries, the data will have to be summarized beforehand

###############################################################################################################################################################################################
# 3.14 Add-on Packages
###############################################################################################################################################################################################

# "animInt" allows for the creation of interactive ggplot2 graphics, adding querying, filtering and linking
# "GGally" provides a very flexible scatterplot matrix, amongst other tools
# "ggbio" provides a number of specialized geoms for genomic data
# "ggdendro" turns data from tree methods in to data frames that can easily be displayed with ggplot2
# "ggfortify" provides fortify and autoplot methods to handle objects from some popular R packages
# "ggenealogy" helps explore and visualize genealogy data
# "ggmcmc" provides a set of flexible tools for visualizing the samples generated by MCMC methods
# "ggparallel"easily draws parallel coordinates plots, and the closely related hammock and common angle plots
# "ggtern" allows for the use of ggplot2 to draw ternary diagrams
# "ggtree" provides tools to view and annotate phylogenetic tree with different types of meta-data
# "granovaGG" provides tools to visualize ANOVA results
# "plotluck" automatically creates plots for one, two, or three variables

###############################################################################################################################################################################################
# End of Chapter 3
###############################################################################################################################################################################################








