library(tidyverse)
library(ggthemes)

###############################################################################################################################################################################################
# Chapter 8: Themes
###############################################################################################################################################################################################
# 8.1 Introduction
###############################################################################################################################################################################################
# The theme system allows for control over the non-data elements of the plot. The theme system does not affect how the data is rendered by geoms, or how it is transformed by scales
# Themes don't change the perceptual properties of the plot, but they do help making the plot aesthetically pleasing or match an existing style guide
# Themes don't change the perceptual properties of the plot, but they do help making the plot aesthetically pleasing or match an existing style guide
# Themes give control over things like fonts, ticks, panel strips, and backgrounds

# The separation of control into data and non-data parts is quite different from base and lattice graphics. 
# In base and lattice graphics, most functions take a large number of arguments that specify both data and non-data appearance, which makes the functions complicated and harder to learn
# ggplot2 takes a different approach: when creating the plot, the individual determines how the data is displayed, then after it has been created every detail of the rendering can be edited

# The theming system is composed of 4 parts:
# 1. Theme elements that specify the non-data elements that can be controlled. For example, plot.title element controls the appearance of the plot title, axis.ticks.x the ticks on the x axis, legend.key.height the height of the keys in the legend
# 2. Each element i associated with an element function, which describes the visual properties for the element. For example, element_text() sets the font size, color, and face of text elements like plot.title
# 3. Theme() function controls how to override the default theme elements by calling elements functions, like theme(plot.title = element_text(color = "red"))
# 4. Complete themes, like theme_grey() sets all of the theme elements to values designed to work together harmoniously

base <- ggplot(mpg, aes(cty, hwy, color = factor(cyl))) +
  geom_jitter() +
  geom_abline(colour = "grey50", linewidth = 2)
base

# The following graph could be used to share with other but requires a few changes:
# Improving the axes and legend labels
# Adding a title for hte plot
# Tweaking the color scale

labelled <- base +
  labs(
    x = "City mileage/gallon",
    y = "Highway mileage/gallon",
    colour = "Cylinders",
    title = "Highway and city mileage are highly correlated"
  ) +
  scale_colour_brewer(type = "seq", palette = "Spectral")
labelled

# Afterwards, the graph still needs a few more changes for publication:
# The background should be white, not pale grey
# The legend should be placed inside the plot if there's room
# Major gridlines should be a pale grey and minor gridlines should be removed
# Plot title should be 12pt bold text

styled <- labelled +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    legend.background = element_rect(fill = "white", size = 4, colour = "white"),
    legend.justification = c(0.15, 0.8),
    legend.position = c(0.15, 0.8),
    axis.ticks = element_line(colour = "grey70", size = 0.2),
    panel.grid.major = element_line(colour = "grey70", size = 0.2),
    panel.grid.minor = element_blank()
  )
styled

###############################################################################################################################################################################################
# 8.2 Complete Themes
###############################################################################################################################################################################################
# ggplot2 comes with a number of built in themes. The most important being theme_grey(), the signature ggplot2 theme with a light grey background and white gridlines
# There are other several themes built into ggplot2:
# theme bw(): A variation on theme grey() that uses a white background and thin grey grid lines.
# theme_linedraw(): A theme with only black lines of various widths on white backgrounds reminiscent of a line drawing
# theme light(): Similar to theme linedraw() but with light grey lines and axes, to direct more attention towards the data.
# theme dark(): the dark cousin of theme light(), with similar line sizes but a dark background. Useful to make thin colored lines pop out.
# theme minimal(): A minimalistic theme with no background annotations.
# theme classic(): A classic-looking theme, with x and y axis lines and no gridlines.
# theme_void(): A completely empty theme

df <- data.frame(x = 1:3, y = 1:3)
base <- ggplot(df, aes(x, y)) + geom_point()
base + theme_grey() + ggtitle("theme_grey()")
base + theme_bw() + ggtitle("theme_bw()")
base + theme_linedraw() + ggtitle("theme_linedraw()")
base + theme_light() + ggtitle("theme_light()")
base + theme_dark() + ggtitle("theme_dark()")
base + theme_minimal() + ggtitle("theme_minimal()")
base + theme_classic() + ggtitle("theme_classic()")
base + theme_void() + ggtitle("theme_void()")

