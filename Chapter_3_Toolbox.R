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
# 3.1 Introductio
###############################################################################################################################################################################################
# The layered structure of ggplot2 encourages an individual to design and construct graphics in a structured manner 
# There are three purposes for a layer:
# 1. Ti display the data. When plotting raw data, skills at pattern detection are used to spot gross structure, local structure, and outliers. This layer appears on virtually every graphic
# 2. To display a statistical summary of the data. It is useful to display model predictions in the context of data. Showing the data helps imporve the model and showing the model helps reveal subtleties of the data that may be missed. Summaries are usually drawn on top of data
# 3. To add additional metadata: context, annotations, and references. A metadata layer displays background context, annotations that help to give meaning to raw data or fixed references that aid comparisons across panels
# Metadata can be useful in the background and foreground. A map is often used as a background later with spatial data.
# Background metadata is rendered so it doesn't interfere with the preception of the data, so it is usally underneath the data and formamtted so it's minimlally perceptible. That is if focused on, it can be spotted with ease, but otherwise it blends into the background of the plot
# Metadata can also be used to highlight important features of the data. Such as Explanatory labels to couple inflection points or outliers that they are rendered clearly to the viwer













