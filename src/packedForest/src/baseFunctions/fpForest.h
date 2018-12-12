#ifndef fpForest_h
#define fpForest_h

#include "../fpSingleton/fpSingleton.h"
#include "fpGrowingTreeHelpers/fpSplit.h"
#include <string>
#include <memory>

namespace fp {

	template <typename T>
		class fpForest{

			protected:
				std::unique_ptr<fpForestBase<T> > forest;

				void loadData(){
					fpSingleton::getSingleton().loadData();
				}

				void loadTestData(){
					fpSingleton::getSingleton().loadTestData();
				}

				void deleteData(){
					fpSingleton::getSingleton().deleteData();
				}

				void deleteTestData(){
					fpSingleton::getSingleton().deleteTestData();
				}


				inline void setFunctionPointers(){
					;//fpSingleton::getSingleton().setFunctionPointers();
				}

				inline void initializeForestType(){
					forest = forestFactory<T>::setForestType(fpSingleton::getSingleton().returnForestType());
				}

				inline void setDataDependentParameters(){
					fpSingleton::getSingleton().setDataDependentParameters();
				}


			public:

				fpForest(){}

				inline void setParameter1(const std::string& parameterName, const std::string& parameterValue){
					fpSingleton::getSingleton().setParameter(parameterName, parameterValue);	
				}


				inline void setParameter2(const std::string& parameterName, const double parameterValue){
					fpSingleton::getSingleton().setParameter(parameterName, parameterValue);	
				}

				inline void setParameter3(const std::string& parameterName, const int parameterValue){
					fpSingleton::getSingleton().setParameter(parameterName, parameterValue);	
				}

				inline void printParameters(){
					fpSingleton::getSingleton().printAllParameters();
				}

				inline void printForestType(){
					fpSingleton::getSingleton().printForestType();
				}


				void growForest(){
					loadData();
					initializeForestType();
					setDataDependentParameters();
					//timeLogger x;
					//x.startGrowTimer();
					forest->growForest();
					//x.stopGrowTimer();
					//x.printGrowTime();
					deleteData();
				}


				inline int predict(std::vector<T>& observation){
					return forest->predictClass(observation);
				}


				float testAccuracy(){
					float testError;
					loadTestData();
					testError = forest->testForest();
					deleteTestData();
					return testError;
				}
		}; // class fpForest
} //namespace fp
#endif //fpForest.h