# All themes have a base_size parameter which controls the base font size. 
# The base font size is the size that the axis titles use. The plot title is usually bigger (1.2x), while the tick and strip labels are smaller (0.8x)

# As well as applying themes a plot at the time the default theme can be changed with theme_set()
# This is not limited to themes built into ggplot2. Other packages like ggthemes add even more

base + theme_tufte() + ggtitle("theme_tufte()")
base + theme_solarized() + ggtitle("theme_solarized()")
base + theme_excel() + ggtitle("theme_excel()")

# Complete themes are great place to start but don't offer much to control. To modify the individual elements, they need to be used with the theme() to override the default settings for an element with an element function 

###############################################################################################################################################################################################
# 8.2.1 Exercises
###############################################################################################################################################################################################
# 1. Try out all the themes in ggthemes. Which do you like the best?
base + theme_base()
base + theme_calc()
base + theme_clean()
base + theme_economist() 
base + theme_economist_white()
base + theme_excel()
base + theme_excel_new()
base + theme_few()
base + theme_fivethirtyeight()
base + theme_foundation()
base + theme_gdocs()
base + theme_hc()
base + theme_igray()
base + theme_map()
base + theme_pander()
base + theme_par()
base + theme_solarized()
base + theme_solarized_2()
base + theme_solid()
base + theme_stata()
base + theme_tufte()
base + theme_wsj()

# I like theme_few(), gdocs, soloarized, tufte

# 2. What aspects of the default theme do you like? What don’t you like? What would you change?

base + theme()
base + theme_bw()
base + theme_classic()
base + theme_dark()
base + theme_get()
base + theme_grey()
base + theme_light()
base + theme_linedraw()
base + theme_minimal()

# I like bw(), classic(), light(), and minimal

###############################################################################################################################################################################################
# 8.3 Modifying Theme Components
###############################################################################################################################################################################################
# To modify an individual theme component use the code "plot + theme(element.name = element.function()"

# There are four basic types of built in element functions: texts, lines, rectangles, and blank. Each element function has a set of parameters that control the appearance
# 1. Element_text() draws labels and headings. The font family, face, color, size (in points), hjust, vjust, angle(in degrees), lineheight (a ratio of fontcase) can be controlled

base_t <- base + labs(title = "This is a ggplot") + xlab(NULL) + ylab(NULL) # Regular plot
base_t
base_t + theme(plot.title = element_text(size = 16)) # Larger title
base_t + theme(plot.title = element_text(face = "bold", color = "lightblue")) # Bold light blue title
base_t + theme(plot.title = element_text(hjust = 1)) # Moves plot title to other side of the graph

# The margins around the text can be controlled with the margin argument and margin() function
# Margin() has four arguments: the amount of space (in points) to add to the top, right, bottom, and left sides of the text. Any elements not specified default to 0

base_t
base_t + theme(plot.title = element_text(margin = margin())) 
base_t + theme(plot.title = element_text(margin = margin(t = 10, b = 10)))
base_t + theme(axis.title.y = element_text(margin = margin(r = 10)))

# 2. element_line() draws lines parameterised by color, size, and linetype

base + theme(panel.grid.major = element_line(color = "black")) # Black lines at every major gridline
base + theme(panel.grid.major = element_line(size = 2)) # Larger major gridlines
base + theme(panel.grid.major = element_line(linetype = "dotted")) # Dotted major gridlines

# 3. element_rect() draws rectangles, mostly used for backgrounds, parameterised by fill, color, and border color, size, and linetype

base + theme(plot.background = element_rect(fill = "grey80", colour = NA)) # Changes color of the background (not the plot)
base + theme(plot.background = element_rect(color = "blue", size = 4)) # Creates a blue rectangle around plot
base + theme(panel.background = element_rect(fill = "linen")) # Changes the background color

# 4. element_blank() draws nothing. Use to remove any element from the graph and the space allocated for that element. To remove elements without losing space used color = NA and fill = NA

base
last_plot() + theme(panel.grid.minor = element_blank())
last_plot() + theme(panel.grid.major = element_blank())

last_plot() + theme(panel.background = element_blank())
last_plot() + theme(
  axis.title.x = element_blank(),
  axis.title.y = element_blank())
