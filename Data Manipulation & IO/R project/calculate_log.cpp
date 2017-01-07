#include <Rcpp.h>
#include <cmath>
using namespace Rcpp;

// [[Rcpp::export]]
double calculate_log(double x) {
  double l = log(x);
  return l;
}
