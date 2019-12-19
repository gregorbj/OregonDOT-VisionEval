#===========
#run_model.R
#===========

#This script demonstrates the VisionEval framework for the VE-State model.
cat('run_model.R: script entered\n')
#Load libraries
#--------------
library(visioneval)
cat('run_model.R: library visioneval loaded\n')

#Initialize model
#----------------
initializeModel(
  ParamDir = "defs",
  RunParamFile = "run_parameters.json",
  GeoFile = "geo.csv",
  ModelParamFile = "model_parameters.json",
  LoadDatastore = TRUE,
  DatastoreName = "../First/Datastore",
  SaveDatastore = FALSE
  )  
cat('run_model.R: initializeModel completed\n')

#Run all demo module for all years
#---------------------------------
for(Year in getYears()) {
  runModule("AssignDrivers",                   "VEHouseholdVehicles",   RunFor = "AllYears",    RunYear = Year)
  runModule("AssignVehicleOwnership",          "VEHouseholdVehicles",   RunFor = "AllYears",    RunYear = Year)
  runModule("AssignVehicleType",               "VEHouseholdVehicles",   RunFor = "AllYears",    RunYear = Year)
  runModule("CreateVehicleTable",              "VEHouseholdVehicles",   RunFor = "AllYears",    RunYear = Year)
  runModule("AssignVehicleAge",                "VEHouseholdVehicles",   RunFor = "AllYears",    RunYear = Year)
  runModule("CalculateVehicleOwnCost",         "VEHouseholdVehicles",   RunFor = "AllYears",    RunYear = Year)
  runModule("AdjustVehicleOwnership",          "VEHouseholdVehicles",   RunFor = "AllYears",    RunYear = Year)
  runModule("CalculateHouseholdDvmt",          "VEHouseholdTravel",     RunFor = "AllYears",    RunYear = Year)
  runModule("CalculateAltModeTrips",           "VEHouseholdTravel",     RunFor = "AllYears",    RunYear = Year)
  runModule("CalculateVehicleTrips",           "VEHouseholdTravel",     RunFor = "AllYears",    RunYear = Year)
  runModule("DivertSovTravel",                 "VEHouseholdTravel",     RunFor = "AllYears",    RunYear = Year)
  runModule("CalculateCarbonIntensity",        "VEPowertrainsAndFuelsx4TargetRule", RunFor = "AllYears",    RunYear = Year)
  runModule("AssignHhVehiclePowertrain",       "VEPowertrainsAndFuelsx4TargetRule", RunFor = "AllYears",    RunYear = Year)
  runModule("CalculateRoadDvmt",             "VETravelPerformance",   RunFor = "AllYear",    RunYear = Year)
  runModule("CalculateRoadPerformance",      "VETravelPerformance",   RunFor = "AllYears",    RunYear = Year)
  runModule("CalculateMpgMpkwhAdjustments",  "VETravelPerformance",   RunFor = "AllYears",    RunYear = Year)
  runModule("AdjustHhVehicleMpgMpkwh",       "VETravelPerformance",   RunFor = "AllYears",    RunYear = Year)
  runModule("CalculateVehicleOperatingCost", "VETravelPerformance",   RunFor = "AllYears",    RunYear = Year)
  runModule("BudgetHouseholdDvmt",           "VETravelPerformance",   RunFor = "AllYears",    RunYear = Year)
  runModule("BalanceRoadCostsAndRevenues",   "VETravelPerformance",   RunFor = "AllYears",    RunYear = Year)
  runModule("CalculateComEnergyAndEmissions",   "VETravelPerformance",   RunFor = "AllYears",    RunYear = Year)
  runModule("CalculatePtranEnergyAndEmissions", "VETravelPerformance",   RunFor = "AllYears",    RunYear = Year)
}
