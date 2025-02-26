### making graphs in R

# clean up
rm(list = ls())
dev.off()

# set working directory
setwd("~/learn/basicr/")

### basics

### 1) have data ready to plot
### 2) pick plot type, add libraries and functions as necessary
### 3) pick plot colors, formats, add chart title, axis titles, and legend
### 4) view in plot window and export for office use

#1 have data ready to plot (sample data from R's datasets-package: http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html)
mydata <- as.data.frame(airmiles)
colnames(mydata)[1] <- "miles"
mydata$year <- seq(1937,1960,1)
mydata <- mydata[1:20,]
mydata 

################################# #################################
# Some basics/cosmetics associated with plotting in R

# basic barplot
barplot(mydata$miles)

# basic scatterplot
plot(mydata$year,mydata$miles)

# basic (or not so basic) line plot

# a few steps involved: must define the p
par(pch=22, col="red") # plotting symbol and color 

# there are lots of options for line plots (http://www.statmethods.net/graphs/line.html)
#Line only
plot(mydata$year,mydata$miles, type="n", main="line plot") 
lines(mydata$year,mydata$miles, type="l") 

# points and lines
plot(mydata$year,mydata$miles, type="n", main="line plot") 
lines(mydata$year,mydata$miles, type="o") 

# points joined by lines
plot(mydata$year,mydata$miles, type="n", main="line plot") 
lines(mydata$year,mydata$miles, type="b") 

# stair step
plot(mydata$year,mydata$miles, type="n", main="line plot") 
lines(mydata$year,mydata$miles, type="s") 

# histogram / vertical
plot(mydata$year,mydata$miles, type="n", main="line plot") 
lines(mydata$year,mydata$miles, type="h") 

################################# #################################
### true histogram functionality includes categorization within bins.
### there are numerous libraries that can accomplish this, but the hist()
### function is part of {base} and is easy and quick for EDA

### note also that we label the axes and title with something more meaningful!!!!

mydata <- discoveries
mydata

h<-hist(mydata, breaks = 12, col="lightblue", xlab="Number of Discoveries", ylab="Frequency over Time", 
        main="Number of Discoveries Over Time (1860 - 1959)") 

################################# #################################

### basic graph with data from here: https://vincentarelbundock.github.io/Rdatasets/datasets.html

### bring in the data: Canadian Women's Labour-Force Participation

y <- read.csv("bfox.csv")

# check out the data
y
colnames(y)

plot(y$year, y$menwage, type="l", lwd=2, col="blue", ylim=c(10, 50), xlab="Year", ylab="Average Weekly Wage ($C)")
lines(y$year,y$womwage, lwd=2, col="red")
title("Wages for Women and Men in Canada, 1946-1975")
legend("topleft", legend=c("Men","Women"), cex=0.8, lwd=c(2,2), col=c("blue","red"))

# let's talk about some of the details in this, and specifically some idiosyncracies in R
# a lot of the graphical parameters in R should be thought of as proportional: they are 
# ratios of the size of the plot window.  so for instance, in the text above, "cex=0.8" is 
# telling you that the legend text should be 80% of the default size.  we can run the 
# same code, but increase the size of the legend, proportionally....


plot(y$year, y$menwage, type="l", lwd=2, col="blue", ylim=c(10, 50), xlab="Year", ylab="Average Weekly Wage ($C)")
lines(y$year,y$womwage, lwd=2, col="red")
title("Wages for Women and Men in Canada, 1946-1975")
legend("topleft", legend=c("Men","Women"), cex=1.3, lwd=c(2,2), col=c("blue","red"))

# We can add an "inset" aspect to the legend to specify it's distance from the axis

legend("topleft", inset = c(.1,.1), legend=c("Men","Women"), cex=1.3, lwd=c(2,2), col=c("blue","red"))
legend("topleft", inset = c(.2,.2), legend=c("Men","Women"), cex=1.3, lwd=c(2,2), col=c("blue","red"))

# cex is a number indicating the amount by which plotting text and symbols should be scaled relative to the default. 
# 1=default, 1.5 is 50% larger, 0.5 is 50% smaller, etc.

