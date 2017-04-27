library(data.table)
data <- read.csv("C://tianchi2/user_balance_table.csv",header = T,stringsAsFactors = F)
head(data)
data <- data[order(data$report_date),]
total_purchase <- aggregate(data$total_purchase_amt,list(data$report_date),sum)
total_redeem <- aggregate(data$total_redeem_amt,list(data$report_date),sum)
label<-total_purchase[281:427,2]
feature<-matrix(nrow = 147,ncol = 15)
for (i in 1:147){
feature[i,]<-c(total_purchase[(259+i):(272+i),2],label[i])
}
dummy<-read.csv("C://tianchi2/dummy.csv",header = T)
dataset<-read.csv("C://tianchi2/feature.csv",header = F)
dataset<-as.matrix(dataset)
label <- as.matrix(dataset[,27])
data <- as.matrix(dataset[,-27])
library(randomForest)
system.time(rf<-randomForest(data,label,ntree = 100,importance = T))
importance(rf,type = 2)
rf_pred<-predict(rf,data)
library(xgboost)
xgmat <- xgb.DMatrix(data,label = label)
param <- list(objective = 'reg:linear',max_depth = 6,silent = 0,eta = 0.03,nthread = 3,eval_metric = 'rmse')
bsti<-xgb.cv(param,xgmat,nround = 250,nfold = 5)
