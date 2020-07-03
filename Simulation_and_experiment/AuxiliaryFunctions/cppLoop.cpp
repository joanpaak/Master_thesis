#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double cppLoop(NumericMatrix p, NumericVector w, int N) {
  
  double newEntropy = 0;
  
  for(int i = 0; i < N; i++){
    newEntropy += -sum(p(i,_) * log(p(i,_))) * w[i]; 
  }
  return newEntropy;
}

