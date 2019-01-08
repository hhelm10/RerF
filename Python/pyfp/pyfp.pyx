# distutils: language = c++
# cython: language_level=3

from fpForest cimport fpForest

cdef class PyFP:
    cdef fpForest c_fpForest

    def __cinit__(self):
        self.c_fpForest = fpForest()

    def setParamString(self, parameterName, parameterValue):
        self.c_fpForest.setParamString(parameterName, parameterValue)

    # def setParamDouble(self, parameterName, parameterValue):
    #     self.c_fpForest.setParamDouble(parameterName, parameterValue)

    # def setParamInt(self, parameterName, parameterValue):
    #     self.c_fpForest.setParamInt(parameterName, parameterValue)

    # def printParameters(self):
    #     self.c_fpForest.printParameters()

    # def printForestType(self):
    #     self.c_fpForest.printForestType()

    # def growForest(self):
    #     self.c_fpForest.growForest()

    # def predict(self, observation):
    #     return self.c_fpForest.predict(observation)

    # def testAccuracy(self):
    #     return self.c_fpForest.testAccuracy()