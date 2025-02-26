######################################################################

### Using color more effectively in DOL graphics (demonstration in R)

### creating graphics that are compelling requires good use of color
### colors have to be manually specified in R.  Below are some very 
### simple templates to help you get started.  Most of what is described 
### here can also be adapted to other packages.  Demonstrations are 
### provided.  

######################################################################

#  (Easy) Using the palette function to select colors from pre-defined templates

######################################################################

# clean up
rm(list = ls())
dev.off()

# set working directory
setwd("~/learn/basicr/")

### Using color more effectively in DOL graphics (demonstration in R)

### creating graphics that are compelling requires good use of color
### colors have to be manually specified in R.  Below are some very 
### simple templates to help you get started.  Most of what is described 
### here can also be adapted to other packages.  Demonstrations are 
### provided.  

# companion excel worksheet is 

######################################################################

#  (Easy) Using the palette function to select colors from pre-defined templates

n <- 6
color_scheme <- palette(rainbow(n))     # basic :: six color rainbow
pie(rep(1,n), col=color_scheme)

B <- seq(6,(n+5),1)
barplot(B, col=color_scheme)

######################################################################
### briefly before we do more with colors, gray scale can often be useful

color_scheme <- (palette(gray(seq(0,.9,len = n)))) # converting to grey scale
pie(rep(1,n), col=color_scheme)

B <- seq(6,(n+5),1)
barplot(B, col=color_scheme)

######################################################################

### Changing the density of the color
### remember from the graphing section that you can also alter color density by 
### setting the density of the color manually. (zoom the plots to see how they look)

color_scheme <- palette(rainbow(n))     # basic :: six color rainbow
pie(rep(1,n), col=color_scheme)

barplot(B, col=5, density=c(2, 4, 9, 12, 25, 99))
pie(rep(1,n), col=5, density=c(2, 4, 9, 12, 25, 99))

######################################################################

### using patterns instead of colors
set.seed(1)
mat <- matrix(runif(4*7, min=0, max=10), 7, 4)
rownames(mat) <- 1:7
colnames(mat) <- LETTERS[1:4]
ylim <- range(mat)*c(1,1.25)


#barplot(mat, beside=TRUE, ylim=ylim, col=1, lwd=1:2, angle=45, density=seq(5,35,5))
#barplot(mat, add=TRUE, beside=TRUE, ylim=ylim, col=1, lwd=1:2, angle=c(45, 135), density=seq(5,35,5))

# !!!
# note, run the lines below one by one, and see the incremental change in the plot.
# we are layering in features, and the difference in the code shows you what is making those differences

barplot(mat)
barplot(mat, beside=TRUE)
barplot(mat, beside=TRUE, ylim=ylim)
barplot(mat, beside=TRUE, ylim=ylim, col=1, lwd=1:2, angle=45, density=seq(5,35,5))
barplot(mat, add=TRUE, beside=TRUE, ylim=ylim, col=1, lwd=1:2, angle=c(45, 135), density=seq(5,35,5))

### note, if having a legend is important, you can use the following to add one.  
legend("top", legend=1:7, ncol=7, fill=TRUE, cex=.8, col=1, angle=45, density=seq(5,35,5))
legend("top", legend=1:7, ncol=7, fill=TRUE, cex=.8, col=1, angle=c(45, 135), density=seq(5,35,5))

######################################################################
#Create a vector of colors from vectors specifying hue, saturation and value.

# for full control, you can set hue, saturation, and value to create a spectrum of colors
# specify values in ranges from 0 to 1, 
# alpha is the transparency, 0 is fully transparent, 1 is fully opaque
# SYNTAX :: hsv(h = .5, s = .5, v = .5, alpha = .5)      

#creates a uniform color
pie(rep(1,n), col=hsv(1, 1, 1))

# to create a gradient, we need to create a vector with varying color values
val <- seq(0.0, 1.0, by=1/n)

# insert this vector as an argument, function will return a vector of colors in a gradient
pie(rep(1,n), col=hsv(val, 1, 1))
pie(rep(1,n), col=hsv(1,val, 1))
pie(rep(1,n), col=hsv(1, 1, val))

pie(rep(1,n), col=hsv(val, 1, val))
pie(rep(1,n), col=hsv(val, val, val))

# halftoning using the alpha value  
# Note, useful for producing contrasts or when you want to draw attention to something else 

pie(rep(1,n), col=hsv(val, 1, 1, alpha = .3))
pie(rep(1,n), col=hsv(val, 1, 1, alpha = .45))
pie(rep(1,n), col=hsv(val, 1, 1, alpha = .6))

