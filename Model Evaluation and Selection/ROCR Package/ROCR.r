# install.packages("ROCR")
###====利用 ROCR 包画 P-R图和 ROC曲线=====
# https://hopstat.wordpress.com/2014/12/19/a-small-introduction-to-the-rocr-package/
library(ROCR)
##===Simple example: one set of prediction and labels====
data(ROCR.simple)
head(cbind(ROCR.simple$predictions, ROCR.simple$labels), 5)

pred <- prediction(ROCR.simple$predictions, ROCR.simple$labels)
class(pred)
slotNames(pred)
sn = slotNames(pred)
sapply(sn, function(x) length(slot(pred, x)))
sapply(sn, function(x) class(slot(pred,x)))

# pred的计算过程其实是将prediction的值从大到小排序，依次算作正样本，然后计算各个指标的数值，通过下列代码可以直观地看出
pred
ROCR.simple.dataframe <- as.data.frame(ROCR.simple$predictions)
ROCR.simple.dataframe[,2] <-as.data.frame(ROCR.simple$labels)

# plot ROC curve
roc.perf <- performance(pred,"tpr","fpr")
plot(roc.perf)
abline(a=0, b= 1)

##====Example: multiple sets of prediction and labels====
data(ROCR.hiv)
manypred = prediction(ROCR.hiv$hiv.nn$predictions, ROCR.hiv$hiv.nn$labels)
sapply(sn, function(x) length(slot(manypred, x)))
sapply(sn, function(x) class(slot(manypred, x)))
many.roc.perf = performance(manypred, measure = "tpr", x.measure = "fpr")
plot(many.roc.perf, col=1:10)
abline(a=0, b= 1)

##===Getting an “optimal” cut point in ROC curve====
# This cut point is “optimal” in the sense it weighs both sensitivity and specificity equally. 
opt.cut = function(perf, pred){
  cut.ind = mapply(FUN=function(x, y, p){
    d = (x - 0)^2 + (y - 1)^2
    ind = which(d == min(d))
    c(sensitivity = y[[ind]], specificity = 1-x[[ind]], 
      cutoff = p[[ind]])
  }, perf@x.values, perf@y.values, pred@cutoffs)
}
# 输出 ROC 曲线的cutoff，其中pred@cutoffs的数值是 prediction score的降序排列
print(opt.cut(roc.perf, pred))

##===Different costs for FP and FN=====
cost.perf = performance(pred, "cost", cost.fp = 2, cost.fn = 1)
pred@cutoffs[[1]][which.min(cost.perf@y.values[[1]])]
plot(cost.perf)
# The code is the same for the optimal cutoff for the multiple prediction data
print(opt.cut(many.roc.perf, manypred))

#===Accuracy=====
acc.perf = performance(pred, measure = "acc")
plot(acc.perf)
# 获取最大的 accuracy 及其对应的 cutoff
ind = which.max(slot(acc.perf, "y.values")[[1]])
acc = slot(acc.perf, "y.values")[[1]][ind]
cutoff = slot(acc.perf, "x.values")[[1]][ind]
print(c(accuracy= acc, cutoff = cutoff))
# Example: multiple sets of prediction and label. see the reference http

#===Area under the curve (AUC) and partial AUC (pAUC)====
auc.perf = performance(pred, measure = "auc")
auc.perf@y.values
# As before, if you only want to accept a fixed FPR, we can calculate a partial AUC
pauc.perf = performance(pred, measure = "auc", fpr.stop=0.1)
pauc.perf@y.values
# there is no “one” cutoff for AUC or pAUC, as it measures the performance over all cutoffs.


