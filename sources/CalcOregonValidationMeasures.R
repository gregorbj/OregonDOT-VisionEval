library(visioneval)
library(VEReports)
source("CalcStateValidationMeasuresFunction.R")
Years <- c("2005", "2010", "2040")
BaseYear <- "2010"
write.csv(calcStateValidationMeasures(Years, BaseYear), 
          row.names = FALSE,
          file = "state_validation_measures.csv")