pie(rep(1,n), col=hsv(1, 1, 1, alpha = val))
pie(rep(1,n), col=hsv(.4, 1, 1, alpha = val))
pie(rep(1,n), col=hsv(.73, 1, 1, alpha = val))

pie(rep(1,n), col=hsv(val, val, val, alpha = .3))
pie(rep(1,n), col=hsv(val, val, val, alpha = .45))
pie(rep(1,n), col=hsv(val, val, val, alpha = .6))

## using more specificity
hue_n <- seq(0.3, 0.8, by=(.8-.3)/n)
sat_n <- seq(0.3, 0.9, by=(.9-.3)/n)
val_n <- seq(0.3, 0.8, by=(.8-.3)/n)
alpha_n <- seq(0.4, 0.8, by=(.8-.4)/n)

pie(rep(1,n), col=hsv(hue_n, sat_n, val_n, alpha_n))

#  (Easy) Using colorramppalette to move in steps from one color to another

n <- 6
B <- seq(6,(n+5),1)
color_scheme <- colorRampPalette(c("blue", "red"))(n) 
pie(rep(1,n), col=color_scheme)
barplot(B, col=color_scheme)

### note that this is a really good way to do gradients, but the colors are fixed
### and cannot be halftoned or shaded.

color_scheme <- colorRampPalette(c("green", "red"))(n) 
pie(rep(1,n), col=color_scheme)

color_scheme <- colorRampPalette(c("blue", "yellow"))(n) 
pie(rep(1,n), col=color_scheme)

### so this is great, but what about maximizing the contrast?

#basic color wheel
#http://www.realmenrealstyle.com/wp-content/uploads/2010/09/color_wheel.gif

# warm and cool
#http://www.fivestarpainting.com/images/Blog-Images/Color-Wheel-cool-vs.-warm.jpg

color_scheme <- colorRampPalette(c("white", "black"))(n) 
pie(rep(1,n), col=color_scheme)
barplot(B, col=color_scheme)

# opposite ends fo the color wheel
color_scheme <- colorRampPalette(c("yellow", "purple"))(n) 
pie(rep(1,n), col=color_scheme)
barplot(B, col=color_scheme)

# more or less successful?  it's really a question of context in the visualization
color_scheme <- colorRampPalette(c("#ffff99", "#b15928"))(n) 
pie(rep(1,n), col=color_scheme)
barplot(B, col=color_scheme)

color_scheme <- colorRampPalette(c("#e31a1c", "#fdbf6f"))(n) 
pie(rep(1,n), col=color_scheme)
barplot(B, col=color_scheme)

### Note that in colorRampPalette you are not limited to two colors
# three colors
color_scheme <- colorRampPalette(c("red", "yellow", "blue"))(n) 
pie(rep(1,n), col=color_scheme)
barplot(B, col=color_scheme)

# one color
color_scheme <- colorRampPalette(c("dark blue", "light blue"))(n) 
pie(rep(1,n), col=color_scheme)
barplot(B, col=color_scheme)

### this accomplishes a lot of what we were trying to do earlier with our hue and saturation
### edits.

###################################################################
###################################################################

### color and contrast on maps
### note, we have other code files that walk through this process, if you need help 
### with maps, let us know and we'll give you template code with more comments and guidance
install.packages("maps")
library(maps)
library(foreign)

# make random values to plot
map_value <- runif(50,2,8)

# break numebrs into groups just to haev something to plot on the map
# first is a vector of values (to plot) and the second is the number of categories (for the legend)
map_ints <- findInterval(map_value, c(3,4,5,6,7))+1
map_cats <- unique(map_ints)

### make legend from the number of groups actually present in the data
grouplegend <- paste("Group", map_cats, sep=" ")

## call the map function, pass in random data and color scheme created earlier
mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)

#add a title
title(paste ("Example of using color for maps"),cex.main = 1.1)

#add a legend
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme,
       cex = .7,
       bty = "n") # border

###################################################################

### change to a more colorful scheme and replot the map

# patriotic
color_scheme <- colorRampPalette(c("white", "red", "blue"))(n) 
mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme,
       cex = .7,
       bty = "n") # border

###################################################################

# color wheel primary
color_scheme <- colorRampPalette(c("red", "yellow", "blue"))(n) 
mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme,
       cex = .7,
       bty = "n") # border

# color wheel secondary
color_scheme <- colorRampPalette(c("orange", "green", "violet"))(n) 
mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme,
       cex = .7,
       bty = "n") # border

