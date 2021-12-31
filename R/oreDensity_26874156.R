#############################################################
# Author CrazyBreeze1074
#############################################################

library(tidyverse)
library(rbedrock)

blocks <- readRDS("../worldData/allOres.RDS")

cols <- c(
  "emerald_ore" = "green3",
  "coal_ore" = "gray10",
  "copper_ore" = "orangered2",
  "iron_ore" = "bisque3",
  "gold_ore" = "goldenrod3",
  "diamond_ore" = "turquoise1",
  "redstone_ore" = "red3",
  "lapis_ore" = "darkblue",
  "deepslate_emerald_ore" = "green3",
  "deepslate_coal_ore" = "gray10",
  "deepslate_copper_ore" = "orangered2",
  "deepslate_iron_ore" = "bisque3",
  "deepslate_gold_ore" = "goldenrod3",
  "deepslate_diamond_ore" = "turquoise1",
  "deepslate_redstone_ore" = "red3",
  "deepslate_lapis_ore" = "darkblue"
)

cols_deep <- c(
  "deepslate_emerald_ore" = "green3",
  "deepslate_coal_ore" = "gray10",
  "deepslate_copper_ore" = "orangered2",
  "deepslate_iron_ore" = "bisque3",
  "deepslate_gold_ore" = "goldenrod3",
  "deepslate_diamond_ore" = "turquoise1",
  "deepslate_redstone_ore" = "red3",
  "deepslate_lapis_ore" = "darkblue"
)

oredering1 <-
  blocks %>%
  slice_sample(prop = 1000 / 172042) %>%
  mutate(ore = str_remove_all(block, "minecraft:|lit_|deepslate_")) %>%
  distinct(ore) %>% pull(1) %>% sort()

oredering2 <-
  blocks %>%
  slice_sample(prop = 1000 / 172042) %>%
  mutate(ore = str_remove_all(block, "minecraft:|lit_")) %>%
  filter(str_detect(ore, "deepslate")) %>%
  distinct(ore) %>% pull(1) %>% sort()

oredering <- c(oredering1, oredering2)

violinsReg <-
  blocks %>%
  mutate(ore = str_remove_all(block, "minecraft:|lit_")) %>%
  group_by(ore, y) %>%
  mutate(ore = factor(ore, oredering)) %>%
  filter(str_detect(ore, "deepslate_", negate = TRUE) & y > -7) %>% #pull(y) %>% table
  ggplot(aes(
    x = ore,
    y = y,
    color =  ore,
    fill = ore
  )) +
  geom_violin() +
  scale_fill_manual(values = cols) +
  scale_color_manual(values = cols) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none", 
        panel.grid.major = element_line(size = 0.5, colour = "gray"),
        panel.grid.minor = element_line(size = 0.5, colour = "gray"),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)
  ) + 
  labs(title = "Normal ore abundance in 172042 chunks", 
       subtitle = "Minecraft Bedrock: seed 26874156",
       caption = "Analysis by Breeze1074") + 
  xlab(NULL) +
  ylab("Ore distribution (y-level)")

ggsave(
  filename = "../images/regularOreViolins_1.18.2.03.png", bg = "white",
  height = 7, width = 7, units = "in", dpi = 300
)

violinsDeep <-
  blocks %>%
  mutate(ore = str_remove_all(block, "minecraft:|lit_")) %>%
  group_by(ore, y) %>%
  mutate(ore = factor(ore, oredering)) %>%
  filter(str_detect(ore, "deepslate_") & y < 1) %>%
  ggplot(aes(
    x = ore,
    y = y,
    color =  ore,
    fill = ore
  )) +
  geom_violin() +
  scale_fill_manual(values = cols_deep) +
  scale_color_manual(values = cols_deep) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none", 
        panel.grid.major = element_line(size = 0.5, colour = "gray"),
        panel.grid.minor = element_line(size = 0.5, colour = "gray"),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)
  ) +
  labs(title = "Deepslate ore abundance in 172042 chunks", 
       subtitle = "Minecraft Bedrock: seed 26874156",
       caption = "Analysis by Breeze1074") + 
  xlab(NULL) +
  ylab("Ore distribution (y-level)")

ggsave(
  filename = "../images/deepslateOreViolins_1.18.2.03.png", bg = "white",
  height = 7, width = 7, units = "in", dpi = 300
)

violinsPooled <-
  blocks %>%
  mutate(ore = str_remove_all(block, "minecraft:|lit_|deepslate_")) %>%
  group_by(ore, y) %>%
  mutate(ore = factor(ore, oredering)) %>%
  ggplot(aes(
    x = ore,
    y = y,
    color =  ore,
    fill = ore
  )) +
  geom_violin() +
  scale_fill_manual(values = cols) +
  scale_color_manual(values = cols) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none", 
        panel.grid.major = element_line(size = 0.5, colour = "gray"),
        panel.grid.minor = element_line(size = 0.5, colour = "gray"),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)
  ) +
  labs(title = "Pooled ore abundance in 172042 chunks", 
       subtitle = "Minecraft Bedrock: seed 26874156",
       caption = "Analysis by Breeze1074") + 
  xlab(NULL) +
  ylab("Ore distribution (y-level)") + 
  scale_y_continuous(breaks = scales::pretty_breaks(n = 40))

ggsave(
  filename = "../images/oreCompositeViolins_1.18.2.03.png", bg = "white",
  height = 13, width = 7, units = "in", dpi = 300
)
