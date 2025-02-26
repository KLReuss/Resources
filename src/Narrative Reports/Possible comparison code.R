tidy_both <- bind_rows(
  mutate(tidy_reportSD, state = "South Dakota"),
  mutate(tidy_reportWA, state = "Washington"))
frequency <- tidy_both %>%
  mutate(word = str_extract(word, "[a-z]+")) %>%
  count(state, word) %>%
  rename(other = n) %>%
  inner_join(count(tidy_reports, word)) %>%
  rename(USA = n) %>%
  mutate(other = other / sum(other),
         USA = USA / sum(USA)) %>%
  ungroup()



library(scales)
ggplot(frequency, aes(x = other, y = Austen, color = abs(Austen - other))) +
  geom_abline(color = "gray40") +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.4, height = 0.4) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme_minimal(base_size = 14) +
  theme(legend.position="none") +
  labs(title = "Comparing Word Frequencies",
       subtitle = "Word frequencies in Jane Austen's texts are closer to the Brontë sisters' than to H.G. Wells'",
       y = "Jane Austen", x = NULL)