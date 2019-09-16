# VE Modifications to Improve Representation of Driverless Vehicles and Car Services

## Issue

VisionEval modules do not address the potential effects of driverless vehicles; either those owned by households or deployed by car services. However, users may implicitly model some aspects of car service deployment of driverless vehicles in the form of car service prices and service extent. Users can't model how driverless technology might affect the amount of household travel or roadway performance. 

It should be noted that the term *driverless* is used instead of *autonomous* because driverless refers to a level of vehicle autonomy which enables vehicles to travel without human intervention. Other levels of autonomy require drivers to monitor an intervene in vehicle operation to some degree. Driverless automony has the potential for substantially changing travel behavior and road performance by:
- Allowing all vehicle occupants to spend their time while traveling doing things that are more enjoyable than driving, potentially reducing the disutility of travel and increasing the amount of travel.
- Substantially reducing the cost of car service travel by eliminating driver labor cost.
- Enabling vehicles to shuttle non-drivers (e.g. children).
- Enabling vehicles to travel unoccupied in order to avoid parking costs.
- Allowing vehicles to operate more densely in harmonized fashion on highways, increasing capacity.
While lower levels of vehicle autonomy can increase travel safety and comfort, their effects on vehicle travel and road performance are likely to be a small fraction of the effects of driverless vehicles. Therefore only driverless autonomous being considered.

Following are effects of driverless vehicles that should be included in VisionEval:
1. **Effect of driverless vehicles on highway capacity and emissions**: Researchers have estimated that widespread deployment of connected autonomous vehicles could substantially increase highway capacity as a result of better harmonized traffic flows, shorter headways, and lower crash rates. More harmonized traffic flows will also result in lower emissions (for internal combustion engine vehicles) because less fuel will be wasted due to operation at a more constant traffic speeds.
2. **Effect of driverless vehicles on distance traveled**: The use of driverless vehicles may increase the distances that people are willing to travel because vehicle travel is made less onerous. Travelers can spend their time doing more enjoyable or productive things than driving their vehicles.
3. **Effect of driverless vehicles on the number of vehicle trips**: Driverless vehicles will enable and perhaps encourage trips to be made that are now not possible. For example, it may be possible for children to travel by personal vehicle unaccompanied by a driver. Driverless vehicles would also make it possible to avoid parking difficulties and fees by directing the vehicle to 

Although widespread ownership of driverless vehicles could substantially increase the amount of vehicle travel for the reasons noted above, the deployment of driverless vehicles by car services might have the opposite effect. The use of driverless vehicles by car services could substantially reduce operating costs and in so doing increase the proportion of households who opt for using car services in lieu of owning a car. For those households vehicle travel would likely be reduced because the sunk cost of vehicle travel would be lower and the variable cost of vehicle travel would be higher. Such reductions would be offset to some degree, however, because lower car service fares would also encourage travelers to use car services rather than other non-car modes (e.g. bus, walk, bike). VisionEval modules currently enable users to address these effects to some degree as follow:
- Car service is categorized as high or low level service. With high level service, car service access time (waiting for pickup and walking time at drop-off) is competitive with owned vehicle access time (walking to parking, parking, and walking from parking). High level service is what is now available by TNCs like Uber and Lyft in many urban areas. Users can set up a scenario with assumptions about how driverless vehicle technology might affect the extent of high level service.
- The user specifies fares ($/mile) for high level and low level service. Fare assumptions can reflect assumptions about the deployment of driverless vehicles and their effect on lowering cost.
- The AdjustVehicleOwnership module in the VEHouseholdVehicles package adjusts household vehicle ownership by comparing the cost of ownership with the cost of car service use for households living in places where high level car service is available. Assumptions about how driverless vehicles would affect the extent of high level car service and the price of that car service affect household vehicle ownership. (Note that the likelihood that a household substitutes a car service for owning a car also depends on two other factors: LtTrkCarSvcSubProp and AutoCarSvcSubProp).
- High level car service is considered to be the same as car ownership (although with different cost per mile of use). In households that own fewer vehicles than there are drivers and living in a place where high level car service is available, effective vehicle ownership is increased so that there are as many cars as drivers. This affects the calculation of unbudget-constrained household DVMT (CalculateHouseholdDvmt module).
- Household DVMT is adjusted to reflect budget constraints by the CalculateVehicleOperatingCost and BudgetHouseholdDvmt modules. The CalculateVehicleOperatingCost module calculates the composite operating cost of using each household vehicle including assigned car services (composite operating cost includes money and time components). It also assigns household DVMT to each vehicle and calculates the average cost per mile of vehicle travel for the household. The BudgetHouseholdDvmt module adjusts each household's DVMT using the computed average cost per mile for the household and the household income.
- Travel by non-auto modes (i.e. non-auto public transit, walk, bike) is calculated as a function of the budget-adjusted household DVMT.

