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
library(mgcv)

###############################################################################################################################################################################################
# Chapter 2: Getting Started with ggplot2
###############################################################################################################################################################################################
# 2.2 Fuel Economy Data
###############################################################################################################################################################################################
# The ggplot includes information about the fuel economy of popular car models collected by the US EPA. The dataset is called mpg

mpg

# These are the following variables:
# cty and hwy record miles per gallon (mpg) for city and highway driving
# displ is the engine displacement in litres
# drv is the dravetrain: front wheel (f), rear wheel (r), or four wheel (4)
# model is the model of car. There are 38 models, selected because there was a new edition every year between 1999 and 2008
# class is a categorical variable describing the "type" of car (two seater, SUV, compact, etc)

###############################################################################################################################################################################################
# 2.2.1 Exercises
###############################################################################################################################################################################################
# 1. List five functions that you could use to get more information about the mpg dataset.

# unique() can be used to determine the different amount of variables there are for various categorical variable giving insight into the different ways data can be organized

unique(mpg$model) #There are 38 models of cars
unique(mpg$manufacturer) # There are 15 manufacturers
unique(mpg$drv) # There are 3 types of drivetrains

# Summary() can provide a basic summary about the spread of data with min, maxs, and the different interquartile ranges.  

summary(mpg$cty)
summary(mpg$hwy)
summary(mpg$displ)

# View() can be used to look at the entire dataset

view(mpg)

# typeof() can be used to determine the class of the variables 

typeof(mpg$cty) # int
typeof(mpg$manufacturer) # character

# is.na() can be used to determine if there are any NA values within the dataset

is.na(mpg$manufacturer)

# 2. How can you find out what other data sets are included with ggplot2?

?ggplot2

# 3. Apart from the US, most countries use fuel consumption (fuel consumed over fixed distance) rather than fuel economy (distance traveled with fixed amount of fuel). How could you convert cty and hwy into the European standard of l/100 km?

mpg %>% mutate(cty = 235.215/cty, hwy = 235.215/hwy)

# 4. Which manufacturer has the most the models in this dataset? Which model has the most variations? Does your answer change if you remove the redundant specification of drive train (e.g. “pathfinder 4wd”, “a4 quattro”) from the model name?

mpg %>% group_by(manufacturer, model, drv, class) %>% summarize(Count = n()) %>% arrange(desc(Count))

# The most common model of the is the dodge caravan 2wd minivan

mpg %>% group_by(manufacturer, model) %>% summarize(Count = n()) %>% arrange(desc(Count))

# Even without the additional specifications, the dodge caravan 2wd is the most common vehicle within the dataset

###############################################################################################################################################################################################
# 2.3 Key Components
###############################################################################################################################################################################################
# Every ggplot2 plot has three key components:
# 1. data
# 2. A set of aesthetic mappings between variables in the data and visual properties
# 3. At least one layer which describes how to render each observation. Layers are usually created with a geom function

ggplot(mpg, aes(x = displ, y = hwy)) + geom_point()

# The line above produces a scatterplot defined by:
# Data : mpg
# Aesthetic mapping: Engine size mapped to x position, fuel economy to y position
# Layer: points
# In the function call data and aesthetic mappings are supplied in ggplot() and layers are added on with +

# Almost every ggplot maps a variable to x and y, thus naming these aesthetics is tedious, so the first two unnamed arguments to aes() will be mapped to x and y. The following code is identical to the previous code

ggplot(mpg, aes(displ, hwy)) + geom_point()

# The plot shows a strong correlation: as the engine size gets bigger, the fuel economy gets worse. 

###############################################################################################################################################################################################
# 2.3.1 Exercises
###############################################################################################################################################################################################
# 1. How would you describe the relationship between cty and hwy? Do you have any concerns about drawing conclusions from that plot?

ggplot(mpg, aes(cty, hwy)) + geom_point()

# The relationship between cty and hwy driving shows a strong linear correlation
# However, this is expected because the numeric variables are plotted without a relationship, they are plotted only by numeric value
# There for we should see a strong relationship because the variables would be plotted next to one another without a relationship

# 2. What does ggplot(mpg, aes(model, manufacturer)) + geom point() show? Is it useful? How could you modify the data to make it more informative?

