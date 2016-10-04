require(MASS)
require(xlsx)
require(nnet)
require(stringr)

# ==Input and proprocessing=======
data <- read.xlsx2("Index Data.xls", sheetIndex=2, header=TRUE)
str(data)

data$"账户类别" <- ifelse(data$"账户类别" == "对私",1,0)
table(data$"账户类别")

for(i in 2:38){
  data[,i] <- as.character(data[,i])
}

for(i in 1:length(data[,1])){
  data[i,11] <- as.numeric(str_replace(data[i,11],"%",""))/100
  data[i,13] <- as.numeric(str_replace(data[i,13],"%",""))/100
  data[i,15] <- as.numeric(str_replace(data[i,15],"%",""))/100
  data[i,25] <- as.numeric(str_replace(data[i,25],"%",""))/100
  data[i,27] <- as.numeric(str_replace(data[i,27],"%",""))/100
}

dummy_mcc <- class.ind(data$"商户MCC")

for(i in 2:38){
  data[,i] <- as.numeric(data[,i])
}

combine <- cbind(data[,2:28], dummy_mcc[,1:7])
set.seed(123)
random_sample <- sample(1:length(data[,1]), size=length(data[,1])*0.8)
train <- combine[random_sample,]
test <- combine[-random_sample,]

# ==Logit model======
train$"商户危险等级" <- ifelse(train$"商户危险等级">3,1,0)
table(train$"商户危险等级")
lm <- glm(商户危险等级 ~ ., data = train, family="binomial")
summary(lm)

# ==Logit Prediction=====
fitted.results <- predict(lm,newdata=test[,-21],type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)

test_level <- ifelse(test$"商户危险等级">3,1,0)
accuracy <- (length(fitted.results)-sum(abs(fitted.results-test_level)))/length(fitted.results)
cat("The Prediction Accuracy of Logit Model is:",accuracy)

# == Evaluation ====
library(ROCR)
predictions <- predict(lm,newdata=train[,-21],type='response')
labels <- train$"商户危险等级"
pred <- prediction(predictions,labels)
roc.perf <- performance(pred,"tpr","fpr")
plot(roc.perf)

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

# 使用 cutoff 重新预测 test
fitted.results <- predict(lm,newdata=test[,-21],type='response')
fitted.results <- ifelse(fitted.results > 0.5655412,1,0)

test_level <- ifelse(test$"商户危险等级">3,1,0)
accuracy <- (length(fitted.results)-sum(abs(fitted.results-test_level)))/length(fitted.results)
cat("The Prediction Accuracy of Logit Model is:",accuracy)

# ==Logit model 2=====
# 删减变量
train <- combine[random_sample,][,c(2,6,7,11,15,17,19,21,22,24,26,27)]
test <- combine[-random_sample,][,c(2,6,7,11,15,17,19,21,22,24,26,27)]
train$"商户危险等级" <- ifelse(train$"商户危险等级">3,1,0)
table(train$"商户危险等级")
lm <- glm(商户危险等级 ~ ., data = train, family="binomial")
summary(lm)

fitted.results <- predict(lm,newdata=test[,-8],type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)

test_level <- ifelse(test$"商户危险等级">3,1,0)
accuracy <- (length(fitted.results)-sum(abs(fitted.results-test_level)))/length(fitted.results)
cat("The Prediction Accuracy of Logit Model is:",accuracy)

predictions <- predict(lm,newdata=train[,-8],type='response')
labels <- train$"商户危险等级"
pred <- prediction(predictions,labels)
roc.perf <- performance(pred,"tpr","fpr")
plot(roc.perf)

print(opt.cut(roc.perf, pred))

# 使用 cutoff 重新预测 test
fitted.results <- predict(lm,newdata=test[,-8],type='response')
fitted.results <- ifelse(fitted.results > 0.5655412,1,0)

test_level <- ifelse(test$"商户危险等级">3,1,0)
accuracy <- (length(fitted.results)-sum(abs(fitted.results-test_level)))/length(fitted.results)
cat("The Prediction Accuracy of Logit Model is:",accuracy)