Although VisionEval modules enable many of the effects of driverless vehicles in car services to be modeled, there are some important considerations that are missing. These are:
1. **Consideration of non-fare mileage**: Car service DVMT currently only accounts for fare-mileage, not for deadhead mileage (i.e. travel between drop off of one passenger and pick up of the following passenger). As a result, the effects of car services (e.g. congestion, emissions) are underestimated. It has been reported that the deadhead mileage of TNC drivers is substantial. Driverless vehicle technology could substantially reduce the deadhead mileage by enabling fleet usage to be optimized.
2. **Relative car service occupancy**: The effect of substituting car service travel for household vehicle travel depends on the relative occupancy of car service vehicles. VMT could be reduced if most car service travel is in shared vehicles (more than one occupant) but could be increased if most car service travel is unshared.

## Approach

The objective is to account for the car service and autonomous vehicle effects listed above with the smallest set of changes to the VisionEval module models and code base. As such, the changes should keep existing module models (e.g. household DVMT model) in their present form instead of specifying and estimating new models that incorporate driverless vehicle related parameters. Consequently, the model calculations will be modified by applying factors, many or most of which assumed, rather than by respecifying and reestimating models. One new module will be created (AssignDriverlessVehicles) and six other modules will be modified: CreateVehicleTable, CalculateRoadDvmt, CalculateRoadPerformance, CalculateMpgMpkwhAdjustments, CalculateVehicleOperatingCost, and BudgetHouseholdDvmt. Following are descriptions of what will be done in each of these modules.

### CreateVehicleTable Module

The CreateVehicleTable module processes the car service inputs in the **azone_carsvc_characteristics.csv** file. This file will be modified to include factors which specify deadhead proportions for high level car service and for low level car service by Azone (HighCarSvcDeadheadProp, LowCarSvcDeadheadProp). Deadhead proportion is defined as deadhead mileage divided by fare mileage. The file will also be modified to include average car service vehicle occupancy for high level car service and for low level car service by Azone (HighCarSvcOccupancy, LowCarSvcOccupancy). The values will be stored in the Guidelines will be provided to assist users in specifying plausible values for these inputs.

### AssignDriverlessVehicles Module

This new module will determine which household vehicles are driverless. It will also determine for car service vehicles, commercial service vehicles, and heavy trucks, the proportions of DVMT that are driverless. These proportions will be specified in the *region_driverless_vehicle_prop.csv* file which has the following fields:
- Year: identify years in 5 or 10 year intervals (e.g. 2010, 2020, etc.) covering the entire range of years that might be modeled.
- AutoDriverlessProp: The proportion of automobiles sold in the corresponding year that are driverless. Values for intervening years are interpolated.
- LtTrkDriverlessProp: The proportion of light trucks sold in the corresponding year that are driverless. Values for intervening years are interpolated.
- LowCarSvcDriverlessProp: The proportion of the car service fleet DVMT in low car service areas in the corresponding year that are driverless. Values for intervening years are interpolated.
- HighCarSvcDriverlessProp: The proportion of the car service fleet DVMT in high car service areas in the corresponding year that are driverless. Values for intervening years are interpolated.
- ComSvcDriverlessProp: The proportion of the commercial service vehicle fleet DVMT in the corresponding year that are driverless. Values for intervening years are interpolated.
- HvyTrkDriverlessProp: The proportion of the heavy truck fleet DVMT in the corresponding year that are driverless. Values for intervening years are interpolated.
- PtVanDriverlessProp: The proportion of public transit van DVMT in the corresponding year that are driverless. Values for intervening years are interpolated.
- BusDriverlessProp: The proportion of bus fleet DVMT in the corresponding year that are driverless. Values for intevening years are interpolated.

The values in this file will be stored in the *RegionDriverlessProps* table in the *Global* group of the datastore. Note that the assumed driverless values for household automobiles and light trucks are proportions of sales by vehicle model year, whereas the values for car service vehicles, commercial service vehicles, and heavy trucks are proportions of fleet DVMT for the year. Guidelines will be provided to assist users in specifying plausible values for these inputs.

It is assumed that driverless vehicles used by households will be retired at the same rate as other household vehicles. thus the probability that a vehicle is driverless is determined by the sales proportion for the model year corresponding to its age. The model for assigning driverless vehicles could use other household characteristics as well to determine the probability that a vehicle is driverless, but at the present time it is proposed to use only vehicle age and type (auto, light truck) to determine the probability. (Note that since vehicle age is a function of household income, the probabilities will also reflect differences in household income.) 

This module will be run after the AdjustVehicleOwnership module is run. Household vehicles of each age and type will be randomly assigned as driverless given the assigned probability for the age and type. The assignments will be recorded in the *Driverless* dataset in the *Vehicle* table with a value of 1 for driverless vehicles owned by the household and 0 for other household vehicles. Car services assigned to the household will be assigned the LowCarSvcDriverlessProp value or HighCarSvcDriverlessProp value for the car service level and Azone applicable to the household.

The module will also calculate a preliminary estimate of the proportion of household DVMT that is in driverless vehicles. This will be stored in the *DriverlessDvmtProp* dataset in the *Household* table and the *HhDriverlessDvmtProp* dataset in the *Marea* table. This is necessary in order for the CalculateRoadPerformance module to calculate the effects of driverless vehicles on road performance. These preliminary estimates will be based on the assumption that household DVMT is split equally among vehicles available to the household. The values will be updated when the CalculateVehicleOperatingCost module is run. As the modules in the VETravelPerformance package are run in several iterations, the DriverlessDvmtProp values will stabilize. The Set specifications for the module will be modified accordingly to specify the attributes of these datasets.