#cex.axis:  magnification of axis annotation relative to cex
#cex.lab:  magnification of x and y labels relative to cex
#cex.main:	magnification of titles relative to cex
#cex.sub:	magnification of subtitles relative to cex

# we can revise the prior plot by playing around with this:  
### I raised the cex factor in legend to 1.3, the cex factor for axis labels to 1.3, 
### and decreased the cex factor for axis annotations to 80% of default.

plot(y$year, y$menwage, type="l", lwd=2, col="blue", ylim=c(10, 50), xlab="Year", ylab="Average Weekly Wage ($C)", cex.axis = 0.8, cex.lab = 1.3)
lines(y$year,y$womwage, lwd=2, col="red")
title("Wages for Women and Men in Canada, 1946-1975", cex.main = 1.2)
legend("topleft", legend=c("Men","Women"), cex=1.3, lwd=c(2,2), col=c("blue","red"))

### a few more changes to try to get this just right....
### I also increased the lwd (line width) to 4.5 the default
### I move the legend away from the axis frame just a bit

### note that you need to change the line width in the legend as well as in the plot itself....

plot(y$year, y$menwage, type="l", lwd=4.5, col="blue", ylim=c(10, 50), xlab="Year", ylab="Average Weekly Wage ($C)", cex.axis = 0.8, cex.lab = 1.3)
lines(y$year,y$womwage, lwd=4.5, col="red")
title("Wages for Women and Men in Canada, 1946-1975", cex.main = 1.2)
legend("topleft", inset = c(.025,.025), legend=c("Men","Women"), cex=1.3, lwd=c(4.5,4.5), col=c("blue","red"))


# additional helpful examples here
# ref: http://www.statmethods.net/advgraphs/parameters.html

###############################################################################################
### some other really good data sets to practice graphing on

# https://vincentarelbundock.github.io/Rdatasets/csv/DAAG/nsw74demo.csv
#  data description: https://vincentarelbundock.github.io/Rdatasets/doc/DAAG/nsw74demo.html

# https://vincentarelbundock.github.io/Rdatasets/csv/DAAG/races2000.csv")  
#  data description: https://vincentarelbundock.github.io/Rdatasets/doc/DAAG/races2000.html
################################# #################################


### here is an excel like example.  the code is a bit more complicated, but by the 
### end of this session, you'll know about most of the features

Orange

# convert factor to numeric for convenience 
Orange$Tree <- as.numeric(Orange$Tree) 
ntrees <- max(Orange$Tree)

# get the range for the x and y axis, so we know how big the plot window needs to be
xrange <- range(Orange$age) 
yrange <- range(Orange$circumference) 

# set up the plot window
plot(xrange, yrange, type="n", xlab="Age (days)",
     ylab="Circumference (mm)" ) 

# set the number of different colors to the number or trees
colors <- rainbow(ntrees) 

# set the number of different line types to the number or trees
linetype <- c(1:ntrees) 

# set the number of different plotting symbols to the number or trees
plotchar <- seq(18,18+ntrees,1)

# add lines: this is a loop that steps through and makes data series for each type of tree, and then plots them
for (i in 1:ntrees) { 
  tree <- subset(Orange, Tree==i) 
  lines(tree$age, tree$circumference, type="b", lwd=1.5,
        lty=linetype[i], col=colors[i], pch=plotchar[i]) 
} 

# add a title and subtitle 
title("Tree Growth", "example of line plot")

# add a legend 
legend(xrange[1], yrange[2], 1:ntrees, cex=0.8, col=colors,
       pch=plotchar, lty=linetype, title="Tree")

################################# #################################

# let's make some of the same changes we discussed above....

# we can revise the prior plot by playing around with this:  
### I raised the cex factor in legend to 1.2, the cex factor for axis labels to 1.3, 
### and decreased the cex factor for axis annotations to 80% of default.
### I also increased the lwd (line width) to 2.5 the default

