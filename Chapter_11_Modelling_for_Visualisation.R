library(tidyverse)

###############################################################################################################################################################################################
# Chapter 11: Modelling for Visualization
###############################################################################################################################################################################################
# 11.1 Introduction
###############################################################################################################################################################################################
# Modelling is an essential tool for visualization. There are two strong connections between modelling and visualization:
# Using models as a tool to remove obvious patterns in plots. This is useful because strong patterns mask subtler effects. Often the strongest effects are already known and expected, and removing them allows for the observation of smaller effects
# Often times there is too much data to show on plots. Models can be a powerful tool for summarizing data to provide a higher level view

###############################################################################################################################################################################################
# 11.2 Removing Trend
###############################################################################################################################################################################################
# The analysis of the diamonds data has been plagued by the powerful relationship between size and price. It makes it very difficult to see the impact of cut, color and clarity because higher quality diamonds tend to be smaller, and hence cheaper
# This challenge is often called confounding. A linear model can be used to remove the effect of size on price
# Instead of looking at the raw price, observations can be made about the relative price: how valuable a diamond is relative to the average diamond of the same size
# To start, the data will focus on diamonds of size two carats or less (96% of the data set) to avoid incidental problems. 
# Two variables will be created log price and log carat. These variables are useful because they produce a plot with a strong linear trend

diamonds2 <- diamonds %>% filter(carat <= 2) %>% mutate(lcarat = log2(carat), lprice = log2(price))
diamonds2
ggplot(diamonds2, aes(lcarat, lprice)) + geom_bin2d() + geom_smooth(method = "lm", se = FALSE, size = 2, color = "yellow")
 
# In the graphic, geom_smooth() was used to overlay the line of best fit to the data. 
# This can be replicated outside of ggplot2 by fitting a linear model with lm(). Allowing access to the slope and intercept of the line

mod <- lm(lprice ~ lcarat, data = diamonds2)
coef(summary(mod))

# Summary: log2(price) = 12.2 + (1.7)*log2(carat) , which implies price = 4900 * carat^1.7
# The model can then be used to subtract the trend away by looking at the residuals; the price of each diamond minus its predicted price, based on weight alone
# Geometrically, the residuals are the vertical distance between each point and the line of best fit. They provide information about the price relative to the "average diamond of that size

diamonds2 <- diamonds2 %>% mutate(rel_price = resid(mod))
diamonds2
ggplot(diamonds2, aes(carat, rel_price)) + geom_bin2d()

# A relative price of zero means that the diamond was at the average price. A positive value means that it's more expensive than expected, and a negative means that it's cheaper than expected 
# Interpreting the values precisely is a bit tricky because price was log transformed. 
# The residuals give the absolute difference (x - expected) but in this case it is log2(price) - log2(expected price) or equivalently log2(price/expected price), this can be back transformed to the original scale by applying the opposite transformation (2^x) to get (price / expected price) making the values more interpretable at the cst of the nice symmetry property of logged values
# A table can be made to help interpret the values

xgrid <- seq(-2, 1, by = 1/3)
data.frame(logx = xgrid, x = round(2 ^ xgrid, 2))

# The table illustrates why log2() was used rather than log(). A change of 1 unit on the logged scale, corresponds to a doubling on the original scale
# For example, a rel_price of -1 means that it's half of the expected price, while a relative price of 1 means that it's twice the expected price

# Price and relative price can be used to observe how color and cut affect the value of diamond 
# Average price and average relative price will be calculated for each combination of color and cut

color_cut <- diamonds2 %>% group_by(color, cut) %>% summarise(price = mean(price), rel_price = mean(rel_price))
color_cut

# Looking at price, it's hard to observe how the quality of the diamond affects the price. The lowest quality diamonds (fair cut with color J) have the highest average value
# This is due to these diamonds also being larger in size, and size and quality are confounded 

ggplot(color_cut, aes(color, price)) + geom_line(aes(group = cut), color = "grey80") + geom_point(aes(color = cut)) + scale_color_brewer(palette = "Accent")

# However, by plotting the relative price, an expected pattern emerges; as the quality of the diamonds decreases, the relative price decreases. The worst quality diamond is much lower than the price of an "average" diamond

ggplot(color_cut, aes(color, rel_price)) + geom_line(aes(group = cut), color = "black") + geom_point(aes(color = cut)) # Higher quality diamonds tend to be more expensive compared to lower quality diamonds

# This technique can be employed in a wide range of situations. Whenever, explicitly modeling a strong pattern, it's worth to use a model to remove that strong pattern to see which interesing trends remain

