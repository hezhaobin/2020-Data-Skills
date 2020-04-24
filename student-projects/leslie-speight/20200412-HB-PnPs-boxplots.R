# title: help Leslie make boxplots for pNpS data
# author: Bin He
# date: 2020-04-12
# data: toy data from Leslie

# load required libraries
library(tidyverse)

# import data
pnps <- read_tsv("PnPs_results.txt", col_types = "cfcddd")

# plotting
# goal: boxplot to show the distribution of pn/ps ratios
pnps %>% ggplot(aes(x = Histone, y = pn_ps, color = Ploidy)) + geom_boxplot()

# 2020-04-24 Dn_Ds
dnds <- read_tsv("DnDs_results.txt", col_types = "cicddd")
dnds <- dnds %>% mutate(
  Mode = factor(Ploidy, levels = c(2,3,4), 
                labels = c("sex","asex","asex")))
dnds %>% ggplot(aes(x = Histone, y = dn_ds, color = Mode)) + geom_boxplot()         