# set up the plot 
plot(xrange, yrange, type="n", xlab="Age (days)", ylab="Circumference (mm)" , cex.lab = 1.3, cex.axis = .8) 
colors <- rainbow(ntrees) 
linetype <- c(1:ntrees) 
plotchar <- seq(18,18+ntrees,1)
# add lines 
for (i in 1:ntrees) { 
  tree <- subset(Orange, Tree==i) 
  lines(tree$age, tree$circumference, type="b", lwd=2.5,
        lty=linetype[i], col=colors[i], pch=plotchar[i]) 
} 
# add a title and subtitle 
title("Tree Growth", "plot not suitable for publication", cex.sub = 1.3)
# add a legend 
legend(xrange[1], yrange[2], 1:ntrees, cex=1.2, lwd=2.5, col=colors,
       pch=plotchar, lty=linetype, title="Tree")

# This example shows how you can customize the look and feel of your graphics to accomplish a style
# that your deliverables need.  the default is often good for exploring but if you want to make 
# graphics that really pop on slides or presentations, you may need to customize

################################# #################################

## producing output for slides and presentations, publications, etc....

## to write out your materials, simply place a wrapper aroud the plotting function.  
## above the plot, place the following: 

    ## prepare to write out the output to a JPG file, this alleviate issues with plotting in R studio
    jpeg('current_supergroups.jpg', quality = 100, bg = "white", res = 200, width = 12, height = 8, units = "in")

## and at the end of the plot, place the following: 


    ## end of code to write out JPG, turn graphics writing device off
    dev.off()

## This will create a static graphic image from your materials, in the format you specify, 
## and drop it in the default directory


## example of writing the output to a JPG file
jpeg('example_graphic.jpg', quality = 100, bg = "white", res = 200, width = 12, height = 8, units = "in")


# convert factor to numeric for convenience 
Orange$Tree <- as.numeric(Orange$Tree) 
ntrees <- max(Orange$Tree)
# get the range for the x and y axis 
xrange <- range(Orange$age) 
yrange <- range(Orange$circumference) 
# set up the plot 
plot(xrange, yrange, type="n", xlab="Age (days)", ylab="Circumference (mm)" , cex.lab = 1.3, cex.axis = .8) 
colors <- rainbow(ntrees) 
linetype <- c(1:ntrees) 
plotchar <- seq(18,18+ntrees,1)
# add lines 
for (i in 1:ntrees) { 
  tree <- subset(Orange, Tree==i) 
  lines(tree$age, tree$circumference, type="b", lwd=2.5,
        lty=linetype[i], col=colors[i], pch=plotchar[i]) 
} 
# add a title and subtitle 
title("Tree Growth", "plot not suitable for publication", cex.sub = 1.3)
# add a legend 
legend(xrange[1], yrange[2], 1:ntrees, cex=1.2, col=colors,
       pch=plotchar, lty=linetype, title="Tree")

## end of code, write out JPG, turn graphics writing device off
dev.off()

#####################################################################
#####################################################################

# simple example of combining plots: 

### bring in the data: Canadian Women's Labour-Force Participation
y <- read.csv("bfox.csv")
colnames(y)

par(mfrow=c(3,1)) 
hist(y$menwage)
hist(y$womwage)
hist(y$partic)

par(mfrow=c(2,2)) 
hist(y$menwage)
hist(y$womwage)
hist(y$partic)
hist(y$parttime)

# and of course, you can incorporate everythign else we have worked on....

par(mfrow=c(2,2)) 
hist(y$menwage, xlab="X axis title", ylab="y axis title", main="chart title", cex.lab = 1.2, cex.axis = .8, cex.main = 1.4 )
hist(y$womwage, xlab="X axis title", ylab="y axis title", main="chart title", cex.lab = 1.2, cex.axis = .8, cex.main = 1.4 )
hist(y$partic, xlab="X axis title", ylab="y axis title", main="chart title", cex.lab = 1.2, cex.axis = .8, cex.main = 1.4 )
hist(y$parttime, xlab="X axis title", ylab="y axis title", main="chart title", cex.lab = 1.2, cex.axis = .8, cex.main = 1.4 )

# An example of more interesting things you can do with R graphics, this example illustrates the use of the pairs function
# in base graphics, and it creates a correlation plot in the lower triangle, and correlation coefficients in the upper
# triange, where the font size is proportional to the size of the association

# what is practically important to note here is the par functionality.  

