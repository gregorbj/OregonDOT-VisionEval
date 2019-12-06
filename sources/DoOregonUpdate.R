#================
#DoOregonUpdate.R
#================

#Brian Gregor
#12/6/2019

#This script updates an official VisionEval installation to include all the new or modified VisionEval packages that have been developed for the Oregon DOT. This script sources in the updateVisionEvalInstall.R script which defines the updateVisionEvalInstall.R script which implements the updating. Some important things to note:
#1) The VEInstallationDir argument is used to specify the full path to the VisionEval installation. Since it is unlikely that your installation directory (folder) is the same as mine, you will need to modify the argument assignment to identify the location of your VisionEval installation directory (folder).
#2) The Packages argument identifies all the new or modified VisionEval packages that have been developed for the Oregon DOT. Users who are not modeling places in Oregon may not want the install all the VEPowertrainsAndFuels packages. The packages that have names such as VEPowertrainsAndFuelsx4TargetRule reflect vehicle and fuel scenarios that Oregon is using for various studies. You may find them useful as well or you may want to develop VEVehiclesAndFuels packages that reflect vehicle and fuel characteristics of specific interest to your jurisdiction. You should, however, use the VEVehicleAndFuels package in this repository because it contains some code fixes to the official VEVehiclesAndFuels package.

source("updateVisionEvalInstall.R")
library(devtools)
library(httr)
updateVisionEvalInstall(
  From = list(
    Repository = "gregorbj/OregonDOT-VisionEval",
    Branch = "master"
  ),
  Packages = c(
    "sources/framework/visioneval",
    "sources/modules/VEPowertrainsAndFuels",
    "sources/modules/VEPowertrainsAndFuelsx4TargetRule",
    "sources/modules/VEPowertrainsAndFuelsxAP",
    "sources/modules/VEPowertrainsAndFuelsxSTSRec",
    "sources/modules/VESimLandUse",
    "sources/modules/VETravelPerformance",
    "sources/modules/VEReports"
  ),
  VEInstallationDir = "~/VE_361"
)
