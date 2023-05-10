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

# While data manipulation can occur in aes(), such as aes(log(carat)), log(price), it's best to only do simple calculations.
# It's better to move complex transformations outside of the aes() and into explicit dplyr::mutate() call. This is easier to check the work and often faster in drawing the plot since the transformation is already done and not every time the plot is drawn.

# Never refer to a variable with $ (diamonds$carat) in aes(). 
# This breaks containment, so that the plot no longer contains everything it needs, and causes problem if ggplot changes the order of the rows, as it does during faceting.  

###############################################################################################################################################################################################
# 5.4.1 Specifying the Aesthetics in the Plot vs. in the Layers
###############################################################################################################################################################################################
# Aesthetic mappings can be supplied in the initial ggplot() call, in individual layers, or in some combination of both. All of these calls create the same plot specification

ggplot(mpg, aes(displ, hwy, color = class)) + geom_point()
ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = class))
ggplot(mpg, aes(displ)) + geom_point(aes(y = hwy, color = class))
ggplot(mpg) + geom_point(aes(displ, hwy, color = class))

# Within each layer, mappings can be added, overrided, or removed

tibble(Operation = c("Add", "Override", "Remove"), `Layer Aesthetics` = c("aes(color = cyl)", "aes(y = disp)", "aes(y = NULL)"), Result = c("aes(mpg, wt, color = cyl)", "aes(mpg, disp)", "aes(mpg)" ))

# If there is only one layer in the plot, the way the aesthetics are specified won't make any difference. However, it does become important when multiple layers are added to the plot. 

# The following plots are both valid and interesting, but focus on quite different aspects of the data
ggplot(mpg, aes(displ, hwy, color = class)) + geom_point() + geom_smooth(method = "lm", se = FALSE) + theme(legend.position = "none")

ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = class)) + geom_smooth(method = "lm", se = FALSE) + theme(legend.position = "none")


###############################################################################################################################################################################################
# 5.4.2 Setting vs. Mapping
###############################################################################################################################################################################################
# Instead of mapping an aesthetic property to a variable, it can be set to a single value by specifying it within the layer parameters.
# An aesthetic can be **mapped** to a variable (ex. aes(color = cut)) or **set** to a constant (ex. color = "red").
# To set the appearance to be governed by a variable, put the specification inside aes(), to override the default size or color, put the value outside of aes()

# The following plots are created with similar code, but have rather different outputs. 
# The second plot **maps** (not sets) the color to the value "navy". This effectively creates a new variable only containing the value "navy" and then scales it with a color scale.
# Since the value is discrete the default color scale uses evenly spaced color on the color wheel, and since there is only one value the color is pinkish

ggplot(mpg, aes(cty, hwy)) + geom_point(color = "navy")  # Navy points on the plot
ggplot(mpg, aes(cty, hwy)) + geom_point(aes(color = "navy")) # Creates a discrete variable called navy and then defaults to using the original color scale to give it a pink color on the plot

# A third approach is to map the value, but override the default scale:

ggplot(mpg, aes(cty, hwy)) + geom_point(aes(color = "darkblue")) + scale_color_identity()

# This is useful if the dataset already contains a column that has colors.

# It's sometimes useful to map aesthetics to constants. For example, to display multiple layers with varying parameters, each layer can be named:

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() +
  geom_smooth(aes(color = "loess"), method = "loess", se = FALSE) +
  geom_smooth(aes(color = "lm"), method = "lm", se = FALSE) +
  labs(color = "Method")

###############################################################################################################################################################################################
# 5.4.3 Exercises
###############################################################################################################################################################################################
# 1. Simplify the following plot specifications: 

# a. ggplot(mpg) + geom_point(aes(mpg$disp, mpg$hwy))

ggplot(mpg) + geom_point(aes(displ, hwy))

# b. ggplot() + geom_point(mapping = aes(y = hwy, x = cty), data = mpg) + geom_smooth(data = mpg, mapping = aes(cty, hwy))

ggplot(mpg, aes(cty, hwy)) + geom_point() + geom_smooth()

# c. ggplot(diamonds, aes(carat, price)) + geom_point(aes(log(brainwt), log(bodywt)), data = msleep)

ggplot(aes(log(brainwt), log(bodywt)), data = msleep) + geom_point() # The previous plot used a dataset that wasn't even plotted and was unnecessary to the plot

