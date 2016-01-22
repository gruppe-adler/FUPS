#define TYPEMATCH(A,B) if !(A isEqualType B) throw STRUCTUREMISMATCHEXCEPTION
#define TYPEMATCH_ARR(A,B) if !(A isEqualTypeParams B) throw STRUCTUREMISMATCHEXCEPTION

#include "area.hpp"
