library(tidyverse)
library(gganimate)

sigmoid <- function(x_from, x_to, y_from, y_to, scale = 5, n = 100) {
  x <- seq(-scale, scale, length = n)
  y <- exp(x) / (exp(x) + 1)
  tibble(x = (x + scale) / (scale * 2) * (x_to - x_from) + x_from,
         y = y * (y_to - y_from) + y_from)
}

n_points <- 400
data <- tibble(from = rep(4, n_points),
               to = sample(1:4, n_points, TRUE),
               color = sample(c("A", "B"), n_points, TRUE)) 

sigmoid(0, 1, as.numeric(data[2, 1]), as.numeric(data[2, 2]), 
        n = 100, scale = 10) %>%
  ggplot(aes(x, y)) +
  geom_point()

p <- sigmoid(0, 1, as.numeric(data[2, 1]), as.numeric(data[2, 2]),
             n = 100, scale = 10) %>%
  mutate(time = row_number()) %>%
  ggplot(aes(x, y, frame = time)) +
  geom_point()

gganimate(p)