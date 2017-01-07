install.packages("Rcpp")
library(Rcpp)

# Getting started with C++ ====================
cppFunction('int add(int x, int y, int z) {
  int sum = x + y + z;
  return sum;
}')
add

add(1, 2, 3)

one <- function() 1L
one()

cppFunction('int one() {
  return 1;
}')
one

one()

# Vector input, scalar output===================
sumR <- function(x) {
  total <- 0
  for (i in seq_along(x)) {
    total <- total + x[i]
  }
  total
}

cppFunction('double sumC(NumericVector x) {
  int n = x.size();
  double total = 0;
  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total;
}')
sumC
sumC(c(1,2,3,4))

# 测试速度
x <- runif(1e3)
install.packages('microbenchmark')
library(microbenchmark)
microbenchmark(
  sum(x),
  sumC(x),
  sumR(x)
)

# Matrix input, vector output=============
cppFunction('NumericVector rowSumsC(NumericMatrix x) {
  int nrow = x.nrow(), ncol = x.ncol();
  NumericVector out(nrow);
            
  for (int i = 0; i < nrow; i++) {
  double total = 0;
  for (int j = 0; j < ncol; j++) {
  total += x(i, j);
  }
  out[i] = total;
  }
  return out;
  }')

set.seed(1014)
x <- matrix(sample(100), 10)
rowSums(x)
rowSumsC(x)

# log ===============
sourceCpp("./meanC.cpp")
meanC(c(1,2,3,4))
sourceCpp('./calculate_log.cpp')
calculate_log(9)
log(9)