###################################################################

# two primaries in the color wheel
color_scheme <- colorRampPalette(c("red", "blue"))(n) 
mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme,
       cex = .7,
       bty = "n") # border


### halftoning the color scheme

color_scheme_transp <- paste(color_scheme, "85", sep="")

mp <- map('state', 
          col = color_scheme_transp[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme_transp,
       cex = .7,
       bty = "n") # border

###################################################################

# two primaries in the color wheel
color_scheme <- colorRampPalette(c("red", "yellow"))(n) 
mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme,
       cex = .7,
       bty = "n") # border


### halftoning the color scheme

color_scheme_transp <- paste(color_scheme, "98", sep="")

mp <- map('state', 
          col = color_scheme_transp[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme_transp,
       cex = .7,
       bty = "n") # border


# two primaries in the color wheel
color_scheme <- colorRampPalette(c("blue", "yellow"))(n) 
mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme,
       cex = .7,
       bty = "n") # border


### halftoning the color scheme

color_scheme_transp <- paste(color_scheme, "98", sep="")

mp <- map('state', 
          col = color_scheme_transp[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme_transp,
       cex = .7,
       bty = "n") # border

###########################################################
###########################################################
# high contrast white -->> color fades
# find a dark color from the following: 
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
# http://research.stowers-institute.org/efg/R/Color/Chart/

# picking a dark color from http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
color_scheme <- colorRampPalette(c("white", "red4"))(n) 
mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(+.05,+.05),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme,
       cex = .7,
       bty = "n") # border

# picking a dark color from http://research.stowers-institute.org/efg/R/Color/Chart/
color_scheme <- colorRampPalette(c("white", 491))(n) 
mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(+.05,+.05),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme,
       cex = .7,
       bty = "n") # border


#### some unconventional but potentially interesting color options

#define a long list of potential colors
color = c("aliceblue","antiquewhite","aquamarine","azure","beige","bisque","black","blanchedalmond","blue","blueviolet","brown","burlywood","cadetblue","chartreuse","chocolate",
          "coral","cornflowerblue","cornsilk","cyan","darkblue","darkcyan","darkgoldenrod","darkgray","darkgreen","darkgrey","darkkhaki","darkmagenta",
          "darkolivegreen","darkorange","darkorchid","darkred","darksalmon","darkseagreen","darkslateblue","darkslategray","darkslategrey","darkturquoise","darkviolet","deeppink","deepskyblue","dimgray","dimgrey","dodgerblue",
          "firebrick","floralwhite","forestgreen","gainsboro","ghostwhite","gold","goldenrod","gray","green","greenyellow","honeydew","hotpink","indianred","ivory","khaki","lavender",
          "lavenderblush","lawngreen","lemonchiffon","lightblue","lightcoral","lightcyan","lightgoldenrod","lightgoldenrodyellow","lightgray","lightgreen","lightgrey","lightpink","lightsalmon","lightseagreen","lightskyblue","lightslateblue",
          "lightslategray","lightslategrey","lightsteelblue","lightyellow","limegreen","linen","magenta","maroon","mediumaquamarine","mediumblue","mediumorchid","mediumpurple","mediumseagreen","mediumslateblue","mediumspringgreen","mediumturquoise",
          "mediumvioletred","midnightblue","mintcream","mistyrose","moccasin","navajowhite","navy","navyblue","oldlace","olivedrab","orange","orangered","orchid","palegoldenrod","palegreen","paleturquoise",
          "palevioletred","papayawhip","peachpuff","peru","pink","plum","powderblue","purple","red","rosybrown","royalblue","saddlebrown","salmon","sandybrown","seagreen","seashell",
          "sienna","skyblue","slateblue","slategray","slategrey","snow","springgreen","steelblue","tan","thistle","tomato","turquoise","violet","violetred","wheat","whitesmoke","yellow","yellowgreen","white")

n <- 51
# method 1A, pick a random group of colors
# !!! note, you can highlight and re-run lines 457-461 repeatedly, and see all sorts of different combinations
# you may see colors that you would not have thought to put together, that end up going well together or working effectively.

color_scheme <- sample(color, n)

mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)


# method 1B, pick a predictable group of colors 

# !!! note, you can highlight and re-run lines 470-475 repeatedly, just change the value for "start".
# this is like the code above, but more predictable.  you can always see the selected colors by just typing "color_scheme" at the console.
# you may see colors that you would not have thought to put together, that end up going well together or working effectively.