ggplot(mpg, aes(model, manufacturer)) + geom_point()

# The plot shows a scatter plot of manufacturers and models. Every dot on the graph indicates which model is created by a manufacturer
# The data could be useful to find which manufacturer produces what type of model, however each row or column is specific to one model and manufacturer and the information could be found in more elegant ways
# A better way to display the data would be plotting the number of models per manufacturer 

mpg %>% group_by(model, manufacturer) %>% summarize(Count = n()) %>% ggplot(aes(manufacturer, Count)) + geom_col()

# 3. Describe the data, aesthetic mappings and layers used for each of the following plots.

ggplot(mpg, aes(cty, hwy)) + geom_point()
# Data: mpg
# Aesthetic: x = cty, y = hwy
# Layer: points

ggplot(diamonds, aes(carat, price)) + geom_point()
# Data: diamonds
# Aesthetic: x = carat, y = price
# Layer: points

ggplot(economics, aes(date, unemploy)) + geom_line()
# Data: economics
# Aesthetic: x = date, y = umemploy
# Layer: line

ggplot(mpg, aes(cty)) + geom_histogram()
# Data: mpg
# Aesthetic: x = cty
# Layer: histogram

###############################################################################################################################################################################################
# 2.4 Color, Size, Shape, and Other Aesthetic Attributes
###############################################################################################################################################################################################
# To add additional variables to a plot, aesthetics like color, shape, and size can be used. These work in the same way as the x and y aesthetics and are added into the call to aes()

ggplot(mpg, aes(displ, hwy, color = class)) + geom_point() # Scatterplot where the points receive a different color based on which class of class they fall under

ggplot(mpg, aes(displ, hwy, shape = drv)) + geom_point() # Scatterplot where the points receive a different shape based on which class of drv they fall under

ggplot(mpg, aes(displ, hwy, size = cyl)) + geom_point() # Scatterplot where the points are different sizes depending on which class of cyl they fall under

# ggplot takes care of the details of converting data ("f", "r", "4") into aesthetics ("red","yellow","green") with a scale
# There is one scale for each aesthetic mapping in a plot. The scale is also responsible for creating a guide, an axis or legend that allows for the plot to be read, converting aesthetic values back into data values

ggplot(mpg, aes(displ, cty, color = class)) + geom_point()

# The line above gives each point a unique color corresponding to its class. 
# The legend allows for anyone to read data values from the color showing the group of which cars with unusually high fuel economy for their engine size are two seaters: cars with big engines but lightweight bodies

# To set an aesthetic to a fixed value, without scaling it, do so in the individual layer outside of aes()

ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = "blue")) # The scatterplot is not actually blue and a legend is added
ggplot(mpg, aes(displ, hwy)) + geom_point(color = "blue") # The scatterplot points are blue

# In the first plot, the value "blue" is scaled to a pinkish color and a legend is created
# In the second plot, the points are given the R color blue
# Use vignette("ggplot2-specs") for the values needed for color and other aesthetics 

vignette("ggplot2-specs")

# Different types of aesthetic attributes work better with different types of variables. For example, color and shape work well with categorical variables while size works for continuous variables
# An additional factor to consider is the amount of data. If there is a lot of data it can be hard to distinguish different groups. An alternative solution is faceting 
# When using aesthetics in a plot, less is usually more. it's difficult to see simultaneous relationships among color and shape and size
# The key is trying to make a complex plot that shows everything at once and to see if a series of simple plots can tell a story, leading the reader from ignorance to knowledge

###############################################################################################################################################################################################
# 2.4.1 Exercises
###############################################################################################################################################################################################
# 1. Experiment with the color, shape and size aesthetics. What happens when you map them to continuous values? What about categorical values? What happens when you use more than one aesthetic in a plot?

ggplot(economics, aes(date, unemploy)) + geom_line(color = "red") # Changes the color of the line geom to red
ggplot(mpg, aes(displ, hwy, color = class)) + geom_point()
ggplot(mpg, aes(displ, hwy, color = class, size = class)) + geom_point() # Applying multiple aesthetics to one variable applies both aesthetics to each variable
ggplot(mpg, aes(displ, hwy, color = class, size = drv)) + geom_point() # Applying multiple aesthetics to two different variables will add aesthetics according to the class of each of the variables

