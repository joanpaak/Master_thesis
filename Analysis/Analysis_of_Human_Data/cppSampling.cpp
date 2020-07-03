#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
int getMultinomialRandom(NumericVector p, double s) {
  
  double q = p[0];
  
  if(s < q) return 1;
  
  q += p[1];
  
  if(s < q) return 2;
  
  q += p[2];
  
  if(s < q) return 3;
  
  q += p[3];
  
  if(s < q) return 4;
  
  return -1;
}

// [[Rcpp::export]]
NumericVector getResponseCategories(NumericMatrix probs) {
// probs : matrix in which each row is length of 4 and sums to 1.

  int N = probs.nrow();
  NumericVector s = runif(N);
  NumericVector r(N);
  
  for(int i = 0; i < N; i++){
    r[i] = getMultinomialRandom(probs.row(i), s[i]);
  }
  
  return r;
}



