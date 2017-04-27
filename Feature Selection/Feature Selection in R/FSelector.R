install.packages('FSelector')
library(FSelector)
##==Correlation Filter：correlation with DV=================
library(mlbench)
data(BostonHousing)
data=BostonHousing[-4] # only numeric variables
# 计算连续型因变量和其他所有变量的皮尔逊相关系数
weights <- linear.correlation(medv~., data) 
print(weights)
# 整数指定个数，小数指定比例
subset <- cutoff.k(weights, 3)
f <- as.simple.formula(subset, "medv")
print(f)
# 计算斯皮尔曼相关系数
weights <- rank.correlation(medv~., data)
print(weights)
subset <- cutoff.k(weights, 3)
f <- as.simple.formula(subset, "medv")
print(f)

##==Entropy-based filters==============
data(iris)
weights <- information.gain(Species~., iris)
print(weights)
subset <- cutoff.k(weights, 2)
f <- as.simple.formula(subset, "Species")
print(f)

weights <- information.gain(Species~., iris, unit = "log2")
print(weights)
weights <- gain.ratio(Species~., iris)
print(weights)
subset <- cutoff.k(weights, 2)
f <- as.simple.formula(subset, "Species")
print(f)

weights <- symmetrical.uncertainty(Species~., iris)
print(weights)
subset <- cutoff.biggest.diff(weights)
f <- as.simple.formula(subset, "Species")
print(f)
