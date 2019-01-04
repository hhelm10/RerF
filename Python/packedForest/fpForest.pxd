from libcpp.vector cimport vector

cdef extern from "../../src/packedForest/src/baseFunctions/fpForest.h" namespace "fp":
    cdef cppclass fpForest[T]:
        fpForest() except +

        void setParamString(const char* parameterName, const char* parameterValue)
        void setParamDouble(const char* parameterName, const float parameterValue)
        void setParamInt(const char* parameterName, const int parameterValue)
        void printParameters()
        void printForestType()
        void growForest()
        int predict(vector[float] observation)
        float testAccuracy()