start = 35
color_scheme = color[c(start:(start+(n-1)))]

mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)

# method 1C, just pick the colors you want to use, note that random selections and even sequential selection
# from the list above may have colors that are really close.  I recommend high-contrast colors.
# ref: http://graphicdesign.stackexchange.com/questions/3682/where-can-i-find-a-large-palette-set-of-contrasting-colors-for-coloring-many-d
# ref: http://www.iscc.org/pdf/PC54_1724_001.pdf
# ref: http://stackoverflow.com/questions/7251872/is-there-a-better-color-scale-than-the-rainbow-colormap
color = c("#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784", "#8e063b", "#4a6fe3", "#8595e1", "#b5bbe3", "#e6afb9", "#e07b91", "#d33f6a", "#11c638", "#8dd593", "#c6dec7", "#ead3c6", "#f0b98d", "#ef9708", "#0fcfc0", "#9cded6", "#d5eae7", "#f3e1eb", "#f6c4e1", "#f79cd4")
color_scheme <- color[c(1:n)]

mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)


#### a second option is to simply randomly sample the color space.  the code below will 
#### produce a list of N random colors.  This is often useful for identifying color schemes
#### that work well but that you might not have chosen.  repeatedly running this code and the 
#### plotting code will show you lots of variants in how the charts/plots/maps look with 
#### varying color schemes.

#### rerun lines 498 -> 505 repeatedly and you'll see the map change and the colors in the console

color = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
color_scheme = sample(color, n)

mp <- map('state', 
          col = color_scheme[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)

color_scheme

#### a final option is using predefined grey scales
# the tables below have different numbers of grey scales depending on the data points
# in some graphical applications, you need consistency.  this approach would achieve that 
# by rendering graphs with similar numbers of data points in similar ways.
# you will lose something in terms of maximum contrast to achieve this consistency

if (n <= 6) {
  color = c("gray0","gray20","gray40","gray60","gray80","gray100")
} else if (n <= 8){
  color = c("gray0","gray13","gray26","gray39","gray52","gray65","gray78","gray91")
} else if (n <= 10){
  color = c("gray0","gray10","gray20","gray30","gray40","gray50","gray60","gray70","gray80","gray90","gray100")
} else if (n <= 15){
  color = c("gray0","gray7","gray14","gray21","gray28","gray35","gray42","gray49","gray56","gray63","gray70","gray77","gray84","gray91","gray98")
} else if (n <= 21){
  color = c("gray0","gray5","gray10","gray15","gray20","gray25","gray30","gray35","gray40","gray45","gray50","gray55","gray60","gray65","gray70","gray75","gray80","gray85","gray90","gray95","gray100")
} 

mp <- map('state', 
          col = color[map_ints], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)

###############################################
### ADA compliant color schemes are both appealing and high contrast

# color visualization safe palette:
# http://mkweb.bcgsc.ca/biovis2012/color-blindness-palette.png
# in addition to being color-safe, this is also high contrast and effective.

color_scheme <-  palette(c(rgb(0,0,0, maxColorValue=255),
                           rgb(0,73,73, maxColorValue=255),
                           rgb(0,146,146, maxColorValue=255),
                           rgb(255,109,182, maxColorValue=255),
                           rgb(255,182,219, maxColorValue=255),
                           rgb(73,0,146, maxColorValue=255),
                           rgb(0,109,219, maxColorValue=255),
                           rgb(182,109,255, maxColorValue=255),
                           rgb(109,182,255, maxColorValue=255),
                           rgb(182,219,255, maxColorValue=255),
                           rgb(146,0,0, maxColorValue=255),
                           rgb(146,73,0, maxColorValue=255),
                           rgb(219,109,0, maxColorValue=255),
                           rgb(36,255,36, maxColorValue=255),
                           rgb(255,255,109, maxColorValue=255)))

###########################
### some quick graphics 
n <- 15
B <- seq(6,(n+5),1)
pie(rep(1,n), col=color_scheme)
barplot(B, col=color_scheme)

###########################
### a quick map
mp <- map('state', 
          col = color_scheme[map_ints+5], fill = TRUE, 
          resolution = 0, lty = 1, lwd = 0.2)
title(paste ("Example of using color for maps"),cex.main = 1.1)
legend("bottomright", # position
       legend = grouplegend, 
       inset=c(0,0),
       ncol = 1,
       #horiz = "true",
       title = "Legend",
       fill = color_scheme[6:(n+5)],
       cex = .7,
       bty = "n") # border
