#############################################################################
#                                                                           #
# Social Network Analysis - Lab 2 Sample Script                             #
#                                                                           #
#############################################################################


#
# The Basics - Loading data and visualization
#

# Make sure the igraph package is installed and unpacked
install.packages("igraph")
library(igraph)

# Set your working directory to your desktop. 
# This is where you should save you graph files.
setwd("~/Desktop")

# Upload the graph downloaded from the internet - note the graphml format
# please make sure to use your correct file extension!
g<-read.graph("Gmail_CLEAN.graphml",format="graphml")

# Visualize network
plot(g,layout=layout.fruchterman.reingold,vertex.label=V(g)$name,vertex.size=4)

#
# Quantitative Analysis - Basic Metrics
#

# Compute degrees (in/out) and centrality
indegree<-degree(g,mode="in")
table(degree(g,mode="in"))
hist(degree(g,mode="in"))
logindegree <- log(indegree+1)
plot(g,layout=layout.fruchterman.reingold,vertex.label="",vertex.size=logindegree)


outdegree<-degree(g,mode="out")
b<-betweenness(g)
c<-closeness(g)

# Determine the index of max in-degree and out-degree. Refer to root file to 
# find the name of this index
match(max(indegree),indegree)
match(max(outdegree),outdegree)

# Find sites that are most central
match(max(b),b)
match(min(c),c)

# Find the connected components (or clusters) in the graph
comps <- clusters(g)
colbar <- rainbow(max(comps$membership)+1) # add coloration
V(g)$color <- colbar[comps$membership+1]

# Visualize the components
plot(g, layout=layout.fruchterman.reingold, vertex.size=4, vertex.label=V(g)$name, vertex.label.font=1, vertex.label.cex=0.4)

# Visualize the degree distribution of the graph
dd <-degree.distribution(g, cumulative = FALSE) 
plot(dd)

# Determine the density of the network
d = graph.density(g)

# Average clustering coefficient - "transitivity" in this package 
transitivity(g, type=c("average")) 

#
# Simulation
#

# Create a new directed graph that is simulated based on the transitivity you calculated for your
# graph; note that the transitivity variable is reused here
g2 <- erdos.renyi.game(100, d, directed = TRUE)
plot(g2)

# We want to simulate 10 graphs and record their average clustering coefficients.
# To do this, you can create 10 graphs manually, or set up a loop
avg_cluster_coeff <- rep(0,10) # generates empty array
for (i in seq(1,10)){
	g_sim <- erdos.renyi.game(100, d, directed = TRUE)	# new simulated graph
	avg_cluster_coeff[i] <- transitivity(g_sim, type=c("average"))	# store the avg clustering coeff
}
mean(avg_cluster_coeff)
