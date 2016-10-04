rm(list=ls())
library(statnet)
data(florentine)
gplot(flomarriage)
plot(flobusiness)

## we want to test if there is a significant correlation between marriage and business ties. 
## We will use QAP to determine this.
G = array(dim=c(16,16,2))
G[,,1] = as.matrix(flomarriage)
G[,,2] = as.matrix(flobusiness)
Q = qaptest(G,gcor,g1=1,g2=2)
summary(Q)
plot(Q)

##==baseline model=====
# We will start by creating a predictive model based on the edge density. 
# The format of the ergm command is ergm(YourNetwork ~ Signature1 + Signature2 + ...)  
# where “YourNetwork” is a graph object, and the “Signatures” are aspects of the network. 
# Note that the command format is similar to regression commands in R
flo.mar.1 <- ergm(flomarriage ~ edges)
flo.mar.1
summary(flo.mar.1)
exp(-1.609)  # 两点之间有边和无边的比例,odd ratio
exp(-1.609) / (1+exp(-1.609)) # 有边的概率，即等于20/120

# Now, add the covariate “triangles” to the model.
summary(flomarriage ~ edges + triangles)
flo.mar.2 <- ergm(flomarriage ~ edges + triangles, seed=1)    	 
flo.mar.2
summary(flo.mar.2)
# 目标不是预测边或者三角形的概率，而是预测网络形态的概率
exp(0.1584)
exp(-1.6794+0.1584)  # 考虑破坏三角形少了一条边


flo.bus.1 <- ergm(flobusiness ~ edges)
flo.bus.1  # 图更稀疏，负值更大？
flo.bus.2 <- ergm(flobusiness ~ edges + triangles) # 不收敛

## Let's run a model checking whether edges in the Florentine business network are predicted by edges in the marriage network. To do that, we can use an edge covariate parameter edgecov(). As in: ergm(MyNetwork ~ Signature1 + Signature2 + ... + edgecov(AnotherNetwork)). 
flo.mar.3 <- ergm(flobusiness ~ edges + edgecov(flomarriage))       
flo.mar.3
exp(2.18)  # 有姻亲关系的家族是没有的家族发生 business 的概率的8倍
summary(flo.mar.3)

## Now, run the ERGM model to test the hypothesis that wealthy families tend to form ties. Note the use of the nodecov (node covariate) function.
flo.mar.4 <- ergm(flomarriage ~ edges + nodecov("wealth"))       
flo.mar.4
summary(flo.mar.4)
exp(0.01*10) # 财富增加10个单位

## 财富差距
flo.mar.5 <- ergm(flomarriage ~ edges + absdiff("wealth"))       
flo.mar.5
summary(flo.mar.5)

## 上一个模型其实是不对的，还要考虑每一家的财富情况
flo.mar.6 <- ergm(flomarriage ~ edges + nodecov("wealth") + absdiff("wealth"))       
flo.mar.6
summary(flo.mar.6)

## 控制网络的结构，探究其他变量对 DV 的影响
## edge 作为 baseline，非常重要
flo.mar.7 <- ergm(flomarriage ~ edges + kstar(2)+ triangle + nodecov("wealth"))  
summary(flo.mar.7)

# After estimating parameters for your mode, you want to know how well it fits the observed data. 
# We will use a goodness of fit procedure to generate a probability distribution for the degree 
# distribution of a graph, and compare it to the observed instance. Check the goodness of fit for the degree:
flo.mar.4.gof <- gof(flo.mar.4 ~ degree)
flo.mar.4.gof
# Plot the goodness of fit. Save a copy for your report. 
# 如何按照模型随机生成的图形和原图形相似，均值落在置信区间内，则结果较好
plot(flo.mar.4.gof)


# We can also check how good a fit the model is for other network characteristics. 
# In this case, we will use geodesic distance, or the shortest path length between nodes in the network. 
# The goodness of fit test will simulate 20 networks and compare the results to the realized network.
flo.mar.4.gof2 <- gof(flo.mar.4 ~ distance, nsim=20) # gof based on 20 simulated nets
summary(flo.mar.4.gof2)
plot(flo.mar.4.gof2)

# Note we can't get (and don't need) these diagnostics for flo.mar.4 
# since it was not estimated using MCMC. This is because it was simple enough 
# (i.e. a dyadic independence model) that we did not need MCMC estimation. 
# However, our edge-triangle model did. Run the following commands. 
# To view the plots better, try saving as a pdf (include the images in your report).
# Use only this if you want R images
mcmc.diagnostics(flo.mar.2)  
# Generate pdf
pdf("flo_mar_model2.pdf")
mcmc.diagnostics(flo.mar.2)  
dev.off()

install.packages("niitr")



