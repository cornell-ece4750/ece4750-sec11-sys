//========================================================================
// ubmark-accumulate
//========================================================================

#include "ubmark-accumulate.h"

int ubmark_accumulate( int* src, int size )
{
  int sum = 0;
  for ( int i = 0; i < size; i++ )
    sum += src[i];
  return sum;
}