last_plot() + theme(axis.line = element_line(colour = "grey50"))

# To modify theme elements for all future plots, use theme_update(). It returns the previous theme settings, so it can be easily restored to the original paramaters once finished

old_theme <- theme_update(
  plot.background = element_rect(fill = "lightblue3", colour = NA),
  panel.background = element_rect(fill = "lightblue", colour = NA),
  axis.text = element_text(colour = "linen"),
  axis.title = element_text(colour = "linen")
)
base
theme_set(old_theme)
base

###############################################################################################################################################################################################
# 8.4 Theme Elements
###############################################################################################################################################################################################
# There are around 40 unique elements that control the appearance of the plot. They can be roughly grouped into five categories: plot, axis, legend, panel, and facet

###############################################################################################################################################################################################
# 8.4.1 Plot Elements
###############################################################################################################################################################################################
# Some elements affect the plot as a whole:

plotelements <- tibble(Element = c("plot.background", "plot.title", "plot.margin"),
                       Setter = c("element_rect()", "element_text()", "margin()"),
                       Description = c("Plot background", "Plot title", "Margins around plot"))
plotelements

# plot.background draws a rectangle that underlies everything else on the plot. By default ggplot2 uses a white background which ensures that the plot is usable wherever it might end up (even when saved as a png and put on a slide with a black background)
# When exporting plots to other systems, make sure the background is transparent with fill = NA. Similarly, if embedding a plot in a system that already has margins, it may be useful to eliminate the built in margins

base
base + theme(plot.background = element_rect(colour = "grey50", size = 2))
base + theme(
  plot.background = element_rect(colour = "grey50", size = 2),
  plot.margin = margin(2, 2, 2, 2)
)
base + theme(plot.background = element_rect(fill = "lightblue"))

###############################################################################################################################################################################################
# 8.4.2 Axis Elements
###############################################################################################################################################################################################
# The axis elements control the appearance of the axes
# Note that axis.text (and axis.title) come in three forms: axis.text, axis.text.x, and axis.text.y
# use the first form to modify the properties of both axes at once: any properties that aren't explicitly set in axis.text.x and axis.text.y will be inherited from axis.text

df <- data.frame(x = 1:3, y = 1:3)
base <- ggplot(df, aes(x, y)) + geom_point()
base + theme(axis.line = element_line(colour = "grey50", size = 1)) # Accentuate the axes
base + theme(axis.text = element_text(color = "blue", size = 12)) # Style both x and y axis labels 
base + theme(axis.text.x = element_text(angle = -90, vjust = 0.5)) # Useful for long labels

# The most common adjustment is to rotate the x-axis labels to avoid long overlapping labels. Note, if doings this negative angles tend to look best and set hjust = 0 and vjust = 1

df <- data.frame(
  x = c("label", "a long label", "an even longer label"),
  y = 1:3
)
base <- ggplot(df, aes(x, y)) + geom_point()
base
base +
  theme(axis.text.x = element_text(angle = -30, vjust = 1, hjust = 0)) +
  xlab(NULL)

###############################################################################################################################################################################################
# 8.4.3 Legend Elements
###############################################################################################################################################################################################
# The legend elements control the appearance of all legends. The appearance of individual legends can be modifying using the same elements in guide_legend() or guide_colorbar()

df <- data.frame(x = 1:4, y = 1:4, z = rep(c("a", "b"), each = 2))
base <- ggplot(df, aes(x, y, colour = z)) + geom_point()
base + theme(
  legend.background = element_rect(
    fill = "lemonchiffon",
    colour = "grey50",
    size = 1
  )
)
base + theme(
  legend.key = element_rect(color = "grey50"),
  legend.key.width = unit(0.9, "cm"),
  legend.key.height = unit(0.75, "cm")
)
base + theme(
  legend.text = element_text(size = 15),
  legend.title = element_text(size = 15, face = "bold")
)

# There are four other properties that control how legends are laid out in the context of the plot (legend.postion, legend.direction, legend.justification, and legend.box)

###############################################################################################################################################################################################
# 8.4.4 Panel Elements
###############################################################################################################################################################################################
# Panel elements control the appearance of the plotting panels

