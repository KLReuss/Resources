
# clean up
rm(list = ls()) 

install.packages("maps")
install.packages("ggmap")
install.packages("mapdata")


library("maps")
library("ggplot2")
library("ggmap")
library("mapdata")

states <- map_data("state")
dim(states)

usa <- ggplot(data = states) + 
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") + 
  coord_fixed(1.3) +
  guides(fill=FALSE)  # do this to leave off the color legend

usa + map.text("state", regions=c("alabama",
                            "arizona",
                            "arkansas",
                            "california",
                            "colorado",
                            "connecticut",
                            "delaware",
                            "district of columbia",
                            "florida",
                            "georgia",
                            "idaho",
                            "illinois",
                            "indiana",
                            "iowa",
                            "kansas",
                            "kentucky",
                            "louisiana",
                            "maine",
                            "maryland",
                            "massachusetts:main",
                            "michigan:north",
                            "minnesota",
                            "mississippi",
                            "missouri",
                            "montana",
                            "nebraska",
                            "nevada",
                            "new hampshire",
                            "new jersey",
                            "new mexico",
                            "new york:main",
                            "north carolina:main",
                            "north dakota",
                            "ohio",
                            "oklahoma",
                            "oregon",
                            "pennsylvania",
                            "rhode island",
                            "south carolina",
                            "south dakota",
                            "tennessee",
                            "texas",
                            "utah",
                            "vermont",
                            "virginia:main",
                            "washington:main",
                            "west virginia",
                            "wisconsin",
                            "wyoming"), labels=as.character(c(29,
                                                              38,
                                                              13,
                                                              173,
                                                              21,
                                                              12,
                                                              5,
                                                              1,
                                                              108,
                                                              59,
                                                              7,
                                                              40,
                                                              46,
                                                              3,
                                                              9,
                                                              40,
                                                              23,
                                                              8,
                                                              24,
                                                              20,
                                                              49,
                                                              9,
                                                              14,
                                                              27,
                                                              2,
                                                              4,
                                                              12,
                                                              7,
                                                              21,
                                                              12,
                                                              60,
                                                              73,
                                                              2,
                                                              108,
                                                              18,
                                                              14,
                                                              71,
                                                              1,
                                                              35,
                                                              1,
                                                              49,
                                                              117,
                                                              10,
                                                              4,
                                                              39,
                                                              27,
                                                              18,
                                                              10,
                                                              2)))
