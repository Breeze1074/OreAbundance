library(rbedrock)
library(tidyverse)
dbpath <- "../worldData/world_1638586699/"
db <- bedrockdb(dbpath)
keys <- get_keys(db)
chunkKeys <- parse_chunk_keys(keys)
chunks <- chunkKeys %>% filter(tag == "ChunkVersion") %>% select(2,3,4) %>%
  filter(dimension == 0) %>% slice_sample(n = 1000)
blocks <- get_chunk_blocks_data(db, chunks$x, chunks$z, chunks$dimension, names_only=TRUE)
close(db, compact = FALSE)
pos <- map_dfr(blocks, locate_blocks, "_ore") %>% 
  mutate(ore = str_remove_all(block, "minecraft:|lit_|deepslate_"))

cols <- c(
  "emerald_ore" = "green3",
  "coal_ore" = "gray10",
  "copper_ore" = "orangered2",
  "iron_ore" = "bisque3",
  "gold_ore" = "goldenrod3",
  "diamond_ore" = "turquoise1",
  "redstone_ore" = "red3",
  "lapis_ore" = "darkblue"
)

pos %>%
  separate(.,
           col = block,
           into = c("drop", "block"),
           sep = "minecraft:") %>%
  select(-drop) %>%
  filter(str_detect(ore, "ore")) %>%
  ggplot(., aes(y = y, color = ore, fill  = ore)) +
  geom_histogram(binwidth = 1, alpha = 0.5) +
  theme_minimal(base_size = 21) +
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 14),
        axis.text.y = element_text(size = 12)
  ) +
  ylab("y-level") + xlab("ore abundance") +
  labs(title = "Ore distribution in 1000 chunks from 'peak' biomes", 
       subtitle = "Minecraft Bedrock: seed 1638586699",
       caption = "Analysis by Breeze1074") +
  scale_colour_manual(values = cols) + scale_fill_manual(values = cols) + 
  facet_wrap(~ ore, scale = "free") 

ggsave(
  filename = "images/oreDistributions_1638586699.png",
  height = 2560, width = 2560, units = "px", bg  = "white", dpi = 300
)