# Load libraries
install.packages("emojifont")
install.packages("tidyverse")
library(tidyverse)
library(emojifont)
library(devtools)
tidyverse_update()
install.packages("tibble")
devtools::install_github("liamgilbey/ggwaffle")
library(ggwaffle)

# Load data
coast_vs_waste <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/coastal-population-vs-mismanaged-plastic.csv") %>% 
  rename(country = 1, code = 2, year = 3, plastic_waste = 4, coastal_pop = 5, population = 6)

# Select data for the Netherlands as comparison value
divide_by = coast_vs_waste %>% 
  filter(year == 2010, country == "Netherlands") %>% 
  select(plastic_waste)

# Select top 5 countries, divide by amount of plastic waste in the Netherlands
waste = coast_vs_waste %>% 
  filter(year==2010, !is.na(plastic_waste), country != "World") %>% 
  select(country, plastic_waste) %>% 
  mutate(plastic_waste = plastic_waste / divide_by$plastic_waste) %>%
  arrange(desc(plastic_waste)) %>% 
  slice(1:5)

# Get data in right shape for waffle charts
waffle_data <- waffle_iron(waste_countries, aes_d(group = country), rows = 15) %>% 
  mutate(label = fontawesome('fa-shopping-bag')) %>% 
  mutate(group = factor(rep(waste$country, waste$plastic_waste), levels=waste$country))

waffle_data <- waffle_iron(waste_countries, aes_d(group = country), rows = 15) %>% 
  mutate(label = fontawesome('fa-shopping-bag'))

# Make waffle chart!
ggplot(waffle_data, aes(x, y, colour = group)) + 
  geom_text(aes(label=label), family='fontawesome-webfont', size=5) +
  geom_point(size=0) +
  coord_equal() + 
  scale_y_continuous(breaks = seq(5.5, 10.5, 5)) +
  scale_x_continuous(breaks = seq(5.5, 40.5, 5), expand = c(0.015,0.015)) +
  scale_colour_brewer(palette = "Set2", guide=guide_legend(keywidth = 7, keyheight = 0.5, label.position = "bottom", label.hjust = 0.5, override.aes = list(size=10))) +
  labs(title = "Top 5 countries with most mismanaged plastic waste (2010)",
       subtitle = "\nOne plastic bag = 27,700 tonnes mismanaged plastic waste\n(amount produced in the Netherlands in 2010)\n",
       y="", x="", color="",
       caption="\n\nSource: Our world in data, plot by @veerlevanson\t") + 
  theme_waffle()  +
  theme(legend.position = "bottom",
        legend.key = element_rect(fill = "white"),
        legend.text = element_text(size = 16, hjust = 1),
        text=element_text(family="Roboto"),
        plot.title = element_text(size=26, hjust = 0),
        plot.subtitle = element_text(size=18, hjust = 0),
        panel.grid = element_line(colour = "grey"),
        panel.grid.minor = element_blank(),
        plot.caption = element_text(size = 16, hjust = 1),
        plot.margin = unit(c(0.5, 1.5, 0.5, 1.5), "cm")
  )

