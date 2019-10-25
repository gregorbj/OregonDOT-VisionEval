library(visioneval)
library(VEReports)
source("CalcMetroMeasuresFunction.R")
Ma <- c("AAMPO")
write.csv(calcMetropolitanMeasures(Year = "2010", Ma = Ma, ModelType = "VE-RSPM"),
          file = "metro_measures_2005.csv")
