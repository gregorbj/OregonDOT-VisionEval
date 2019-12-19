# OregonDOT-VisionEval
VisionEval packages and model data customized for the Oregon DOT. New and revised VisionEval packages are included in the 'sources/modules' directory. The 'sources' directory includes the 'updateVisionEvalInstall.R' and 'DoOregonUpdate.R' scripts. The 'updateVisionEvalInstall.R' script defines the 'updateVisionEvalInstall()' function. This function allows user to update a standard VisionEval installation (see https://visioneval.org/category/download.html) with additional and/or modified packages. The 'DoOregonUpdate.R' script sources in the 'updateVisionEvalInstall.R' script and calls the calls the 'updateVisionEvalInstall()' function with arguments specific to updating a VisionEval installation with packages developed for the OregonDOT. Other users may wish to modify the function call for their purposes. It should be noted that the following revised VisionEval packages include important bug fixes and improvements:
* sources/framework/visioneval
* sources/modules/VEHouseholdTravel
* sources/modules/VEHouseholdVehicles
* sources/modules/VEPowertrainsAndFuels
* sources/modules/VEPowertrainsAndFuelsx4TargetRule
* sources/modules/VEPowertrainsAndFuelsxAP
* sources/modules/VEPowertrainsAndFuelsxSTSRec
* sources/modules/VEReports
* sources/modules/VESimLandUse
* sources/modules/VETravelPerformance

One of the important upgrades has been to enable the loading of a datastore from a previous model run. There are 2 use cases that this addresses:
1. A model can be run for one year, such as the base year, and then the datastore for the base year can be loaded into a model run for another year. This process can be repeated for running the model for additional years.
2. Some of the modules of a model can be run for a year and then the resulting datastore can be loaded into a model run of additional modules.
The "Datastore_Loading_Examples" directory in the sources directory includes example model setup files for these use cases.
