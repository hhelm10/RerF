from libcpp.vector cimport vector

# cdef extern from "../../src/packedForest/src/baseFunctions/fpForest.h" namespace "fp":
cdef extern from "../../src/packedForest/src/packedForest.h" namespace "fp":
    cdef cppclass fpForest[double]:
        fpForest() except +

        void setParamString(const char* parameterName, const char* parameterValue)
        void setParamDouble(const char* parameterName, const float parameterValue)
        void setParamInt(const char* parameterName, const int parameterValue)
        void printParameters()
        # void printForestType()
        # void growForest()
        # int predict(vector[float] observation)
        # float testAccuracy()


# cdef fpForest[double] *forest = new fpForest[double]()