### CalculateRoadDvmt Module

The CalculateRoadDvmt module calculates the light-duty vehicle, heavy truck, and bus DVMT on urbanized area roads and on roads outside the urbanized area in each Marea. These values are used by the *CalculateRoadPerformance* module to model roadway congestion and its effects in urbanized areas. (Congestion on roads outside of urbanized areas is not modeled.) Since driverless vehicles will affect road congestion, the CalculateRoadDvmt module needs to be modified to calculate the proportions of light-duty vehicle, heavy truck, and bus DVMT that are driverless.

To make the calculations, the module Get specifications will be modified to load the following the datasets:
- From the *RegionDriverlessProps* table in the *Global* group, load the *Year*, *ComSvcDriverlessProp*, *HvyTrkDriverlessProp*, *PtVanDriverlessProp*, and *BusDriverlessProp* datasets.
- From the *Marea* table in the relevant year group(s) load the *HhDriverlessDvmtProp* dataset.

The module will create 4 additional datasets that will be stored in the *Marea* table of the relevant year group(s): *LdvDriverlessProp*, *HvyTrkDriverlessProp*, *BusDriverlessProp*, and *AveDriverlessProp*. The module Set specifications will be modified accordingly to specify the attributes of these datasets.

The module code will be modified to calculate *LdvDriverlessProp*, *HvyTrkDriverlessProp*, and *BusDriverlessProp* by Marea as follows:
1. An approximation function will be defined to calculate the driverless DVMT proportions for commercial service vehicles, heavy trucks, public transit vans, and buses for the model run year from the data in the *RegionDriverlessProps* table in the *Global* group. This function will be the same as or very similar to the *approxWithNaCheck* function defined in the *CalculateComEnergyAndEmissions* module function. The function will be called with each of the *ComSvcDriverlessProp*, *HvyTrkDriverlessProp*, *PtVanDriverlessProp, and *BusDriverlessProp* datasets loaded from the *RegionDriverlessProp* table along with the *Year* dataset from that same table, and the model run year to calculate the respective driverless DVMT proportions for the model run year.
2. The Marea values for *HvyTrkDrivelessProp* and *BusDriverlessProp* will be set equal to the respective driverless proportions calculated in #1 above for the model run year. Note that values are the same for all Mareas.
3. The *LdvDriverlessProp* value will be calculated for each Marea as a DVMT weighted average of the *HhDriverlessDvmtProp* (for the Marea), *ComSvcDriverlessProp* (for the region), and *PtVanDriverlessProp* (for the region). The respective DVMT weightings are the respective metropolitan area DVMT for households, commercial service vehicles and public transit vans. Following is an example of what code could be inserted at line 868

<pre style="font-size: 11px">
HhDvmtWts_Ma <- HhDvmt_Ma * LdvUrbanRoadProp_Ma / UrbanLdvDvmt_Ma
ComSvcDvmtWts_Ma <- ComSvcDvmt_Ma * LdvUrbanRoadProp_Ma / UrbanLdvDvmt_Ma
PtVanDvmtWts_Ma <- L$Year$Marea$VanDvmt / UrbanLdvDvmt_Ma
LdvDriverlessProp_Ma <- 
HhDriverlessDvmtProp_Ma * HhDvmtWts_Ma + ComSvcDriverlessProp * ComSvcDvmtWts_Ma + PtVanDriverlessProp * PtVanDvmtWts_Ma
</pre>

### CalculateRoadPerformance Module

The effects of driverless vehicles on road performance will be calculated using a combination of input values in existing input files (*other_ops_effectiveness.csv*, and *marea_ops_deployment.csv*) and functions that modify those values as a function of the proportion of DVMT that is driverless.

The *other_ops_effectiveness.csv* file allows users to specify the percentage reductions in recurring and nonrecurring congestion delay on freeways and on arterials at each of 5 congestion levels (none, moderate, heavy, severe, extreme) for operations programs other than ramp metering, incident management, signal coordination, and access management. Recommended input values will be estimated for the effect of driverless vehicles on delay assuming that all vehicles are driverless. Since there are 4 columns in the input file - Art_Rcr (arterial recurring congestion), Art_NonRcr (arterial non-recurring congestion), Fwy_Rcr (freeway recurring congestion), Fwy_NonRcr (freeway non-recurring congestion) - and 5 rows (one for each congestion level), 20 values need to be estimated. It is expected that the values will be estimated based on a review of the research literature. Functions as described below will modify those values to reflect partial deployment of driverless vehicles.

It should be noted that this approach constrains users ability to analyze the joint effects of a driverless vehicle scenario and and other operations programs such as variable speed limits that might be modeled using the *other_ops_effectiveness.csv* file inputs. It will be possible for the standard operations programs (ramp metering, incident management, signal coordination, and access management) to be analyzed in conjuction with driverless vehicles, but the effects will not be considered additive. Instead, the delay reduction will be the maximum of the delay reduction due to the deployment of standard operations programs and the delay reduction due to the deployment of driverless vehicles.

