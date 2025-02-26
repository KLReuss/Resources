# clean up
rm(list = ls()) 
install.packages('ggthemes')
install.packages('rgeos')
install.packages('ggalt')
install.packages('alberusa')
install.packages('ggthemes')
devtools::install_github("hrbrmstr/albersusa")

library('ggplot2')   
library('ggalt')     # coord_proj
library('albersusa') # devtools::install_github("hrbrmstr/albersusa")
library('ggthemes')  # theme_map
library('rgeos')     # centroids
library('dplyr')

# composite map with AK & HI
usa_map <- usa_composite()

# calculate the centroids for each state
gCentroid(usa_map, byid=TRUE) %>% 
  as.data.frame() %>% 
  mutate(state=usa_map@data$iso_3166_2) -> centroids

# make it usable in ggplot2
usa_map <- fortify(usa_map)

gg <- ggplot()
gg <- gg + geom_map(data=usa_map, map=usa_map,
                    aes(long, lat, map_id=id),
                    color="#2b2b2b", size=0.1, fill=NA)
gg <- gg + geom_text(data=centroids, aes(x, y, label=state), size=2)
gg <- gg + coord_proj(us_laea_proj)
gg <- gg + theme_map()
gg