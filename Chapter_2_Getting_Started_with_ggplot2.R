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









