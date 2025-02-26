remotes::install_github("paulc91/waffle", ref = "1.0.0")

library(tidyverse)
library(waffle)

storms %>% 
  filter(year >= 2010) %>% 
  count(year, status) -> storm_df

ggplot(storm_df, aes(fill=status, values=n)) + 
  geom_waffle(color = "white", size=.25, n_rows = 10, flip = T, show.legend = T) +
  facet_wrap(~year, nrow=1, strip.position = "bottom") +
  scale_x_discrete(expand=c(0,0)) +
  scale_y_continuous(breaks = function(x) seq(5, max(x), by = 5), 
                     labels = function(x) x * 10, # make this multiplyer the same as n_rows
                     expand = c(0,0)) +
  ggthemes::scale_fill_tableau(name=NULL) +
  coord_equal() +
  labs(
    title = "Faceted Waffle Bars",
    subtitle = "Storms Data",
    x = "Year",
    y = "Count"
  ) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.ticks.y = element_line()) +
  guides(fill = guide_legend(reverse = T))