# function from: https://www.r-bloggers.com/scatterplot-matrices-in-r/ 
# panel.cor will compute  correlation and put in upper panels, size proportional to correlation 
panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...) 
 { 
   usr <- par("usr"); on.exit(par(usr)) 
   par(usr = c(0, 1, 0, 1)) 
   r <- abs(cor(x, y)) 
   txt <- format(c(r, 0.123456789), digits=digits)[1] 
   txt <- paste(prefix, txt, sep="") 
   if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt) 
       text(0.5, 0.5, txt, cex = cex.cor * r) 
    } 

dev.off

pairs(~year + partic + tfr + menwage + womwage + debt +  parttime,  
      data=y, 
      lower.panel=panel.smooth,  
      upper.panel=panel.cor,  
      pch=20,  
      main="Correlation Among Variables in Canadian Earnings Data") 


# output file to image in the current working directory 

jpeg(filename = "corrplot.jpg", width = 1200, height = 916, units = "px", pointsize = 12) 
 
# scatter plot matrix, one of many possible ways to implement this. 
pairs(~year + partic + tfr + menwage + womwage + debt +  parttime,  
       data=y, 
       lower.panel=panel.smooth,  
       upper.panel=panel.cor,  
       pch=20,  
       main="Correlation Among String Distance Measures") 
 

dev.off() 


##  additional helpful examples here: http://www.statmethods.net/advgraphs/layout.html

#######################################################################


# simple examples as references to get started: 
# clear plot memory as par will be retained....


#Barplot

barplot(y$womwage, col = "blue", main="Average Weekly Wage for Women in canada (1946-1975)", xlab = "Year" ,
        ylab = "Canadian Dollars")

#Scatterplot
plot(y$womwage, y$menwage, col="red", pch = 15, 
        main="Average Weekly Wage for Men and Women in canada (1946-1975)", xlab = "Women's Average Weekly Wage" ,
        ylab = "Men's Average Weekly Wage")


# line plots
plot(y$year, y$womwage, type="n", main="Average Weekly Wage for Women in canada (1946-1975)") 
lines(y$year, y$womwage, type="l") 

# points and lines
plot(y$year, y$womwage, type="n", main="Average Weekly Wage for Women in canada (1946-1975)") 
lines(y$year, y$womwage, type="o") 

# points joined by lines
plot(y$year, y$womwage, type="n", main="Average Weekly Wage for Women in canada (1946-1975)") 
lines(y$year, y$womwage, type="b") 

# stair step
plot(y$year, y$womwage, type="n", main="Average Weekly Wage for Women in canada (1946-1975)") 
lines(y$year, y$womwage, type="s") 

# histogram / vertical   (more useful when combined with PAR for EDA)
plot(y$year, y$womwage, type="n", main="Average Weekly Wage for Women in canada (1946-1975)") 
lines(y$year, y$womwage, type="h") 


# see the following for some good examples, you can generally find a template
# that will allow you to visualize what you want, and most have good comments.

# http://www.harding.edu/fmccown/r/
# http://stats.idre.ucla.edu/r/modules/exploring-data-with-graphics/

# one of the best resources is the following: 
# http://www.r-graph-gallery.com/

# http://www.r-graph-gallery.com/130-ring-or-donut-chart/
# example number 130, ring graph, with explanation, uses a function to compute the math and fill areas
# you call the function with the single line below.

