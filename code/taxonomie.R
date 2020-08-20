# First step automated model classification

# This part will be used for assisted taxonomy creation

# Preparation step

# Loading packages
library(igraph)
library(semnet)
library(tidyverse)

# Recuperate data
data = read.csv("./syntheses/taxonomie/algo_taxonomie.csv", sep = ";")

# Adapt dataset for analysis
data_clean = data[, 4:22]
rownames(data_clean) = data[, 1]
data_clean = na.omit(data_clean)

# Classification
data_clean %>%
    as.matrix() %>% 
    heatmap(Colv = NA, scale = "none", 
        col = rev(terrain.colors(3)),
        margins = c(10, 10))
legend(x = "bottomright", legend = c("Vrai", "Sou conditions / Possible", "Faux"), 
    fill = rev(terrain.colors(3)))