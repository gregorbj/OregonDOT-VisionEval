library(visioneval)
library(VEReports)
source("CalcMetroMeasuresFunction.R")
Ma <- c("Albany", "Bend", "Corvallis", "EugeneSpringfield", "GrantsPass", 
        "Metro", "RogueValley", "SalemKeizer", "None")
print("Calculating metropolitan area measures for 2005")
write.csv(calcMetropolitanMeasures(Year = "2005", Ma = Ma), row.names = FALSE,
          file = "metro_measures_2005.csv")
print("Calculating metropolitan area measures for 2010")
write.csv(calcMetropolitanMeasures(Year = "2010", Ma = Ma), row.names = FALSE,
          file = "metro_measures_2010.csv")
print("Calculating metropolitan area measures for 2040")
write.csv(calcMetropolitanMeasures(Year = "2040", Ma = Ma), row.names = FALSE,
          file = "metro_measures_2040.csv")
