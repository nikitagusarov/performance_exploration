# Initiation
library(igraph)
library(semnet)
library(tidyverse)

# Data creation
data = read.csv("./data/classification/models.csv", sep = ";")



# mullainathan2017ml

# Subset
subdata = data %>%
    # filter(source == "Root" | source == "kotsiantis2006tr")
    filter(source == "Root" | source == "mullainathan2017ml")

# Nodes
nodes = subdata[, 1:6]

# Links
links = subdata[-1, 7:8]

# Network creation
net = graph_from_data_frame(
    d = links, 
    vertices = nodes, 
    directed = FALSE)

# Attributes
V(net)$size = 1 / V(net)$level
V(net)$label.cex = 2 / sqrt(V(net)$level)
V(net)$shape = "none"

# Layout
# Manual 
layout = tkplot(net) 
l = tkplot.getcoords(layout)
# Automated
# l = layout_with_lgl(net, root = 1)

# Plot results
plot(net, layout = l,
    vertex.label.color = "black")



# kotsiantis2006tr

# Subset
subdata = data %>%
    filter(source == "Root" | source == "kotsiantis2006tr")
    # filter(source == "Root" | source == "mullainathan2017ml")

# Nodes
nodes = subdata[, 1:6]

# Links
links = subdata[-1, 7:8]

# Network creation
net = graph_from_data_frame(
    d = links, 
    vertices = nodes, 
    directed = FALSE)

# Attributes
V(net)$size = 1 / V(net)$level
V(net)$label.cex = 2 / sqrt(V(net)$level)
V(net)$shape = "none"

# Layout
# Manual 
layout = tkplot(net) 
l = tkplot.getcoords(layout)
# Automated
# l = layout_with_lgl(net, root = 1)

# Plot results
plot(net, layout = l,
    vertex.label.color = "black")



# ayodele2010tml

# Subset
subdata = data %>%
    filter(source == "Root" | source == "ayodele2010tml")

# Nodes
nodes = subdata[, 1:6]

# Links
links = subdata[-1, 7:8]

# Network creation
net = graph_from_data_frame(
    d = links, 
    vertices = nodes, 
    directed = FALSE)

# Attributes
V(net)$size = 1 / V(net)$level
V(net)$label.cex = 2 / sqrt(V(net)$level)
V(net)$shape = "none"

# Layout
# Manual 
layout = tkplot(net) 
l = tkplot.getcoords(layout)
# Automated
# l = layout_with_lgl(net, root = 1)

# Plot results
plot(net, layout = l,
    vertex.label.color = "black")



# hastie2009sl_cascetta2009tr

# Subset
subdata = data %>%
    filter(source == "Root" | source == "hastie2009sl" | 
        source == "cascetta2009tr")

# Nodes
nodes = subdata[, 1:6]

# Links
links = subdata[-1, 7:8]

# Network creation
net = graph_from_data_frame(
    d = links, 
    vertices = nodes, 
    directed = FALSE)

# Attributes
V(net)$size = 1 / V(net)$level
V(net)$label.cex = 1.5 / sqrt(V(net)$level)
V(net)$shape = "none"

# Layout
# Automated
# l = layout_with_lgl(net, root = 1)
# l = layout_with_kk(net)
l = layout_with_lgl(net)
net$layout = l
net = reduceLabelOverlap(net, labeldist_coef = 3, 
    cex_from_device = F,
    label.attr = "label", 
    labelsize.attr = "label.cex")
# l = layout_with_fr(net)
# l = layout_with_dh(net)
# l = layout_with_gem(net)
# l = layout_with_graphopt(net)
# l = layout_with_mds(net)
# l = layout_nicely(net)
# Manual 
layout = tkplot(net) 
l = tkplot.getcoords(layout)

# Plot results
plot(net, layout = l,
    vertex.label.color = "black")



# hastie2009sl

# Subset
subdata = data %>%
    filter(source == "Root" | source == "hastie2009sl")

# Nodes
nodes = subdata[, 1:6]

# Links
links = subdata[-1, 7:8]

# Network creation
net = graph_from_data_frame(
    d = links, 
    vertices = nodes, 
    directed = FALSE)

# Attributes
V(net)$size = 1 / V(net)$level
V(net)$label.cex = 1.5 / sqrt(V(net)$level)
V(net)$shape = "none"

# Layout
# Automated
l = layout_with_lgl(net)
net$layout = l
net = reduceLabelOverlap(net, labeldist_coef = 3, 
    cex_from_device = F,
    label.attr = "label", 
    labelsize.attr = "label.cex")
# Manual 
layout = tkplot(net) 
l = tkplot.getcoords(layout)

# Colors
pal = rainbow(max(unique(V(net)$level)), 
    alpha = 1)
# Plot results
plot(net, layout = l,
    vertex.label.color = pal[V(net)$level])



# agresti2013cd

# Subset
subdata = data %>%
    filter(source == "Root" | source == "agresti2013cd")

# Nodes
nodes = subdata[, 1:6]

# Links
links = subdata[-1, 7:8]

# Network creation
net = graph_from_data_frame(
    d = links, 
    vertices = nodes, 
    directed = FALSE)

# Attributes
V(net)$size = 1 / V(net)$level
V(net)$label.cex = 1.5 / sqrt(V(net)$level)
V(net)$shape = "none"

# Layout
# Automated
l = layout_with_lgl(net)
net$layout = l
net = reduceLabelOverlap(net, labeldist_coef = 3, 
    cex_from_device = F,
    label.attr = "label", 
    labelsize.attr = "label.cex")
# Manual 
layout = tkplot(net) 
l = tkplot.getcoords(layout)

# Plot results
plot(net, layout = l,
    vertex.label.color = "black")