The *marea_ops_deployment.csv* file contains two input fields, OtherFwyOpsDeployProp and OtherArtOpsDeployProp, that allow the user to specify the degree of deployment of other operations programs (as assumed in the other_ops_effectiveness.csv inputs) by metropolitan (urbanized) area. These values are used by the model to adjust the delay reductions specified in the other_ops_effectivess.csv file to reflect the degree of deployment. For driverless vehicle scenarios, these values will be ignored because effectiveness of driverless vehicles will depend on the proportion of DVMT that is driverless and will be calculated by the module.

Functions will be added to the CalculateRoadPerformance module code to adjust the input values for other operations effectiveness to reflect the proportion of DVMT that is driverless. Since there are 20 other operations effectiveness values, there could be as many as 20 functions. Given the complexity of defining and applying 20 functions, it makes more sense to at most define 4 functions each combination of facility type (freeway, arterial) and congestion type (recurring, nonrecurring). These functions could be linear functions of the driverless DVMT proportion, but are more likely to be nonlinear because the research literature indicates that the effect of driverless vehicles on congestion are likely to be nonlinear. These functions will be defined in *Section 1C* of the *CalculateRoadPerformance.R* script. For the purposes of the explanation below, the functions are assumed to be define in a list named *DriverlessFactor_ls* with components named *Art_Rcr*, *Art_NonRcr*, *Fwy_Rcr*, and *Fwy_NonRcr*. The argument to the function will be driverless DVMT proportion (*DriverlessDvmtProp*). The output of the function will be a factor between 0 and 1 that is used to adjust the other operations effectiveness values.

The module *Get* specifications will be changed to include loading the *LdvDriverlessProp*, *HvyTrkDriverlessProp*, and *BusDriverlessProp* datasets in the *Marea* table for the model run year.

Several changes to the module script need to be made to calculate the effects of driverless vehicles on congestion, travel speeds, and DVMT by road class and congestion level:
1. Modify the *calculateSpeeds* function which adjusts the base speeds by road class (freeway and arterial) and congestion level to reflect the effects of operations programs. The function needs to be changed to calculate the effects of driverless vehicles on speed which is a function of the average driverless DVMT proportion.
2. Modify the main module function code to define a function which calculates the average driverless DVMT proportion by road class.
3. Modify the main module code in lines 1571-1618 remove the calls to *calculateSpeeds* which will be moved to the code which defines the *balanceFwyArtDvmt* function in lines 1671-1711.
4. Modify the main module code in lines 1671-1711 to add the calls to *calculateSpeeds*.

Code changes will be made to the *calculateSpeeds* function defined in lines 883-929 of the CalculateRoadPerformance.R script. An additional argument will be defined for the function, *DriverlessDvmtProp_Rc*. This argument will be a named numeric vector where the names are *Fwy* and *Art* and the values are the driverless DVMT proportions by road classification (freeways and arterials respectively). The default value will be NULL. When the function is called without passing a value for the *DriverlessDvmtProp_Rc* argument, the function will calculate speeds in the present manner. The code for lines will be changed to apply the functions described above to the following:

<pre style="font-size: 11px">
  if (!is.null(OtherOpsEffects_mx)) {
    Ty <- colnames(OtherOpsEffects_mx)
    if (!is.null(DriverlessDvmtProp_Ty)) {
      DriverlessDvmtProp_Ty <- setNames(numeric(length(Ty)), Ty)
      DriverlessDvmtProp_Ty[c("Fwy_Rcr", "Fwy_NonRcr")] <-
        DriverlessDvmtProp_Rc["Fwy"]
      DriverlessDvmtProp_Ty[c("Art_Rcr", "Art_NonRcr")] <-
        DriverlessDvmtProp_Rc["Art"]
      OtherOpsDeploy_Ty <- sapply(Ty, function(x) {
        DriverlessFactor_ls[[x]](DriverlessDvmtProp_Ty[x])})
      OtherOpsFactor_mx <-
        1 - sweep(OtherOpsEffects_mx, 2, OtherOpsDeploy_Ty, "*") / 100
      #Select the maximum reduction. This is the minimum factor.
      DelayFactor_mx <- pmin(DelayFactor_mx, OtherOpsFactor_mx) 
    } else {
      OtherOpsDeploy_Ty <- setNames(numeric(length(Ty)), Ty)
      OtherOpsDeploy_Ty[c("Fwy_Rcr", "Fwy_NonRcr")] <- 
        OpsDeployment_["OtherFwyOpsDeployProp"]
      OtherOpsDeploy_Ty[c("Art_Rcr", "Art_NonRcr")] <- 
        OpsDeployment_["OtherArtOpsDeployProp"]
      OtherOpsFactor_mx <-
        1 - sweep(OtherOpsEffects_mx, 2, OtherOpsDeploy_Ty, "*") / 100
      DelayFactor_mx <- DelayFactor_mx * OtherOpsFactor_mx
    }
  }