###############################################################################################################################################################################################
# 11.2.1 Exercises
###############################################################################################################################################################################################
# 1. What happens if you repeat the above analysis with all diamonds? (Not just all diamonds with two or fewer carats). What does the strange geometry of log(carat) vs relative price represent? What does the diagonal line without any points represent?

diamonds3 <- diamonds %>% mutate(lprice = log2(price), lcarat = log2(carat))
diamonds3 %>% ggplot(aes(lcarat, lprice)) + geom_bin2d() + geom_smooth(method = "lm", se = FALSE, color = "yellow", size = 2)
cmod <- lm(lprice ~ lcarat, data = diamonds3)
coef(summary(cmod))
diamonds3 <- diamonds3 %>% mutate(relprice = resid(cmod))
diamonds3
diamonds3 %>% ggplot(aes(log2(carat), relprice)) + geom_bin2d() # There is a heavy skew in the residual data when using carat. It appears that the size confounding variables has a disproportionate affect on the price

# 2. I made an unsupported assertion that lower-quality diamonds tend to be larger. Support my claim with a plot.

quality_diamonds <- diamonds3 %>% group_by(color, cut) %>% summarize(relprice = mean(relprice), price = mean(price), size = mean(carat))
quality_diamonds %>% ggplot(aes(size, price, color = cut)) + geom_line(size = 2)

###############################################################################################################################################################################################
# 11.3 Texas Housing Data
###############################################################################################################################################################################################
# The following modeling will explore the connection between modelling and visualization with the txhousing dataset

txhousing

# The data contains information about 46 Texas cities, recording the number of house sales (sales), total volume of sales (volume), the average and median sale prices, the number of houses listed for sale (listings), and the number of months inventory (inventory)
# This section is going to explore how sales have varied over time for each city as it shows some interesting trends and poses interesting challenges
# Start with an overview, ea time series of sales for each city

txhousing %>% ggplot(aes(date, sales)) + geom_line(aes(group = city), alpha = 0.5) # A very hard to read plot

# There are two factors that make it hard to see the long-term trend in this plot:
# 1. The range of sales varies over multiple orders of magnitude. The biggest city, Houston, averages over ~4000 sales per month, while the smallest city, San marcos only averages ~20 sales per month
# 2. There is a strong seasonal trend: sales are much higher in the summer than in the winter

# The first problem can be fixed by plotting log sales

txhousing %>% ggplot(aes(date, log(sales))) + geom_line(aes(group = city), alpha = 0.5)

# THe second problem can be fixed by using the same technique that was used for removing the trend in the diamonds data: fitting a linear model and looking at the residuals
# This time a categorical predictor will be used to remove the month effect. 
# First, the technique will be checked by applying it to a single city. It's always a good idea to start simple so if something does go wrong, it's easier to pinpoint the problem

abilene <- txhousing %>% filter(city == "Abilene")
ggplot(abilene, aes(date, log(sales))) + geom_line()

mod <- lm(log(sales) ~ factor(month), data = abilene)
abilene$rel_sales <- resid(mod)
ggplot(abilene, aes(date, rel_sales)) + geom_line()

# The same transformation can be applied to every city with the group_by() and mutate() functions
# Note the use of na.action = na.exclude argument to lm(). This ensures that missing values in the input are matched with missing values in the output predictions and residuals
# Without this argument, missing values are just dropped, and the residuals don't line up with the inputs

deseas <- function(x, month) {
  resid(lm(x ~ factor(month), na.action = na.exclude))
}

txhousing <- txhousing %>% group_by(city) %>% mutate(rel_sales = deseas(log(sales), month))

# With the data transformed, it can be re plotted. 
# With the removal of the strong seasonal effects, it can be observed that there is a strong common pattern; a consistent increase from 2000-2007, a drop until 2010, and then a gradual rebound

ggplot(txhousing, aes(date, rel_sales)) + geom_line(aes(group = city), alpha = 1/5) + geom_line(stat = "summary", fun = "mean", color = "red")

# Note that removing the seasonal effect also removed the intercept

###############################################################################################################################################################################################
# 11.3.1 Exercises
###############################################################################################################################################################################################
# 1. The final plot shows a lot of short-term noise in the overall trend. How could you smooth this further to focus on long-term changes?

# Adding a geom_smooth line can help further smooth out the line to help focus on long term changes
ggplot(txhousing, aes(date, rel_sales)) + geom_line(aes(group = city), alpha = 1/5) + geom_line(stat = "summary", fun = "mean", color = "red") + geom_smooth(method = "loess", se = FALSE)