# 2. What happens if you map a continuous variable to shape? Why? What happens if you map trans to shape? Why?

ggplot(economics, aes(date, unemploy, size = unemploy)) + geom_line() 
ggplot(mpg, aes(displ, hwy, size = hwy)) + geom_point() # Applying size to a continuous variable will divide the variable into groups and apply a size to each of the different points
ggplot(mpg, aes(x = trans, y = hwy, shape = trans)) # Applying a shape aesthetic to shape will not work, because the aesthetic can only deal with a maximum of six discrete values because having more than 6 becomes difficult to discriminate

# 3.  How is drive train related to fuel economy? How is drive train related to engine size and class?

ggplot(mpg, aes(x = cty, y = drv, color = drv)) + geom_point() # It appears that forward drive has better fuel economy for city driving while 4 wheel and rear driving has roughly equivalent fuel economy with 4 wheel have slightly better fuel economy
ggplot(mpg, aes(x = displ, y = cty, color = class, size = drv)) + geom_point()  # Front drive cars have better fuel economy and tend to have smaller engines and are typically subcompacts and compact classes of cars

###############################################################################################################################################################################################
# 2.5 Faceting 
###############################################################################################################################################################################################
# Another technique for displaying additional categorical variables on a plot is faceting. 
# Faceting creates tables of graphics by splitting the data into subsets and displaying the same graph for each subset
# There are two types of faceting: grid and wrapped
# To facet a plot simply add a faceting specification with facet_wrap() which takes the name of a variable preceded by ~

ggplot(mpg, aes(x = displ, hwy)) + geom_point() + facet_wrap(~class)

###############################################################################################################################################################################################
# 2.5.1 Exercises
###############################################################################################################################################################################################
# 1. What happens if you try to facet by a continuous variable like hwy? What about cyl? What’s the key difference?

length(unique(mpg$hwy)) # There are 27 unique values for hwy
ggplot(mpg, aes(displ, cty)) + geom_point() + facet_wrap(~hwy) # Facet wrap works for continuous values but creates 27 different graphs. Basically facet wrapping a continuous variable will facet value for every value making it unreliable for very large data sets 

ggplot(mpg, aes(displ, cty)) + geom_point() + facet_wrap(~cyl) # Facet wrapping around the cyl variable creates four different graphs. This is because cyl only has four different unique values and is a lot easier to read compared to facet wrapping around hwy

# 2. Use faceting to explore the three-way relationship between fuel economy, engine size, and number of cylinders. How does faceting by number of cylinders change your assessment of the relationship between engine size and fuel economy?

ggplot(mpg, aes(displ, hwy)) + geom_point() + facet_wrap(~cyl)

# There appears to be a relationship between engine size and the number of cylinders. The larger the engine the more the higher the probability of having more cylinders
# Additional there is also a relationship between the engine size between and hwy fuel economy, with smaller engines having better fuel economy
# We can see that cars that have smaller engines and less cylinders tend to have better fuel economy 

# 3.  Read the documentation for facet wrap(). What arguments can you use to control how many rows and columns appear in the output?

?facet_wrap()

# nrow and ncol can be used to control how many rows and columns appear in the facet wrap

# 4. What does the scales argument to facet wrap() do? When might you use it?

?facet_wrap()

ggplot(mpg, aes(displ, hwy)) + geom_point() + facet_wrap(~cyl)
ggplot(mpg, aes(displ, hwy)) + geom_point() + facet_wrap(~cyl, scales = "free")

# The scales argument is "fixed" by default, be can be adjusted to "free" which removes the default scale that all facet wraps have
# When giving the argument "free" each facet wrap receives it's own scale that fits with the subset of the data
# The scales argument can be useful when the different subsets of the data have a wide range of values allowing for better clarity 

###############################################################################################################################################################################################
# 2.6 Plot Geoms
###############################################################################################################################################################################################
# There are a multitude of different geoms:
# Geom_smooth() fits a smoother to the data and displays the smooth and its standard error
# Geom_boxplot() produces a box and whisker plot to summarise the distribution of a set of points
# Geom_histogram() and geom_freqpoly() show the distribution of continuous variables
# Geom_bar() shows the distribution of categorical variables
# geom_path() and geom_line() draws lines between the data points. A line plot is constrained to produce lines that travel from left to right, while paths can go in any direction. Lines are typically used to explore how things change over time

