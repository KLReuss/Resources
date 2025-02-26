library(d3rain)
iris %>% 
  d3rain(x = Sepal.Length, y = Species, toolTip = Sepal.Length, title = "Sepal Length by Species") %>% 
  drip_settings(jitterWidth = 30, dripFill = 'steelblue') %>% 
  chart_settings(yAxisTickLocation = 'center')