# 2. If you look closely (e.g. + xlim(2008, 2012)) at the long-term trend you’ll notice a weird pattern in 2009–2011. It looks like there was a big dip in 2010. Is this dip “real”? (i.e. can you spot it in the original data)
ggplot(txhousing, aes(date, rel_sales)) + geom_line(aes(group = city), alpha = 1/5) + geom_line(stat = "summary", fun = "mean", color = "red") + geom_smooth(method = "loess", se = FALSE) + xlim(2008,2012)
# It was a moderate dip in 2010

# 3. What other variables in the TX housing data show strong seasonal effects? Does this technique help to remove them?

summary(txhousing)

ggplot(txhousing, aes(date,log(inventory))) +  geom_line(aes(group=city), alpha=1/2)

#Total active listings
ggplot(txhousing, aes(date,log(listings))) + geom_line(aes(group=city), alpha=1/2)

#Total volume of sales
ggplot(txhousing, aes(date,log(volume))) + geom_line(aes(group=city), alpha=1/2)

#Median sale price:
ggplot(txhousing, aes(date,log(median))) + geom_line(aes(group=city), alpha=1/2)

# Total volume of sales seems to have a strong seasonal effect, but this is probably due to the fact correlated with the seasons heavily. Otherwise no 

# 4. Not all the cities in this data set have complete time series. Use your dplyr skills to figure out how much data each city is missing. Display the results with a visualization.

numDates <- txhousing %>% summarize(nDates=n_distinct(date)) %>% select(nDates) %>% max() 
numDates

cityCnts <- txhousing %>% na.omit() %>% group_by(city) %>% summarize(nComplete=n()) %>% mutate(pctComplete=nComplete/numDates)
cityCnts

ggplot(cityCnts, aes(city,pctComplete)) + 
  geom_col() +
  labs(x="City", y="% Complete") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

###############################################################################################################################################################################################
# 11.4 Visualizing Models
###############################################################################################################################################################################################
# The previous examples used the linear model just as a tool for removing trend
# There wasn't much use for the model but they contain useful information and can solve various problems:
# There may be interest in cities where the model doesn't fit particularly well. A poorly fitted model suggests that there isn't much of a seasonal pattern, which would contradict the implicit hypothesis that all cities share a similar pattern
# The coefficients themselves might be interesting, For this case, looking at the coefficients will show how the seasonal pattern varies between cities
# One may be interested in diving into the details of the mode itself to understand what it say for each observation. For this data, it might help find suspicious data points that reflect data entry errors
 
# To take advantage of this data, the models need to be stored. This can be done using the dplyr verb do(). It allows for the storage of the results of arbitrary computations in a column 
# Here's an example of it being used to store a linear model

models <- txhousing %>% group_by(city) %>% do(mod = lm(log2(sales) ~ factor(month), data = ., na.action = na.exclude))
models

# There are two important things to note for this code:
# 1. do() creates a new column called mod. This is a special type of column:
# Instead of containing an atomic vector (logical, integer, numeric, or character) like usual, it's a list. List's are R's most flexible data structures and can hold anything including linear models
# 2. . is a special pronoun used by do(). It refers to the "current" data frame. In this example, do() fits the model 46 times (once for each city), each time replacing . with the data for one city

# It's useful to start of simple for models. Once a model that works for each city individually is created, the next step would be figuring out how to generalise it to fit all cities simultaneously
# To visualize these models, they'll be turned into tidy data frames. This will be done with the broom package

library(broom)

# Broom provides three key verbs, each corresponding to one of the challenges outlined above. 
# 1. glance() extracts model-level summaries with one row of data for each model. It contains summary statistics like the R^2 and degrees of freedom
# 2. tidy() extracts coefficient-level summaries with one row of data for each coefficient in each model. It contains information about individual coefficients like their estimate and standard error
# 3. augment() extracts observation-level summaries with one row of data for each observation in each model. It includes variables like the residual and influence metrics useful for diagnosing outliers 

###############################################################################################################################################################################################
# 11.5 Model-Level Summaries
###############################################################################################################################################################################################
# Model fit for each city can be observed with glance()

model_sum <- txhousing %>% group_by(city) %>% do(mod = lm(log2(sales) ~ factor(month), data = ., na.action = na.exclude)) %>% glance()


model_sum <- txhousing %>% group_by(city) %>% nest() %>% mutate(mod = map(data, ~lm(log2(sales) ~ factor(month), data = ., na.action = na.exclude)), glance = map(mod, broom::glance))

# The rest of the book is updated this will be continued in the other book

###############################################################################################################################################################################################
# End of Chapter 11
###############################################################################################################################################################################################
