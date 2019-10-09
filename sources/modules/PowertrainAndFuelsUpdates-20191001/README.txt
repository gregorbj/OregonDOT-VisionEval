These are updated files to include in the PowertrainsAndFuels packages for the STSRec and 4TargetRule scenarios. The files are included in the inst/extdata directories as noted below. 

The starting point for these scenarios is the newest version of the VEPowertrainsAndFuels package. This version corrects a bug in the AssignHhVehiclePowertrain module which calculated NaN values for car service vehicle average MPG when there is no HEV proportion for car service fleet mileage. This version also runs by Region rather than Azone to reduce run time.

The new VEPowertrainsAndFuelsxSTSRec package was created as follows:
1. Create a copy of the VEPowertrainsAndFuels package as noted above and rename.
2. Replace the files in the inst/extdata folder with the files in the inst/extdata folder of the VEPowertrainsAndFuelsxSTSRecx2017x20181213 package.
3. Replace the comsvc_powertrain_prop.csv, congestion_efficiency.csv, and hvytrk_fuel.csv files in the inst/extdata folder with the corresponding files in the extdata folder in this folder.

The new VEPowertrainsAndFuelsx4TargetRule package was created as follows:
1. Create a copy of the VEPowertrainsAndFuelsxSTSRec package
2. Replace the carbon_intensity.csv, comsvc_fuel.csv, and carsvc_powertrain_prop.csv files in the inst/extdata folder with the corresponding files in the exdata folder of this folder.

The new VEPowertrainsAndFuelsxAP package was created as follows:
1. Create a copy of the VEPowertrainsAndFuels package as noted above and rename.
2. Replace the files in the inst/extdata folder with the files in the inst/extdata folder of the VEPowertrainsAndFuelsxAPx20180302x20181213 package.
3. Check the ldv_powertrain_characteristics.csv file to confirm that the values in the ldv_powertrain_characteristics.csv file for AutoPhevMpg are the same as AutoHevMpg and the values of LtTrkPhevMpg are the same as LtTrkHevMpg.
 