# 2. What does the following code do? Does it work? Does it make sense? Why/why not?

ggplot(mpg) + geom_point(aes(class, cty)) + geom_boxplot(aes(trans, hwy))

# The following code creates a plot that has both boxplot data based on hwy driving of the car and point data showing the city driving ability of various classes of the car
# The data does work as it executes and graphs the points correctly
# However, the graph doesn't make sense. First, the plot is scaled to classes and cty driving therefore anyone reading the plot without knowing the code will assume that the transmission types are a class of car.
# Additionally, even though both cty and hwy share the same scale the plot conveys that the boxplots are showing cty driving efficiency even though it is using hwy values thus making the graph more confusing and inaccurate

# 3. What happens if you try to use a continuous variable on the x axis in one layer, and a categorical variable in another layer? What happens if you do it in the opposite order?

ggplot(mpg) + geom_point(aes(hwy, cyl)) + geom_point(aes(drv, cty)) 

# Could cannot run because a discrete variable is being applied to a continuous scale

ggplot(mpg) + geom_point(aes(drv, cty)) + geom_point(aes(hwy, cyl))

# The plots are a mix of two different graphs together and it is formatted weirdly. 

###############################################################################################################################################################################################
# 5.5 Geoms
###############################################################################################################################################################################################
# Geometric objects or **geom** for short, perform the actual rendering of the layer, controlling the type of plot created

#Types of geoms:
  
# Graphical primitives

#   geom_blank() # Displays nothing. Most useful for adjusting axes limits using data
#   geom_point() # Points
#   geom_path() # Paths
#   geom_ribbon() # Ribbons, a path with vertical thickness
#   geom_segment() # A line segment, specified by start and end position
#   geom_react() # Rectangles
#   geom_polygon() # Filled polygons
#   geom_text() # Text

#   One variable:
  
  #   Discrete

#   geom_bar() # Displays distribution of discrete variable

#   Continuous

#   geom_histogram() # Bin and count continuous variables, display with bars
#   geom_density() # Smoothed density estimate
#   geom_dotplot() # Stack individual points into a dot plot
#   geom_freqpoly() # Bin and count continuous variable, display with lines

#   Two variables:
  
  #   Both continuous:
  
  #   geom_point() # Scatterplot
#   geom_quantile() # Smoothed quantile regression
#   geom_rug() # Marginal rug plots
#   geom_smooth() # Smoothed line of best fit
#   geom_text() # Text labels

#   Show distribution:
  
  #   geom_bin2d() # Bin into rectangles and count
#   geom_density2d() # Smoothed 2d density estimate
#   geom_hex() # Bin into hexagons and count

#   At least one discrete:
  
  #   geom_count() # Count number of point at distinct locations
#   geom_jitter() # Randomly jitter overlapping points

#   One continuous, one discrete:
  
  #   geom_bar(stat = "identity") # A bar chart of precomputed summaries
#   geom_boxplots() # Boxplots
#   geom_violin() # Show density of values in each group

#   Display uncertainty

#   geom_crossbar() # Vertical bar with center
#   geom_errorbar() # Error bars
#   geom_linerange() # Vertical line
#   geom_pointrange() # Vertical line with center

#   Spatial

#   geom_map() # Fast version of geom_polygon() for map data

#   Three variables

#   geom_contour() # Contours
#   geom_tile() # Tile the plane with rectangles
#   geom_raster() # Fast version of geom_tile() for equal sized tiles

# Each geom has a set of aesthetics that it understands, so of which must be provided. For example point geoms require x and y position and understand color, size, and shape aesthetics. A bar requires height (ymax), and understands width, border color, and fill color.

# Some geoms differ primarily in the way that they are parameterised. For example, a square can be drawn in three ways:
# 1.  By giving geom_tile() the location (x and y) and dimensions (width and height)
# 2.  By giving geom_rect() top (ymax), bottom (ymin), left (xmin) and right (xmax)
# 3.  By giving geom_polygon() a four row data frame with the x and y positions of each corner

# Other related geoms are:
# geom_segment() and geom_line()
# geom_area() and geom_ribbon()
###############################################################################################################################################################################################
# 5.5.1 Exercises
###############################################################################################################################################################################################