</pre>

A function will be defined in the main module code to calculate the average driverless DVMT proportion by Marea. The code will be similar to the following:

<pre style="font-size: 11px">
#Define function to calculate average driverless DVMT proportion
calcAveDriverlessDvmtProp <- 
  function(LdvDvmt_Rc, LdvDriverlessProp,
           HvyTrkDvmt_Rc, HvyTrkDriverlessProp,
           BusDvmt_Rc, BusDriverlessProp) {
    Dvmt_TyRc <- rbind(LdvDvmt_Rc, HvyTrkDvmt_Rc, BusDvmt_Rc)
    DvmtPropByTy_TyRc <- sweep(Dvmt_TyRc, 2, colSums(Dvmt_TyRc), "/")
    DriverlessProp_Ty <- c(LdvDriverlessProp, HvyTrkDriverlessProp, BusDriverlessProp)
    colSums(sweep(DvmtPropByTy_TyRc, 1, DriverlessProp_Ty, "*"))
  }
</pre>

The main module code in lines 1571-1618 would be changed to the following to remove speed calculations:

<pre style="font-size: 11px">
#Process roadway operations values
#---------------------------------
#Create matrix of user-defined other operations effects
if (!is.null(L$Global$OtherOpsEffectiveness)) {
  OtherOpsEffects_mx <- cbind(
    Fwy_Rcr = L$Global$OtherOpsEffectiveness$Fwy_Rcr,
    Fwy_NonRcr = L$Global$OtherOpsEffectiveness$Fwy_NonRcr,
    Art_Rcr = L$Global$OtherOpsEffectiveness$Art_Rcr,
    Art_NonRcr = L$Global$OtherOpsEffectiveness$Art_NonRcr
  )
  rownames(OtherOpsEffects_mx) <- L$Global$OtherOpsEffectiveness$Level
} else {
  OtherOpsEffects_mx <- array(
    0,
    dim = c(5, 4),
    dimnames = list(
      c("None", "Mod", "Hvy", "Sev", "Ext"),
      c("Art_Rcr", "Art_NonRcr", "Fwy_Rcr", "Fwy_NonRcr")
    ))
}
#Create matrix of operations deployment
OpsDeployNames_ <- c(
  "RampMeterDeployProp",
  "IncidentMgtDeployProp",
  "SignalCoordDeployProp",
  "AccessMgtDeployProp",
  "OtherFwyOpsDeployProp",
  "OtherArtOpsDeployProp")
OpsDeployment_MaOp <- do.call(cbind, L$Year$Marea[OpsDeployNames_])
rownames(OpsDeployment_MaOp) <- Ma
#Create matrix of driverless DVMT proportions by Marea and vehicle type
DriverlessDvmtProp_MaTy <- cbind(
  Ldv = L$Year$Marea$LdvDriverlessProp,
  HvyTrk = L$Year$Marea$HvyTrkDriverlessProp,
  Bus = L$Year$Marea$BusDriverlessProp
)
rownames(DriverlessDvmtProp_MaTy) <- L$Year$Marea$Marea
</pre>  

The  main module code in lines 1671-1711 will be modified to include speed calculations and the call to the new *calcAveDriverlessDvmtProp* function in the definition of the *balanceFwyArtDvmt* function. The calculation of speed and delay by congestion level and vehicle type will be added as an output of the function:

<pre style="font-size: 11px">
#Define function to balance freeway and arterial DVMT
#----------------------------------------------------
balanceFwyArtDvmt <- function(ma) {
  #Initialize values
  LastDvmtRatio <- 0
  FwyAveSpeed <- 60
  ArtAveSpeed <- 30
  #Iterate to find solution
  for (i in 1:100) {
    #Split LDV DVMT
    LdvDvmt_Rc <-
      splitLdvDvmt(LdvDvmt_MaRx[ma,], FwyAveSpeed, ArtAveSpeed, Lambda_Ma[ma], LambdaAdj_Ma[ma])
    #Add heavy truck and bus DVMT to calculate total
    Dvmt_Rc <-
      LdvDvmt_Rc + HvyTrkDvmt_MaRc[ma,] + BusDvmt_MaRc[ma,]
    #Calculate DVMT ratio, compare to last, and terminate if change is very small
    DvmtRatio <- Dvmt_Rc["Fwy"] / Dvmt_Rc["Art"]
    if(abs(1 - LastDvmtRatio / DvmtRatio) < 0.0001) break()
    LastDvmtRatio <- DvmtRatio
    #Split DVMT into congestion levels
    FwyDvmt_Cl <-
      calculateCongestion("Fwy", LaneMi_MaRc[ma,"Fwy"], Dvmt_Rc["Fwy"])
    ArtDvmt_Cl <-
      calculateCongestion("Art", LaneMi_MaRc[ma,"Art"], Dvmt_Rc["Art"])
    <b>#Calculate average driverless DVMT proportion by road class
    DriverlessDvmtProp_Rc <- calcAveDriverlessDvmtProp(
      LdvDvmt_Rc = LdvDvmt_Rc, 
      LdvDriverlessProp = DriverlessDvmtProp_MaTy[ma, "Ldv"],
      HvyTrkDvmt_Rc = HvyTrkDvmt_MaRc[ma, c("Fwy", "Art")],
      HvyTrkDriverlessProp = DriverlessDvmtProp_MaTy[ma, "HvyTrk"],
      BusDvmt_Rc = BusDvmt_MaRc[ma, c("Fwy", "Art")],
      BusDriverlessProp = DriverlessDvmtProp_MaTy[ma, "Bus"])
    #Calculate speed by congestion level
    SpeedAndDelay_ls <-
      calculateSpeeds(OpsDeployment_MaOp[ma,], OtherOpsEffects_mx, DriverlessDvmtProp_Rc)
    #Convert to matrices
    FwySpeed_Cl <- SpeedAndDelay_ls$Speed[,"Fwy"]
    ArtSpeed_Cl <- SpeedAndDelay_ls$Speed[,"Art"]
    FwyDelay_Cl <- SpeedAndDelay_ls$Delay[,"Fwy"]
    ArtDelay_Cl <- SpeedAndDelay_ls$Delay[,"Art"]</b>
    #Calculate equivalent average speed
    FwyAveSpeed <-
      calcAveEqSpeed(FwyDvmt_Cl, FwySpeed_Cl, FwyPrices_MaCl[ma,], VOT)
    ArtAveSpeed <-
      calcAveEqSpeed(ArtDvmt_Cl, ArtSpeed_Cl, ArtPrices_MaCl[ma,], VOT)
  }
  Dvmt_VtRc <- rbind(
    Ldv = LdvDvmt_Rc,
    HvyTrk = HvyTrkDvmt_MaRc[ma,],
    Bus = BusDvmt_MaRc[ma,]
  )
  rownames(Dvmt_VtRc) <- c("Ldv", "HvyTrk", "Bus")
  colnames(Dvmt_VtRc) <- c("Fwy", "Art", "Oth")
  list(Dvmt_VtRc = Dvmt_VtRc,
       FwyDvmt_Cl = FwyDvmt_Cl,
       ArtDvmt_Cl = ArtDvmt_Cl
       SpeedAndDelay_ls = SpeedAndDelay_ls)
}
</pre>

