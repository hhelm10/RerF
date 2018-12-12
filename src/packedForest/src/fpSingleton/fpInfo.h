#ifndef fpInfo_h
#define fpInfo_h

#include <string>
#include <memory>
#include <math.h>
#include <iostream>

namespace fp {

	/**
	 * fpInfo holds all parameters for the forests.  These parameters should be
	 * set before calling fpForest to run forest creation.
	 */

	class fpInfo{

		protected:
			int numTreesInForest;
			int minParent = 1;
			int numClasses = -1;
			int numObservations = -1;
			int numFeatures = -1;
			int mtry = -1;
			int columnWithY = -1;

			int numberOfNodes;
			int maxDepth;
			int sumLeafNodeDepths;

			double fractionOfFeaturesToTest = -1.0;

			std::string forestType;
			std::string CSVFileName;


		public:
			fpInfo();

			void setParameter(const std::string& parameterName, const std::string& parameterValue);

			void setParameter(const std::string& parameterName, const double parameterValue);

			void setParameter(const std::string& parameterName, const int parameterValue);

			void printAllParameters();
			void printForestType();

			inline std::string& returnCSVFileName(){
				return CSVFileName;
			}

			inline std::string& returnForestType(){
				return forestType;
			}

			inline int returnColumnWithY() const{
				return columnWithY;
			}

			inline int returnNumClasses() const{
				return numClasses;
			}

			inline int returnMinParent() const{
				return minParent;
			}

			inline int returnNumFeatures() const{
				return numFeatures;
			}
			inline int returnNumObservations() const{
				return numObservations;
			}

			inline void setNumClasses(const int& numC){
				numClasses = numC;
			}

			inline void setNumFeatures(const int& numF){
				numFeatures = numF;
			}

			inline void setNumObservations(const int& numO){
				numObservations = numO;
			}

			inline int returnNumTrees() const{
				return numTreesInForest;
			}

			inline bool loadDataFromCSV(){
				if(!CSVFileName.empty() || columnWithY != -1){
					return true;
				}
				return false;
			}

			inline int returnMtry(){
				return mtry;
			}
			inline bool useDefaultMTRY(){
				return fractionOfFeaturesToTest < 0;
			}

			inline void setMTRY(){
				if(mtry == -1){
					if(useDefaultMTRY()){
						mtry = sqrt(numFeatures);
					}else{
						mtry = fractionOfFeaturesToTest * numFeatures;
					}
				}
			}

	}; // class fpInfo
} //namespace fp
#endif //fpInfo.h
