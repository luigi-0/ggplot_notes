# Script containing some simple GGPlot2 graphs
# Material comes from "R for Data Science"
library(tidyverse)

# I'll be using the R's pre-installed mpg dataset

# A simple scatter plot

# ggplot creates a coordinate system that you can add layer to
ggplot(mpg) +
  # Let's add a layer to our plot by adding a layer of points
    # Each geom function in ggplot takes a mapping argument
    # The mapping argument is always paired with aes() 
  geom_point((mapping = aes(x = displ, y = hwy)))

# Let's create a resuable template 
# template <- ggplot(data = <DATA>) +
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# Let's talk about about Aesthetic Mappings-- aes()

# Aesthetics allow us to change different levels of the geom function
# With aes(), if your geom is geom_point, you can change the levels of
# a point's size, shape, and color

# Let's use aes() to add a dimension to our plot
ggplot(mpg) +
  # With this aes(), ggplot will color each point according to class of car
  # ggplot will automatically select colors through a process called scaling
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# In essence, what we did with the color aes parameter was map a unique color
# to each class. 

# There's many different ways to map variables to different aesthetics, so 
# you got options

# You can also set aesthetics of a geom manually
ggplot(mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color='blue')

# What if you have a bunch of categorical variables and you want to 
# visualize them without using aes()? Facets!
# Facets are just subplots that hone in on different categories

# Let's facet our plot with a single variable
ggplot(mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  # The variable you pass to facet_wrap() must be discrete
  facet_wrap(~ class, nrow = 2)

# Let's facet our plot with drive train type and num of cylinders
ggplot(mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  # You can use . to only facet on a row or column variable
  facet_grid(drv ~ cyl)

# Now, we'll define this geom thing we've been talking about

# A geom is a visual object used to represent the data (ex. line, bar, point)

# The point geom
ggplot(mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

# The smooth line geom
ggplot(mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# Let's use an aesthetic to draw different lines for a categorical variable
ggplot(mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# Moving on. Let's plot more than one geom on a plot
ggplot(mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# But there's too much code repition...

# Here, we pass the mappings directly to the plot and make them global
# to all geoms in the plot
ggplot(mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()
  
# Now, let's mix global mappings with local mappings
ggplot(mpg, mapping = aes(x = displ, y = hwy)) +
         geom_point(mapping = aes(color = class)) +
         geom_smooth()

# How else can we customize our layers? Let's use a different dataset for one layer
ggplot(mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(
    data = filter(mpg, class == 'subcompact'),
    se = FALSE
  )

# The moment we've been waiting for: Bar Charts!!!

# ggplot comes with the diamonds dataset, so we'll use that
ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

# So now you know that the bar geom will create bins for each category 
# in the aesthetic and count how many observations belong to each bin

# But we all know why you made it this far. Let's put some color in it
ggplot(diamonds) +
  # Color on the edges of the bar; damn that's sexy
  geom_bar(mapping = aes(x = cut, color = cut))

ggplot(diamonds) +
  # fill in each bar with a unique color
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(diamonds) +
  # fill in the bar with the count of another discrete variable
  geom_bar(mapping = aes(x = cut, fill = clarity))

# But we can raise the bar... on these bar charts by using the three position aes

# Setting position = identity will place each object where it's supposed to 
# on the graph, so the bars will just be placed over each other...useless
# so just to make this plot semi-useful you have to mess with transparency (& alpha)
ggplot(
  diamonds,
  mapping = aes(x = cut, fill = clarity)
  ) +
  geom_bar(alpha = 1/5, position = 'identity')
ggplot(
  data = diamonds,
  mapping = aes(x = cut, color = clarity
  ) +
    geom_bar(fill = NA, position = 'identity')
)

# What about the fill position?
# The fill position will make all bars the same height, so its easy to 
# see the proportions across the groups
ggplot(diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = 'fill'
)

# Now, the dodge position, which places overlapping objects next to each other 
ggplot(diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = 'dodge'
)

# OK, so I lied, there is one more position you can use, but its mainly useful
# for scatter plots
# Jitter will inject some random noise to each point so its easy for you to see
# mass accumulations of observations. This makes your plot a little 'wrong', but
# it helps you see some patterns that may have been hidden by overplotting
ggplot(mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy),
    position = 'jitter'
)

# You can change the coordinate system for your plot. The defualt is the cartesian system
# Here's an example and a brief description of some of them:

# coord_flip() will flip the x and y axis. Useful if labels are long and you want to make them readable
ggplot(mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

# coord_quickmap() sets the aspect ratio if you were making a map
# coord_polar() uses polar coordinates (Yay! Calc 3 wasn't a waste!) which 
# will turn your bar charts into something called a Coxcomb chart (a pie chart someone got at)

# Let's recap all that we've covered about ggplot

# The template to make any graph in ggplot is:
# ggplot(<DATA>) +
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>,
#     position = <POSITION>
# ) +
# <COORDINATE_FUNCTION> +
# <FACET_FUNCTION>

# The seven parameters in the template compose the grammar of graphics.

# You start with a dataset

# Transform the dataset into information you want to graph (with a stat)

# Choose a geometric object to represent each observation

# Potentially use the aesthetic properties of the geometric object to represent
# variables in the data

# You'd map the values of each variable to the levels of an aes()

# Select a coordinate system to place the geoms in

# Use the location of the object--an aes--to display the values of x and y vars

# At this point you'd have a complete graph, but you could:
  # adjust the position of the geoms within the coordinate system (position adjustment)
  # split the graph into subplots (faceting)

# You could also add more layers, where each layer uses a different:
  # dataset
  # geom
  # set of mappings
  # stat
  # positional adjustment

# With all of these options, you could build any graph you want