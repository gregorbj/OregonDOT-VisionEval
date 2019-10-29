library(visioneval)
library(VEReports)
source("CalcMetroMeasuresFunction.R")
Ma <- c("AAMPO")
write.csv(calcMetropolitanMeasures(Year = "2010", Ma = Ma), row.names = FALSE,
          file = "metro_measures_2010.csv")