###############################################################################################################################################################################################
# 2.6.1 Adding a Smoother to a Plot
###############################################################################################################################################################################################
# For scatter plots with a lot of noise it can be hard to determine the dominant pattern. It is useful to add a smoothed line to the plot with geom_smooth()

ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_smooth()

# This line overlays the scatterplot with a smooth curve, including an assessment of uncertainty in the form of point-wise confidence intervals shown in grey. 
# The confidence interval can be turned off with geom_smooth(se = FALSE)
# Another important argument for geom_smooth() is the method, which chooses which type of model is used to fit the smooth curve
# method = "loess", is the default fro a small n, it uses a smooth local regression. The wiggliness of the line is controlled by the span parameter, which ranges from 0 (excessive) to 1 (minimum)

ggplot(mpg, aes(displ, hwy)) +  geom_point() + geom_smooth(span = 0.2) # The line is much more erratic with a low span
ggplot(mpg, aes(displ, hwy)) +  geom_point() + geom_smooth(span = 1) # Smoother line with a larger span

# Loess does not work well for large datasets, so an alternative smoothing algorithm is used when n is greater than 1000
# method = "gam" fits a generalized additive model provided by the mgcv package. A formula like y ~ s(x) or y ~ s(x,bs = "cs") are used

ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_smooth(method = "gam", formula = y ~ s(x)) 

# Method = "lm" fits a linear model, giving the line of best fit:

ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_smooth(method = "lm")

# Method= "rlm" works with lm(), but uses a robust fitting algorithm so that outliers don't affect the fit as much. It is part of the MASS package

###############################################################################################################################################################################################
# 2.6.2 Boxplots and Jittered Points
###############################################################################################################################################################################################
# When a set of data contains a cateogorical variable and one ore more continuous variables, it is most likely there will be interest in knowing how the values of the continuous variables vary with the levels of the categorical variables

ggplot(mpg, aes(drv, hwy)) + geom_point()

# The data above has few unique values of both class and hwy leading to a lot of overlap on the plot, due to many points being plotted in the same location, making it harder to udnerstand the distrubtion
# There are three useful techniques to help alleviate the problem:
# 1. Jittering, geom_jitter(), adds a little random noise to the data which cna help avoid overplotting

ggplot(mpg, aes(drv, hwy)) + geom_jitter()

# 2. Boxplots, geom_boxplots, summarise the shape of the distribution with a handful of summary statistics

ggplot(mpg, aes(drv, hwy)) + geom_boxplot()

# 3. Violin plots, geom_violin(), show a compact representation of the "density" of the distribution. highlighting the areas where more points are found 

ggplot(mpg, aes(drv, hwy)) + geom_violin()

# Each of the methods has its strengths and weaknesses. 
# Boxplot summarise the bulk of the distribution with only five numbers
# Jittered plots show every point but only work with relatively small datasets
# Violoin plots give the richest display, but rely on the calculation of a density estimate, which can be hard to interpret

# For jittered points, geom_jitter() offers the same control over aesthetics as geom_point(): size, color, and shape
# For geom_boxplot() and geom_violin() the outline color and internetal color fill can be chosen

###############################################################################################################################################################################################
# 2.6.3 Histograms and Frequency Polygons
###############################################################################################################################################################################################
# Histograms and Frequency Polygons show the distribution of a single numeric variable. They provide more information about the distribution of a single group than boxplots, at the expense of needing more space

ggplot(mpg, aes(hwy)) + geom_histogram()

ggplot(mpg, aes(hwy)) + geom_freqpoly()

# Both histograms and frequency polygons work in the same way: they bin the data, and count the number of observations in each bin. The only difference between the two is the display. Histrograms use bars while frequency plots use lines
# The width of the bins can be controlled with the binwidth argument (to avoid evenly spaced bins use the breaks argument)
# It is important to experiment with the bin width. The default just splits the data into 30 bins, which is unlikely to be the best option of representations

ggplot()