# The doughnut function permits to draw a donut plot
doughnut <-
  function (x, labels = names(x), edges = 200, outer.radius = 0.8, 
            inner.radius=0.6, clockwise = FALSE,
            init.angle = if (clockwise) 90 else 0, density = NULL, 
            angle = 45, col = NULL, border = FALSE, lty = NULL, 
            main = NULL, ...)
  {
    if (!is.numeric(x) || any(is.na(x) | x < 0))
      stop("'x' values must be positive.")
    if (is.null(labels))
      labels <- as.character(seq_along(x))
    else labels <- as.graphicsAnnot(labels)
    x <- c(0, cumsum(x)/sum(x))
    dx <- diff(x)
    nx <- length(dx)
    plot.new()
    pin <- par("pin")
    xlim <- ylim <- c(-1, 1)
    if (pin[1L] > pin[2L])
      xlim <- (pin[1L]/pin[2L]) * xlim
    else ylim <- (pin[2L]/pin[1L]) * ylim
    plot.window(xlim, ylim, "", asp = 1)
    if (is.null(col))
      col <- if (is.null(density))
        palette()
    else par("fg")
    col <- rep(col, length.out = nx)
    border <- rep(border, length.out = nx)
    lty <- rep(lty, length.out = nx)
    angle <- rep(angle, length.out = nx)
    density <- rep(density, length.out = nx)
    twopi <- if (clockwise)
      -2 * pi
    else 2 * pi
    t2xy <- function(t, radius) {
      t2p <- twopi * t + init.angle * pi/180
      list(x = radius * cos(t2p), 
           y = radius * sin(t2p))
    }
    for (i in 1L:nx) {
      n <- max(2, floor(edges * dx[i]))
      P <- t2xy(seq.int(x[i], x[i + 1], length.out = n),
                outer.radius)
      polygon(c(P$x, 0), c(P$y, 0), density = density[i], 
              angle = angle[i], border = border[i], 
              col = col[i], lty = lty[i])
      Pout <- t2xy(mean(x[i + 0:1]), outer.radius)
      lab <- as.character(labels[i])
      if (!is.na(lab) && nzchar(lab)) {
        lines(c(1, 1.05) * Pout$x, c(1, 1.05) * Pout$y)
        text(1.1 * Pout$x, 1.1 * Pout$y, labels[i], 
             xpd = TRUE, adj = ifelse(Pout$x < 0, 1, 0), 
             ...)
      }
      ## Add white disc          
      Pin <- t2xy(seq.int(0, 1, length.out = n*nx),
                  inner.radius)
      polygon(Pin$x, Pin$y, density = density[i], 
              angle = angle[i], border = border[i], 
              col = "white", lty = lty[i])
    }
    
    title(main = main, ...)
    invisible(NULL)
  }


# Let's use the function, we simply call it by passing in some data and letting it do it's thing
# note that inner.radius controls the width of the ring!

# verbatim from the web page

#         Data points    donut hole size            colors to use in graphing
doughnut( c(3,5,9,12) , inner.radius=0.5, col=c("lightgreen","pink","lightblue","goldenrod") )

doughnut( c(3,5,9,12) , inner.radius=0.5, col=c(rgb(0.2,0.2,0.4,0.5), rgb(0.8,0.2,0.4,0.5), rgb(0.2,0.9,0.4,0.4) , rgb(0.0,0.9,0.8,0.4)) )

# using the same method but changing the colors
doughnut( c(3,5,9,12) , inner.radius=0.5, col=rainbow(4, s=1, v = 1, alpha = .75) )

# just a bit more complicated, using the 508 compliant color scheme
color_scheme_508 <-  palette(c(rgb(0,0,0, maxColorValue=255),
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


# and then calling the function in the same way...
n=4
doughnut( c(3,5,9,12) , inner.radius=0.5, col=color_scheme_508[n:(n+3)] )

# you can try modifying the function with the following: just replace the title line in the function 
# with the following.  note that you will need to rerun the code for the function so that R has the
# latest version of the code you want to use.  Also be sure to look at the output in the console
# window to be sure that your function code was processed without issues.  For people with 
# programming experience, this is very similar to "compiling" your code.

title(main = "Sample Ring Plot", cex.main = 1.3, cex.lab = 1.2)
legend("topleft", legend=c("Group 1","Group 2","Group 3","Group 4"), ncol = 1,  inset = c(.2,0), title="Legend", cex=.7, lwd=c(6,6), col=
         c(rgb(255,109,182, maxColorValue=255),
           rgb(255,182,219, maxColorValue=255),
           rgb(73,0,146, maxColorValue=255),
           rgb(0,109,219, maxColorValue=255) ) )
         
## and then call the plot with this....the color scheme for the legend is defined in the function now.

n=4
doughnut( c(3,5,9,12) , inner.radius=0., col=color_scheme_508[n:(n+3)] )   
          

          
          
          