# The main difference between panel.background and panel.border is that the background is drawn underneath the data, and the border is drawn on top of it
# For that reason, it is necessary to assign fill = NA when overriding panel.border

base <- ggplot(df, aes(x, y)) + geom_point()
base + theme(panel.background = element_rect(fill = "lightblue")) # Modifying the background panels
base + theme(panel.grid.major = element_line(color = "gray60", size = 0.8)) # Modifying the major grid lines
base + theme(panel.grid.major.x = element_line(color = "gray60", size = 0.8)) # Modifying the grid lines in one direction

# Note that aspect ratio controls the aspect ratio of the panel, not the overall plot:

base2 <- base + theme(plot.background = element_rect(colour = "grey50"))
base2
base2 + theme(aspect.ratio = 9 / 16) # Wide screen
base2 + theme(aspect.ratio = 2 / 1) # Long and skinny
base2 + theme(aspect.ratio = 1) # Square

###############################################################################################################################################################################################
# 8.4.5 Faceting Elements
###############################################################################################################################################################################################
# Some theme elements are associated with faceted ggplots
# Element strip.text.x affects both facet_wrap() and facet_grid()
# strip.text.y only affects facet_grid()

df <- data.frame(x = 1:4, y = 1:4, z = c("a", "a", "b", "b"))
base_f <- ggplot(df, aes(x, y)) + geom_point() + facet_wrap(~z)

base_f
base_f + theme(panel.margin = unit(0.5, "in"))
base_f + theme(
  strip.background = element_rect(fill = "grey20", color = "grey80", size = 1),
  strip.text = element_text(colour = "white")
)

###############################################################################################################################################################################################
# 8.4.6 Exercises
###############################################################################################################################################################################################
# 1. theme_dark() makes the inside of the plot dark, but not the outside. Change the plot background to black, and then update the text settings so labels can still be read

df <- data.frame(x = 1:4, y = 1:4, z = c("a", "a", "b", "b"))
ggplot(df, aes(x, y)) + geom_point(color = "white") + 
  theme_dark() +
  theme(plot.background = element_rect(fill = "black"),
        axis.title = element_text(color = "white"),
        axis.text = element_text(color = "white"))

###############################################################################################################################################################################################
# 8.5 Saving Your Output
###############################################################################################################################################################################################
# When saving a plot to use in another program, there are two basic choices of output: raster or vector
# Vector graphics describe a plot as s sequence of operations: draw a line from (x1,y1) to (x2,y2), draw a circle at (x3,x4) with radius r. 
# This means that they are effectively "infinitely" zoomable; there is no loss of detail. The most useful vector graphic formats are pdf and svg
# Raster graphics are stored as an array of pixel colors and have a fixed optimal viewing size. The most useful raster graphic format is png

# Unless there is a compelling reason not to, use vector graphics, they look better in more places. However, there are two main reasons to use raster graphics
# 1. There is a plot (scatterplot) with thousands of graphical objects (points). A vector version will be large and slow to render
# 2. The images are being embedded into MS Office. MS has poor support for vector graphics, so raster graphics are easier.

# There are two ways to save outputs from ggplot2. The standard R appproach where a graphics devices is opened, the plot is generated, and the the device is closed

pdf("output.pdf", width = 6, height = 6)
ggplot(mpg, aes(displ, cty)) + geom_point()
dev.off()

# This works for all packages but is verbose, ggplot2 provides a convenient shorthand with ggsave()

ggplot(mpg, aes(displ, cty)) + geom_point()
ggsave("output.pdf")

# ggsave(0 is optimized for interactive use; and can be used after a plot has been drawn. it has the following important arguments:
# The first argument, path, specifies the path where the image should be saved. The file extension will be used to automatically select the correct graphics device. ggsave() can produce .ps, .pdf. svg, .wmf, .png, .jpg, .bmp, and .tiff
# width and height control the save output size, specified in inches. If left blank it'll use the size of the on-screen graphics
# For raster graphics (ie. .png, .jpg) the dpi argument controls the resolution of the plot. It defaults to 300, which appropriates for most printers, but it may be more useful to use 600 for high resolution outputs, or 96 for on-screen display

###############################################################################################################################################################################################
# End of Chapter 8
###############################################################################################################################################################################################
















