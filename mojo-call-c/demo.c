#include <stdio.h>

double array_max(double* input, size_t nelem) {
  double max = 0;
  for (size_t i = 0; i < nelem; i++) {
    if (input[i] > max) {
      max = input[i];
    }
  }
  return max;
}