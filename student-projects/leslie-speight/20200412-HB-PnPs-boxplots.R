# title: help Leslie make boxplots for pNpS data
# author: Bin He
# date: 2020-04-12
# data: toy data from Leslie

# load required libraries
library(tidyverse)

# import data
dat <- read_tsv("PnPs_results.txt", col_types = "cfcddd")

# plotting
# goal: boxplot to show the distribution of pn/ps ratios
dat %>% ggplot(aes(x = Histone, y = pn_ps, color = Ploidy)) + geom_boxplot()