The call to the *balanceFwyArtDvmt* function (lines will be changed to population the list of speed and delay data by metropolitan area (*SpeedAndDelay_ls*) to incorporate the results of the function call. This list is used by other portions of the main function code. Code like the following would be added at line 1758:

<pre style="font-size: 11px">
SpeedAndDelay_ls <- lapply(BalanceResults_ls, function(x) x$SpeedAndDelay_ls)
</pre>

### CalculateMpgMpkwhAdjustments Module

The CalculateMpgMpkwhAdjustments module adjusts miles per gallon (MPG) and miles per kilowatt hour (MPKWH) values to reflect:
- Adjustment of travel speeds due to congestion: Internal combustion engine (ICE) vehicles are less efficient at low travel speeds. No changes to module code are needed to address this effect for driverless vehicles because modifications to the CalculateRoadPerformance module will calculate the effect of driverless vehicles on congested travel speeds.
- Speed smoothing: Reducing the fluctuation of speeds in traffic streams (speed smoothing) improves the fuel economy of internal combustion engines (ICE) by reducing ineffiencies caused by acceleration and deceleration. Active traffic management with variable speed limits and other operational controls is one speed smoothing techique. Deployment of connected autonomous vehicles (CAVs) will also contribute to speed smoothing. Module changes to address this are described below.
- Ecodriving: This is a practice on the part of drivers operate and maintain their vehicles to improve fuel economy. Driveless vehicles may have no effect on ecodriving.

The current module calculates the effects of speed smoothing on the fuel economy of light-duty vehicles and of heavy-duty vehicles in three parts:
1. The module estimates smooth-spline models that calculate the maximum theoretical improvement in the fuel economy of light-duty and heavy-duty vehicles as a function of travel speed. These models are based on research by Bigazzi and Clifton (see module documentation). The theoretical maximum improvement is the difference between fuel consumption modeled (using EPA's PERE model) with real-world drive cycles, and the fuel consumption modeled assuming constant speeds (no accelerations and decelerations).
2. The maximum theoretical improvement is adjusted to reflect the maximum practical improvement given that it would be impossible to eliminate all acceleration and deceleration. Bigazzi and Clifton, based on a review of the literature, assume that the maximum practical improvement is 50% of the maximum theoretical improvement at every speed.
3. The maximum practical improvement is multiplied by input assumptions for the proportion of the maximum practical improvement expected to be achieved on freeways and on arterials. These input values are contained in the *FwySmooth* and *ArtSmooth* fields of the *marea_speed_smooth_ecodrive.csv* file. The values are specified by Marea and model run year. The inputs reflect both the relative effect of a traffic management program (e.g. variable speed limits, signal coordination) on speed smoothing and the proportion of DVMT that is affected by the traffic management program.  

The effects of driverless vehicles on speed smoothing will be addressed by developing guidance on user speed smoothing inputs for a driverless vehicle scenario and by developing functions to adjust the relative speed smoothing effect as a function of the proportion of DVMT in driverless vehicles. Note that this approach will not allow speed smoothing resulting from deployment of driverless vehicles to be combined with speed smoothing resulting from other operations programs such as active traffic management.  

The module *Get* specifications will be changed to include loading the *LdvDriverlessProp*, *HvyTrkDriverlessProp*, and *BusDriverlessProp* datasets in the *Marea* table for the model run year.

Guidance will be developed for the values to include in the *marea_speed_smooth_ecodrive.csv* module which reflect the relative speed smoothing effect on fuel economy if all vehicle movements are under driverless control. For example, it might be assumed that complete driverless control would achieve the maximum practical improvements. In that case the input values for *FwySmooth* and *ArtSmooth* should be 1. 

Functions will be added to the CalculateMpgMpkwhAdjustments module code to adjust the speed smoothing effect to reflect the proportion of DVMT is driverless. Separate functions will be developed freeways and arterials. These function are likely to be nonlinear. For the purposes of the explanation below, the functions are assumed to be defined in a list named *DriverlessFactor_ls* with components named *Fwy*, and *Art*. The argument to the function will be driverless DVMT proportion (*DriverlessDvmtProp*). The output of the function will be a factor between 0 and 1 that is used to adjust the freeway and arterial speed smoothing input values (in the *marea_speed_smooth_ecodrive.csv* file). 

The main module code in lines 608-617 calculates DVMT proportions by vehicle type for use in the calculation of speed smoothing. To do this calculation, it tabulates DVMT by vehicle type but does not retain that tabulation. The code is modified to the following to retain the intermediate tabulation so that it can be used to calculate the average driverless DVMT proportion.

<pre style="font-size: 11px">
  #Calculate DVMT and DVMT proportions by road class for each vehicle type
  DvmtNames_ <- c("FwyDvmt", "ArtDvmt", "OthDvmt")
  Ma <- L$Year$Marea$Marea
  Rc <- c("Fwy", "Art", "Oth")
  Vt <- c("Ldv", "HvyTrk", "Bus")
  #Calculate DVMT by Marea, road class, and vehicle type
  Dvmt_MaRcVt <- 
    array(0, dim = c(length(Ma), length(Rc), length(Vt)), dimnames = list(Ma, Rc, Vt))
  for (vt in Vt) {
    Dvmt_MaRcVt[,,vt] <- L$Year$Marea[paste0(vt, DvmtNames_)]
  }
  #Calculate DVMT proportions
  DvmtProp_ls <- lapply(Vt, function(x) {
    Dvmt_MaRc <- Dvmt_MaRcVt[,,x]
    sweep(Dvmt_MaRc, 1, rowSums(Dvmt_MaRc), "/")
  })
</pre>

Code will be added to the main module to calculate the average driverless DVMT proportion by Marea and road class as follows:

<pre style="font-size: 11px">
DriverlessDvmtProp_MaVt <- c(
  Ldv = L$Year$Marea$LdvDriverlessProp,
  HvyTrk = L$Year$Marea$HvyTrkDriverlessProp,
  Bus = L$Year$Marea$BusDriverlessProp
)
#Calculate average driverless proportion by Marea and road class
AveDriverlessDvmtProp_MaRc <- local({
  AveDriverlessDvmtProp_MaRc <- array(0, dim = c(length(Ma), length(Rc)), dimnames = list(Ma, Rc))
  for (ma in Ma) {
    Dvmt_RcVt <- Dvmt_MaRcVt[ma,,]
    DvmtPropByVt_RcVt <- sweep(Dvmt_RcVt, 1, rowSums(Dvmt_RcVt), "/)
    DriverlessProp_Vt <- DriverlessDvmtProp_MaVt[ma,]
    AveDriverlessProp_MaRc[ma,] <- rowSums(sweep(DvmtPropByVt_RcVt, 2, DriverlessProp_Vt, "*"))
  }
  AveDriverlessDvmtProp_MaRc
})
</pre>

The main module code that defines the *calcAveSpdSmAdj* function (lines 650-669) will be modified to calculate the speed smoothing effect by vehicle type and Marea. If there are no driverless vehicles, the speed smoothing fractions are the input values (*marea_speed_smooth_ecodrive.csv* input file). If there are driverless vehicles, the estimated functions for adjusting the inputs are applied to account for the proportion of DVMT that is driverless:

<pre style="font-size: 11px">
#Function calculates average speed smoothing adjustment by vehicle type
  calcAveSpdSmAdj <- function(vt, ma) {
    #Calculate DVMT proportions by Cl and Rc for each Marea
    DvmtProp_Rc <- DvmtProp_ls[[vt]][ma,]
    DvmtProp_ClRc <-
      sweep(CongProp_MaClRc[ma,,], 2, DvmtProp_Rc, "*")
    #Get the speed smoothing fractions inputs
    SmoothFractions_Rc <- c(
      Fwy = L$Year$Marea$FwySmooth[L$Year$Marea$Marea == ma],
      Art = L$Year$Marea$ArtSmooth[L$Year$Marea$Marea == ma],
      Oth = 0
    )
    #If there is driverless DVMT apply the ajustment functions to adjust speed smoothing fractions
    AveDriverlessDvmtProp_Rc <- AveDriverlessDvmtProp_MaRc[ma,]
    if (sum(AveDriverlessDvmtProp_Rc) != 0) {
      SmoothFractions_Rc["Fwy"] <- 
        SmoothFractions_Rc["Fwy"] * DriverlessFactor_ls[["Fwy"]](AveDriverlessDvmtProp_Rc["Fwy"])
      SmoothFractions_Rc["Art"] <- 
        SmoothFractions_Rc["Art"] * DriverlessFactor_ls[["Fwy"]](AveDriverlessDvmtProp_Rc["Art"])
    }
    #Calculate the smoothing factors from the maximum values for the vehicle
    #type and the smoothing fractions
    #Maximum practical smoothing by congestion level and road class for the metropolitan area
    SpdSmMaxFactor_ClRc <- SpdSmMaxFactors_ls[[vt]][ma,,] * 0.5
    #Apply the smoothing fractions calculated above
    SpdSmFactor_ClRc <- sweep(SpdSmMaxFactor_ClRc, 2, SmoothFractions_Rc, "*") + 1
    #Calculate the weighted average factor
    sum(SpdSmFactor_ClRc * DvmtProp_ClRc)
  }
</pre>


### CalculateVehicleOperatingCost Module Modifications

The CalculateVehicleOperatingCost module calculates the cost of operating each household vehicle and calculates the proportion of household DVMT allocated to each vehicle (owned and car service). Three operating costs are calculated:
- Out-of-pocket cost to use the vehicle including fuel (energy), maintenance/tires/repairs, road use taxes, pollution taxes (e.g. carbon tax), parking charges, and pay-as-you-drive insurance cost;
- Social costs not paid by the user including air pollution, water pollution, and energy security costs; and,
- Composite cost which is the sum of the out-of-pocket cost and the monetary equivalent of the access and travel time for using the vehicle where time is valued at the value-of-time rate established for the model (*ValueOfTime* parameter in the *model_parameters.json* file).

The module calculates the proportion of household DVMT assigned to each vehicle based on the composite operating cost for each vehicle and assuming a Cobb-Douglas utility. This is explained in detail in the module documentation.

The average vehicle out-of-pocket operating cost per mile for the household is calculated from the out-of-pocket operating cost of each vehicle and the household DVMT proportion assigned to each vehicle.

Modifications will be made to account for the following effects of driverless vehicles:
1. Effect on lower travel time disutility for travel in driverless vehicles;
2. Effect on household DVMT of additional driverless trips (i.e. shuttling non-drivers and parking avoidance)
3. Relative passenger occupancy of car services; and,
4. Deadhead mileage of car services.

Sections below describe how each of these effects will be accounted for. A new input file, *region_driverless_use_parameters.csv* will contain parameters used in the calculation of driverless vehicle use effects as described below. In addition, the additional car service inputs - *HighCarSvcDeadheadProp*, *LowCarSvcDeadheadProp*, *HighCarSvcOccupancy*, *LowCarSvcOccupancy* - processed by the CreateVehicleTable module will be used in the calculation of car service effects.

#### Effect of Lower Travel Time Disutility for Driverless Vehicles

The *region_driverless_use_parameters.csv* will include a field specifying a factor for adjusting the value of time for traveling in a driverless vehicle (*DriverlessVotAdj*). For example a value of 0.8 would mean that the value of time for travel in a driverless vehicle would be 80% of the value of time in a driven vehicle. This factor will be applied to the calculation of composite cost and will affect the proportion of household travel allocated to driverless vehicles.

In addition to affecting the proportion of household travel in driverless vehicles, the *DriverlessVotAdj* factor will affect the additional distance traveled due to lower travel time disutility. To do this, a model will be estimated which calculates the proportional increase in DVMT expected for a vehicle as a function of the driverless vehicle value of time adjustment and proportion of the vehicle composite cost that is travel time cost. After the starting value of household DVMT is allocated to household vehicles, the 

A new file, **region_driverless_vehicle_parameters.csv**, would include proportions of vehicles that are driverless by type and factors that are used in calculating how much additional travel a household might do because they have a driverless vehicle. Following are the fields and their meanings:
- DriverlessTimeUtilityAdj: Factors for the corresponding year that are used to adjust the travel time component of composite vehicle operating cost of driverless vehicles. For example, a value of 0.8 means that the travel time in a driverless vehicle is 80% as onerous as the travel time in a vehicle that is not driverless. Values for intervening years are interpolated.
- DriverlessTripAdj: Factors for the corresponding year that are used to adjust the amount of travel in driverless vehicles to account to additional trip-making made possible by driverless vehicles (e.g. trips by non-drivers, trips to avoid parking). Values for intervening years are interpolated. 

The CalculateVehicleOperatingCost module does several things that are relevant to the estimation of the effects of driverless vehicles and car services on light-duty vehicle travel including:
- Calculating the operating cost for each vehicle. Operating cost is 
#### CalculateRoadPerformance Module Modifications


