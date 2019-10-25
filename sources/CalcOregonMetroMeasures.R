library(visioneval)
library(VEReports)
source("CalcMetroMeasuresFunction.R")
Ma <- c("Albany", "Bend", "Corvallis", "EugeneSpringfield", "GrantsPass", 
        "Metro", "RogueValley", "SalemKeizer")
print("Calculating metropolitan area measures for 2005")
write.csv(calcMetropolitanMeasures(Year = "2005", Ma = Ma, ModelType = "VE-State"),
          file = "metro_measures_2005.csv")
print("Calculating metropolitan area measures for 2010")
write.csv(calcMetropolitanMeasures(Year = "2010", Ma = Ma, ModelType = "VE-State"),
          file = "metro_measures_2010.csv")
print("Calculating metropolitan area measures for 2040")
write.csv(calcMetropolitanMeasures(Year = "2040", Ma = Ma, ModelType = "VE-State"),
          file = "metro_measures_2040.csv")
