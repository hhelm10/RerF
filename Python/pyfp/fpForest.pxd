# distutils: language = c++
# cython: language_level=3

from libcpp.vector cimport vector
from libcpp.string cimport string


cdef extern from "../../src/packedForest/src/packedForest.h" namespace "fp":
    cdef cppclass fpForest[double]:
        fpForest() except +

        inline void setParamString(const string& parameterName, const string& parameterValue)
        # inline void setParamDouble(const string& parameterName, const float parameterValue)
        # inline void setParamInt(const string& parameterName, const int parameterValue)
        # inline void printParameters()
        # inline void printForestType()
        # void growForest()
        # inline int predict(vector[float] observation)
        # double testAccuracy()


# cdef fpForest[double] *forest = new fpForest[double]()