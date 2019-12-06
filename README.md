# OregonDOT-VisionEval
VisionEval packages and model data customized for the Oregon DOT. New and revised VisionEval packages are included in the 'sources/modules' directory. The 'sources' directory includes the 'updateVisionEvalInstall.R' and 'DoOregonUpdate.R' scripts. The 'updateVisionEvalInstall.R' script defines the 'updateVisionEvalInstall()' function. This function allows user to update a standard VisionEval installation (see https://visioneval.org/category/download.html) with additional and/or modified packages. The 'DoOregonUpdate.R' script sources in the 'updateVisionEvalInstall.R' script and calls the calls the 'updateVisionEvalInstall()' function with arguments specific to updating a VisionEval installation with packages developed for the OregonDOT. Other users may wish to modify the function call for their purposes. It should be noted that the following revised VisionEval packages include important bug fixes and improvements:
* sources/framework/visioneval
* sources/modules/VEPowertrainsAndFuels
* sources/modules/VEReports
* sources/modules/VESimLandUse
* sources/modules/VETravelPerformance

