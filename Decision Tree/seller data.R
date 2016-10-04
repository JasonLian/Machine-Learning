rm(list=ls())
require(xlsx)
library(xlsx)
seller <- read.xlsx2("seller data.xls",1)
str(seller)

library(MASS)
seller$MCC消费总额均值 <- as.numeric(seller$MCC消费总额均值)
model <- polr(商户危险等级~账户类别+MCC消费总额均值, data=seller, Hess=TRUE)
summary(model)

