# VE Modifications to Improve Representation of Driverless Vehicles and Car Services
**Brian Gregor, Oregon Systems Analytics**
**10/8/19**  

## Issue

VisionEval models address some of the potential effects of driverless vehicles on travel, but don't address several important effects. The capability exists for model users to simulate the effects of the deployment of driverless vehicles in car services on vehicle ownership and relative car service use. Users can change the car service prices and service levels to reflect the effects of deploying driverless vehicles (which should lower labor costs, thus lowering prices and increasing service levels). The model adjusts vehicle ownership and the effective number of vehicles available as a function of car service prices. It also adjusts the relative use of car services as a function of relative car service prices. Presently, however, no guidance is provided to users on when or how the deployment of driverless vehicles in car services is likely to affect price or service levels. Several other important effects of driverless vehicles can't be analyzed using VisionEval models. These include the effects of driverless vehicles on road performance (congestion, delay, accidents, reliability) and how the ownership of driverless vehicles could affect the amount of travel by increasing the number and length of vehicle trips. 

It should be noted that the term *driverless* is used instead of *autonomous* because driverless refers to a level of vehicle autonomy which enables vehicles to travel without human intervention (other than identifying where the vehicle goes). Other levels of autonomy require drivers to monitor and intervene in vehicle operation to some degree. Driverless automony has the potential for substantially changing travel behavior and road performance by:
- Allowing all vehicle occupants to spend their time while traveling doing things that are more enjoyable than driving, potentially reducing the disutility of travel and increasing the amount of travel;
- Substantially reducing the cost of car service travel by eliminating driver labor cost;
- Enabling vehicles to shuttle non-drivers (e.g. children);
- Enabling vehicles to travel unoccupied in order to avoid parking costs and/or difficulties; and,
- Allowing vehicles to operate in a harmonized fashion at greater densitites on highways.
While lower levels of vehicle autonomy can increase travel safety and comfort, their effects on vehicle travel and road performance are likely to be a small fraction of the effects of driverless vehicles. Therefore only driverless autonomy is being considered.

Following are effects of driverless vehicles proposed to be included in VisionEval:
1. **Effect of driverless vehicles on highway capacity and emissions**: Researchers have estimated that widespread deployment of connected autonomous vehicles could substantially increase highway capacity as a result of better harmonized traffic flows, shorter headways, and lower crash rates. More harmonized traffic flows will also result in lower emissions (for internal combustion engine vehicles) because less fuel will be wasted due to operation at more constant traffic speeds.
2. **Effect of driverless vehicles on distance traveled**: The use of driverless vehicles may increase the distances that people are willing to travel because vehicle travel is made less onerous. Travelers can spend their time doing more enjoyable or productive things than driving their vehicles.
3. **Effect of driverless vehicles on unoccupied vehicle trips**: Driverless vehicles will enable and perhaps encourage trips to be made that are now not possible. Having a driverless vehicle may make it possible for a traveler to avoid parking difficulties and/or fees by sending the vehicle to a more remote location to park (such as sending it back home) or by having the vehicle circulate in taffic until it is needed.

It also possible that driverless vehicles may result in a greater number of passenger trips. For example, adults who are incapable of driving or children may be able to travel by personal vehicle unaccompanied by a driver. Moreover, the availability of driverless vehicles could affect vehicle ownership by allowing these persons to travel independently by personal vehicle. Adding the capabilities to model these potential effects, however, would be a complex endeavor that is beyond the scope of this project. It would likely require a substantial amount of basic research and modification of the household driver, vehicle ownership, and travel models. 

Although widespread ownership of driverless vehicles could substantially increase the amount of vehicle travel for the reasons noted above, the deployment of driverless vehicles by car services might have the opposite effect. The use of driverless vehicles by car services could substantially reduce fares and in so doing increase the proportion of households who opt for using car services in lieu of owning a car. For those households, vehicle travel would likely be reduced because the sunk cost of vehicle travel would be lower and the variable cost of vehicle travel would be higher. Such reductions would be offset to some degree, however, because lower car service fares would also encourage travelers to use car services rather than other non-car modes (e.g. bus, walk, bike). VisionEval modules currently enable users to address these effects to some degree as follows:
- Car service is categorized as high or low level service. With high level service, car service access time (waiting for pickup and walking time at drop-off) is competitive with owned vehicle access time (walking to parking, parking, and walking from parking). High level service is what is now available by TNCs like Uber and Lyft in many urban areas. Users can set up a scenario with assumptions about how driverless vehicle technology might affect the extent of high level service.
- The user specifies fares ($/mile) for high level and low level service. Fare assumptions can reflect assumptions about the deployment of driverless vehicles and their effect on lowering labor costs.
- The AdjustVehicleOwnership module in the VEHouseholdVehicles package adjusts household vehicle ownership by comparing the cost of ownership with the cost of car service use for households living in places where high level car service is available. A household vehicle would qualify for substitution if the ownership cost per mile of travel is greater than the car service cost. Whether or not a substitution is made also depends on user assumptions about other factors that would affect subsitutability. For example, some households own light trucks to use for towing an RV, boat, or other trailer; a use that a car service would not provide. These assumptions are encoded in substitution probabilities for automobiles (AutoCarSvcSubProp) and light trucks (LtTrkCarSvcSubProp).
- High level car service is considered to be the same as car ownership in applying statistical models in which car ownership is an independent variable. In households that own fewer vehicles than there are drivers and living in a place where high level car service is available, effective vehicle ownership is increased so that there are as many cars as drivers. This affects the calculation of non-budget-constrained household DVMT (CalculateHouseholdDvmt module).
- Household DVMT is adjusted to reflect budget constraints by the CalculateVehicleOperatingCost and BudgetHouseholdDvmt modules. The CalculateVehicleOperatingCost module calculates the out-of-pocket cost of using each household vehicle owned by the household and car services available to the household. Household DVMT is allocated to each vehicle (including car services) based on the composite operating cost (out-of-pocket and travel time) of using each household vehicle. The average out-of-pocket cost per vehicle mile for each household is calculated from the respective out-of-pocket costs and proportional allocation of travel for household vehicles. The average cost is used by the BudgetHouseholdDvmt module to adjusts the household's DVMT to fit within the household's vehicle travel budget.
- Travel by non-auto modes (i.e. non-auto public transit, walk, bike) is calculated as a function of the budget-adjusted household DVMT.

Although VisionEval modules enable many of the effects of driverless vehicles in car services to be modeled, the current approach only accounts for fare-mileage, not for deadhead mileage (i.e. travel between drop off of one passenger and pick up of the following passenger). As a result, the benefits of car services (e.g. reduced congestion and emissions) may be overestimated. It has been reported that the deadhead mileage of TNC drivers is substantial. Modules will be modified to correct this oversight.

VisionEval modules also do not account for how the relative passenger occupancy of car service vehicles affects car service DVMT. Shared car service use (i.e. carrying multiple passengers) would result in less DVMT than single-occupant car service use. While adding the capability for modeling the effect of relative passenger occupancy is desireable, doing so would require substantial changes to how travel is modeled. Currently, household travel is modeled as the aggregate DVMT for the household. Modeling the effect of relative passenger occupancy would require stratifying household DVMT into single-occupancy and multiple-occupancy categories, and a method would need to be developed for allocating each stratum to car service travel. Modifying VisionEval modules to do this would require a substantial amount of research and redesign that is beyond the authorized scope of work.

## Approach

The objective is to account for the car service and autonomous vehicle effects listed above with the smallest set of changes to the VisionEval module models and code base. As such, the changes should keep existing module models (e.g. household DVMT model) in their present form instead of specifying and estimating new models that incorporate driverless-vehicle-related parameters. Consequently, the model calculations will be modified by applying factors, many or most of which are assumed, rather than by respecifying and reestimating models. One new module will be created and six other modules will be modified in the following sequence: CreateVehicleTable, AssignDriverlessVehicles (new), CalculateRoadDvmt, CalculateRoadPerformance, CalculateMpgMpkwhAdjustments, CalculateVehicleOperatingCost, and BudgetHouseholdDvmt. Developing the modules in this sequence will enable each to the thoroughly tested and will provide datasets needed for each subsequent module to be developed and tested. Following are descriptions of what will be done in each of these modules.

### CreateVehicleTable Module

Among other things, the CreateVehicleTable module processes the car service inputs in the **azone_carsvc_characteristics.csv** file. This file will be modified to include factors which specify deadhead proportions for high level car service and for low level car service (HighCarSvcDeadheadProp, LowCarSvcDeadheadProp) by Azone and year. Deadhead proportion will be defined as deadhead mileage divided by fare mileage. That will enable the total car service mileage to be easily computed from the the household car service use. Guidelines will be provided to assist users in specifying plausible values for these inputs.

### AssignDriverlessVehicles Module

This new module will determine which household vehicles are driverless. It will also determine for car service vehicles, commercial service vehicles, heavy trucks and public transit vehicles the proportions of DVMT that are driverless. These proportions will be specified in the *region_driverless_vehicle_prop.csv* file which has the following fields:
- Year: identify years in 5 or 10 year intervals (e.g. 2010, 2020, etc.) covering the entire range of years that might be modeled.
- AutoDriverlessProp: The proportion of automobiles sold in the corresponding year that are driverless. Values for intervening years are interpolated.
- LtTrkDriverlessProp: The proportion of light trucks sold in the corresponding year that are driverless. Values for intervening years are interpolated.
- LowCarSvcDriverlessProp: The proportion of the car service fleet DVMT in low car service areas in the corresponding year that are driverless. Values for intervening years are interpolated.
- HighCarSvcDriverlessProp: The proportion of the car service fleet DVMT in high car service areas in the corresponding year that are driverless. Values for intervening years are interpolated.
- ComSvcDriverlessProp: The proportion of the commercial service vehicle fleet DVMT in the corresponding year that are driverless. Values for intervening years are interpolated.
- HvyTrkDriverlessProp: The proportion of the heavy truck fleet DVMT in the corresponding year that are driverless. Values for intervening years are interpolated.
- PtVanDriverlessProp: The proportion of public transit van DVMT in the corresponding year that are driverless. Values for intervening years are interpolated.
- BusDriverlessProp: The proportion of bus fleet DVMT in the corresponding year that are driverless. Values for intevening years are interpolated.

The values in this file will be stored in the *RegionDriverlessProps* table in the *Global* group of the datastore. The module's *Inp* specifications will recognize these inputs and the new table will be specified in the module's *NewInpTable* specification.

Note that the assumed driverless values for household automobiles and light trucks are proportions of sales by vehicle model year, whereas the values for car service vehicles, commercial service vehicles, and heavy trucks are proportions of fleet DVMT for the year. Guidelines will be provided to assist users in specifying plausible values for these inputs. Also note that this approach requires the assumption that driverless proportions will reflect a common statewide market instead of regional (e.g. metropolitan markets) so users would not be able to specify different scenario assumptions for different portions of the state. This approach is necessary because the years in the table are not model run years, they are benchmark years that are used via interpolation to calculate values for each vehicle model year (for owned vehicles) or model run year for fleet vehicles. The approach is also reasonable given that there is a large amount of uncertainty about how driverless vehicles will be adopted/deployed.

It is assumed that driverless vehicles used by households will be retired at the same rate as other household vehicles. thus the probability that a vehicle is driverless is determined by the sales proportion for the model year corresponding to its age. It is proposed that at the present time, no additional criteria will be used to assign driverless vehicles to households. The probability that a household vehicle is driverless will therefore be a function of the vehicle age and proportion of vehicles of that age assumed to be driverless. (Note that since the ages of vehicles owned by a household is a function of household income, the probabilities that household vehicles are driverless will be a function of household income as well.) 

The module's Get specifications will include specifications for retrieving the datasets described above. In addition, they will specify retrieval of the following datasets:
- *HhId*, *Age*, *Type*, and *VehicleAccess* from the *Vehicle* table;
- *HhId*, *NumLtTrk*, *NumAuto*, and *NumHighCarSvc* from the *Household* table

This module will be run after the AdjustVehicleOwnership module is run. Household vehicles of each age and type will be randomly assigned as driverless given the assigned probability for the age and type. The assignments will be recorded in the *Driverless* dataset in the *Vehicle* table with a value of 1 for driverless vehicles owned by the household and 0 for other household vehicles. Car services assigned to the household will be assigned the LowCarSvcDriverlessProp value or HighCarSvcDriverlessProp value for the car service level applicable to the household.

The module will also calculate a preliminary estimate of the proportion of household DVMT that is in driverless vehicles. This will be stored in the *DriverlessDvmtProp* dataset in the *Household* table. This is necessary in order for the CalculateRoadPerformance module to calculate the effects of driverless vehicles on road performance. These preliminary estimates will be based on the assumption that household DVMT is split equally among vehicles available to the household (excluding low level car service). This can be calculated from the vehicle data for each household by selecting the *Driverless* values where *VehicleAccess* is not equal to *LowCarSvc*. The preliminary estimate of the driverless DVMT proportion for the household will be the sum of the selected *Driverless* values divided by the number of selected values. Note that these preliminary estimates are refined to reflect a more realistic distribution of household DVMT among vehicles and account for low level car service use, car service deadhead, relative car service occupancy, and potential for greater use of driverless vehicles by the CalculateVehicleOperatingCost module.

The Set specifications for the module will save the following:
- *DriverlessDvmtProp* in the *Household* table; and,
- *Driverless* in the *Vehicle* table.

### CalculateRoadDvmt Module

The CalculateRoadDvmt module calculates the light-duty vehicle, heavy truck, and bus DVMT on urbanized area roads and on roads outside the urbanized area in each Marea. These values are used by the *CalculateRoadPerformance* module to model roadway congestion and its effects in urbanized areas. (Congestion on roads outside of urbanized areas is not modeled.) Since driverless vehicles will affect road congestion, the CalculateRoadDvmt module needs to be modified to calculate the proportions of light-duty vehicle, heavy truck, and bus DVMT that are driverless.

To make the calculations, the module Get specifications will be modified to load the following the datasets:
- From the *RegionDriverlessProps* table in the *Global* group, load the *Year*, *ComSvcDriverlessProp*, *HvyTrkDriverlessProp*, *PtVanDriverlessProp*, and *BusDriverlessProp* datasets.
- From the *Household* table in the relevant year group(s) load the *DriverlessDvmtProp* dataset.

The module will create 4 additional datasets that will be stored in the *Marea* table of the relevant year group(s): *LdvDriverlessProp*, *HvyTrkDriverlessProp*, *BusDriverlessProp*, and *AveDriverlessProp*. The module Set specifications will be modified accordingly to specify the attributes of these datasets.

The module code will be modified to calculate *LdvDriverlessProp*, *HvyTrkDriverlessProp*, and *BusDriverlessProp* by Marea as follows:
1. An approximation function will be defined to calculate the driverless DVMT proportions for commercial service vehicles, heavy trucks, public transit vans, and buses for the model run year from the data in the *RegionDriverlessProps* table in the *Global* group. This function will be the same as or very similar to the *approxWithNaCheck* function defined in the *CalculateComEnergyAndEmissions* module function. The function will be called with each of the *ComSvcDriverlessProp*, *HvyTrkDriverlessProp*, *PtVanDriverlessProp*, and *BusDriverlessProp* datasets loaded from the *RegionDriverlessProp* table along with the *Year* dataset from that same table, and the model run year to calculate the respective driverless DVMT proportions for the model run year.
2. The Marea values for *HvyTrkDrivelessProp* and *BusDriverlessProp* will be set equal to the respective driverless proportions calculated in #1 above for the model run year. Note that values are the same for all Mareas.
3. The average household driverless DVMT proportion for each Marea will be calculated from the *Dvmt* and *DriverlessDvmtProp* values for households residing in the Marea.
4. The *LdvDriverlessProp* value will be calculated for each Marea as a DVMT weighted average of the average household driverless DVMT proportion (step 3) for the Marea, *ComSvcDriverlessProp*, and *PtVanDriverlessProp*. The respective DVMT weightings are the respective metropolitan area DVMT for households, commercial service vehicles and public transit vans. Following is an example of what code could be inserted at line 868

<pre style="font-size: 11px">
HhDriverlessDvmtProp_Ma <- setNames(numeric(length(Ma)), Ma)
for (ma in Ma) {
  HhDriverlessDvmtProp_Ma[ma] <- local({
    IsMa <- L$Year$Household$Marea == ma
    Dvmt_Hh <- L$Year$Household$Dvmt[IsMa]
    DriverlessProp_Hh <- L$Year$Household$DriverlessDvmtProp[IsMa]
    sum(DriverlessProp_Hh * Dvmt_Hh) / sum(Dvmt_Hh)
  })
}
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

Functions will be added to the CalculateRoadPerformance module code to adjust the input values for other operations effectiveness to reflect the proportion of DVMT that is driverless. Since there are 20 other operations effectiveness values, there could be as many as 20 functions. However, given the complexity of defining and applying 20 functions, it makes more sense to at most define 4 functions, one for each combination of facility type (freeway, arterial) and congestion type (recurring, nonrecurring). These functions could be linear functions of the driverless DVMT proportion, but are more likely to be nonlinear because the research literature indicates that the effect of driverless vehicles on congestion are likely to be nonlinear. These functions will be defined in *Section 1C* of the *CalculateRoadPerformance.R* script. For the purposes of the explanation below, the functions are assumed to be define in a list named *DriverlessFactor_ls* with components named *Art_Rcr*, *Art_NonRcr*, *Fwy_Rcr*, and *Fwy_NonRcr*. The argument to the function will be driverless DVMT proportion (*DriverlessDvmtProp*). The output of the function will be a factor between 0 and 1 that is used to adjust the other operations effectiveness values.

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

The call to the *balanceFwyArtDvmt* function (lines will be changed to populate the list of speed and delay data by metropolitan area (*SpeedAndDelay_ls*) to incorporate the results of the function call. This list is used by other portions of the main function code. Code like the following would be added at line 1758:

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
- Social/environmental costs including air pollution, water pollution, and energy security costs; and,
- Composite cost which is the sum of the out-of-pocket cost and the monetary equivalent for the time spend accessing and traveling in the vehicle.

The composite cost is used to allocate household DVMT between vehicles used by the household; owned and car service. The module calculates the proportion of household DVMT assigned to each vehicle based on the composite operating cost for each vehicle and assuming a Cobb-Douglas utility. This is explained in detail in the module documentation. The composite cost for each vehicle is calculated by summing:
1. The out-of-pocket cost per mile of travel for using the vehicle;
2. The in-vehicle travel time cost per mile of travel calculated as the product of the average travel rate (inverse of travel speed) for the metropolitan area and the value-of-time rate established for the model;
3. The vehicle access time cost per mile of travel which is calculated by first calculating the average vehicle trip length for the household and using that along with the input assumptions on average access time for owned and car service vehicles to calculate an equivalent travel rate. As with with the calculation of in-vehicle travel time cost, this travel rate is multiplied by the value-of-time rate to compute the equivalent access time cost.

After household DVMT is allocated to vehicles based on the respective composite costs, the average out-of-pocket cost per vehicle mile is calculated for the household. This is used by the *BudgetHouseholdDvmt* module to adjust household travel so that travel expenditures fit within the household travel budget. In addition, the average social/environmental cost per mile and the road tax revenue per mile are calculated. The latter is used by the BalanceRoadCostsAndRevenues module.

Modifications will be made to the CalculateVehicleOperatingCost module to account for the following effects of driverless and car service vehicle travel:
- Lower travel time disutility for travel in driverless vehicles;
- Lower access time made possible by driverless vehicles through remote control;
- Parking fee avoidance made possible by driverless vehicles through remote control;
- Additional driverless vehicle travel through remote control;
- Deadhead mileage of car services.

These modifications will have the following parts.
1. Modification of existing code to incorporate the effect of driverless vehicles on the allocation of household DVMT among household vehicles.
2. Adding code to calculate adjustments to the DVMT assigned to each owned driverless vehicle to account for additional travel that may occur.
3. Adding code to calculate adjustments car service travel to account for deadhead mileage. 
4. Adding/modifying code to calculate household totals and averages used in this and other modules including (dataset names in parethesis, new dataset in bold):  
   a. Total DVMT including the additional driverless DVMT and car service deadhead (Dvmt)  
   b. Proportion of total DVMT that is the added driverless DVMT (**DriverlessDvmtAdjProp**)  
   c. Proportion of total DVMT that is the added car service deadhead mileage (**DeadheadDvmtAdjProp**)  
   d. Proportion of total DVMT that is driverless (**DriverlessDvmtProp**)  
   e. Average out-of-pocket vehicle cost per mile excluding car service deadhead mileage (AveVehCostPM)  
   f. Average social/environmental cost per mile based on total DVMT (AveSocEnvCostPM)  
   g. Average road use tax per mile (AveRoadUseTaxPM)  
   h. Average gallons per mile based on total DVMT (AveGPM)  
   i. Average kilowatts per mile based on total DVMT (AveKWHPM)  
   j. Average CO2e per mile based on total DVMT (AveCO2ePM)  

The Set specifications for the module will be modified to include saving the *Dvmt*, *DriverlessDvmtAdjProp*, *DeadheadDvmtAdjProp*, and *DriverlessDvmtProp* values noted in #4 above. 

The code will be written in recognition that this module and others in the VETravelPerformance package are run in an iterated manner to balance amounts of travel, congestion, travel costs, travel budgets, and road revenues. Iteration makes it necessary to carry out calculations in a manner which avoids 'double-counting' the vehicle mileage adjustments. To avoid double counting, the driverless vehicle mileage adjustments and car service mileage adjustments are removed from the household total DVMT if they have been added in a previous iteration. This is determined by checking whether there are values for *DriverlessDvmtAdjProp* and *DeadheadDvmtAdjProp*. This will be established by identifying these datasets as OPTIONAL in the *Get* specifications for the module, and then determining whether they exist in the *Year$Household* component of the dataset list provided to the module function. After those components are removed from total household DVMT, the module calculations are run to allocate household DVMT to vehicles, calculate added driverless and deadhead travel, and to recalculate household totals and averages. 

The calculations to account for the effects of driverless vehicles require additional parameters supplied by the user. These will be in a new input file, **region_driverless_vehicle_parameters.csv**. The file will contain the following fields:
- RunTimeUtilityAdj: This factor is used to adjust the travel time component of composite vehicle operating cost of driverless vehicles. For example, a value of 0.8 means that the travel time in a driverless vehicle is 80% as onerous as the travel time in a vehicle that is not driverless. This factor will be applied to the travel time rate for driverless vehicles owned by the household in the calculation of composite cost. It will also be used in the calculation of added driverless vehicle travel as explained below.
- AccessTimeUtilityAdj: This factor is used to adjust the access time component of composite vehicle operating cost of driverless vehicles when vehicle access is remotely controlled. It's application is described in the following section.  
- PropRemoteAccess: This factor specifies the proportion of trips in driverless vehicles for which travelers use capabilities of driverless vehicles to remotely control their vehicles to avoid having to park their vehicle and retrieve their vehicle from parking. This includes remote access to avoid parking the vehicle or to park the vehicle in more remote locations to avoid or reduce parking charges.
- RemoteAccessDvmtAdj: This factor specifies the proportional adjustment to driverless vehicle DVMT assumed to occur as a result of remote vehicle access for convience, avoiding parking, and/or avoiding/reducing parking charges.
- PropParkingFeeAvoid: This factor specifies the proportion of parking fees avoided for travel in owned driverless vehicles.

Sections below describe calculations in each of the 4 parts listed above use these additional parameters and the new deadhead parameters (*HighCarSvcDeadheadProp*, *LowCarSvcDeadheadProp*) described previously.

#### Incorporate the Effect of Driverless Vehicles on the Allocation of Household DVMT Among Household Vehicles

Existing module code will be modified to incorporate the effect of driverless vehicles on the allocation of household DVMT among household vehicles. A new step will be added near the beginning of the code to check whether the module has been run in a previous iteration as described above. If so, the household DVMT will be revised to remove the added driverless DVMT and the car service deadhead DVMT as follows:

<pre style="font-size: 11px">
Dvmt = Dvmt * (1 - (DriverlessDvmtAdjProp + DeadheadDvmtAdjProp))
</pre>

The effect of driverless vehicles on the allocation of DVMT among household vehicles will be carried out by modifying the calculation of driverless vehicle parking cost, running time cost, and access time cost. The existing module code calculates an average parking cost rate per vehicle-mile traveled and applies that to each vehicle owned by the household. The code in the local function for calculating the parking cost rate (*ParkingCostRate_Ve*) will be modified by adjusting the parking cost rate for driverless vehicles by the proportion of parking fees avoided (*PropParkingFeeAvoid*) as follows:

<pre style="font-size: 11px">
IsDriverless <- L$Year$Vehicle$VehicleAccess == "Own" & L$Year$Driverless == 1
ParkingCostRate_Ve[IsDriverless] <- ParkingCostRate_Ve[IsDriverless] * (1 - PropParkingFeeAvoid)
</pre>

The effect of driverless vehicles on running time cost and access time cost will be carried out by modifying the local function for calculating the travel time cost rate (*TTCostRate_Ve*). This will be done by modifying the running time cost rate (*RunTimeRate_Ve*) by the *RunTimeUtilityAdj* factor and access time rate (*AccTimeRate_Ve*) by the *AccessTimeUtilityAdj* and *PropRemoteAccess* factors. Code similar to the following would be inserted before *RunTimeRate_Ve* and *AccTimeRate_Ve* are summed:

<pre style="font-size: 11px">
IsDriverless <- L$Year$Vehicle$VehicleAccess == "Own" & L$Year$Driverless == 1
RunTimeRate_Ve[IsDriverless] <- RunTimeRate_Ve[IsDriverless] * RunTimeUtilityAdj
AccTimeRate_Ve[IsDriverless] <- AccTimeRate_Ve[IsDriverless] * ((1 - PropRemoteAccess) + (AccessTimeUtilityAdj * PropRemoteAccess))
</pre>

#### Calculate Driverless Vehicle DVMT Adjustments

Driverless vehicle DVMT will be adjusted to account for additional travel resulting from the greater passenger trip distances due to lower travel time disutility and the additional travel resulting from remote vehicle operation (e.g. to avoid parking cost). These effects will be calculated for each driverless vehicle and the results will be added to the DVMT initially allocated. 

Vehicle DVMT is not currently calculated for each vehicle so the code will need to calculate it from the household DVMT and the vehicle DVMT split that is calculated:

<pre style="font-size: 11px">
Dvmt_Ve <- DvmtProp_Ve * Dvmt_Hh[HhToVehIdx_Ve]
</pre>

The added distance for passenger trips in driverless vehicles will be calculated by comparing the composite cost rate calculated for each driverless vehicle with what the composite cost rate would be without considering the effect of the *RunTimeUtilityAdj* factor. The adjustment of travel distance to account for the lower travel time disutility would be the ratio of the composite cost rate not considering the utility adjustment to the composite cost rate considering the utility adjustment. For example, if the composite cost rate for a driverless vehicle considering the utility adjustment is $1.00 and not considering adjustment is $1.10, the increase in DVMT for that vehicle would be 10%.

Several changes to module code will be made to implement this calculation. 
1. The local function which calculates the TTCostRate_Ve will be converted into a named function with arguments so that it can be called with a flag to adjust the run time rate or not. Then this function will be called twice; once to calculate TTCostRate_Ve with the run time rate reflecting the utility adjustment, and again to calculate AltTTCostRate_Ve without the utility adjustment. 
2. A new function will be defined to calculate composite cost (*calcCompositeCost*). This functionality is now contained in the local function which calculates DvmtProp_Ve. That local function will be modified to call the *calcCompositeCost* function in order to compute the DVMT split ratios.
3. To calculate the factor for increasing passenger DVMT in driverless vehicles owned by the household, the *calcCompositeCost* function will be run with the AltTTCostRate_Ve dataset and with the TTCostRate_Ve dataset. The ratio of the first to the second will be calculated from which 1 will be subtracted. This will provide the desired result of the proportional increase in passenger DVMT due to the lower disutility of travel in a driverless vehicle (PassengerDvmtAdj_Ve). The Added passenger DVMT would be calculated as follows:

<pre style="font-size: 11px">
AddPassengerDvmt_Ve <- Dvmt_Ve * PassengerDvmtAdj_Ve
</pre>

The added remote vehicle operations travel will be calculated by multiplying the initial driverless vehicle DVMT by the *PropRemoteAccess* and *RemoteAccessDvmtAdj* factors as follows:

<pre style="font-size: 11px">
AddRemoteAccessDvmt_Ve <- Dvmt_Ve * PropRemoteAccess * RemoteAccessDvmtAdj
</pre>

Note that AddPassengerDvmt_Ve and AddRemoteAccessDvmt_Ve will be 0 for non-driverless owned vehicles and car services.

#### Car Service Deadhead DVMT

The code for adjusting car service DVMT to account for deadhead mileage will be straightforward.

<pre style="font-size: 11px">
DeadheadDvmt_Ve <- Dvmt_Ve * 0
DeadheadDvmt_Ve[VehAccType_Ve == "LowCarSvc"] <- Dvmt_Ve[VehAccType_Ve == "LowCarSvc"] * LowCarSvcDeadheadProp
DeadheadDvmt_Ve[VehAccType_Ve == "HighCarSvc"] <- Dvmt_Ve[VehAccType_Ve == "HighCarSvc"] * HighCarSvcDeadheadProp
</pre>

#### Recalculate DVMT Allocation Among Household Vehicles and Total Household DVMT

Adjusted vehicle DVMT will be calculated by summing the initial allocation and the driverless vehicle and car service deadhead adjustments as follows:

<pre style="font-size: 11px">
Dvmt_Ve <- Dvmt_Ve + AddPassengerDvmt_Ve + AddRemoteAccessDvmt_Ve + DeadheadDvmt_Ve
</pre>

The DVMT proportional split among household vehicles would be calculated as follows:

<pre style="font-size: 11px">
DvmtProp_Ve <- local({
  Dvmt_Hh_Ve <- lapply(split(Dvmt_Ve, L$Year$Vehicle$HhId), function(x) x / sum(x))
  names(Dvmt_Hh_Ve) <- NULL
  unlist(Dvmt_Hh_Ve, use.names = TRUE)[L$Year$Vehicle$VehId]
})
</pre>

These adjusted DVMT proportions will be calculated prior to the existing code which calculates household average rates (per vehicle-mile) for out-of-pocket cost (AveVehCostPM), social/environmental cost (AveSocEnvCostPM), road use tax (AveRoadUseTaxPM), fuel consumption (AveGPM), electricity consumption (AveKWHPM), and greenhouse gas production (AveCO2ePM). 

The presence of deadhead mileage in household DVMT requires the average out-of-pocket cost for the household to be calculated differently than the other listed averages. While the social/environmental cost, road use tax, fuel consumption, electricity consumption, and greenhousehouse gas production are a function of total DVMT attributable to the household, out-of-pocket cost does not apply to deadhead mileage. The calculation of out-of-pocket cost (AveVehCostPM_Hh in the script) will be calculated as follows:

<pre style="font-size: 11px">
AveVehCostPM_Hh <- local({
  VehCostPM_Ve <-
    MRTCostRate_Ve + EnergyCostRate_Ve + RoadUseCostRate_Ve +
    ClimateCostRate_Ve + SocialCostRate_Ve + ParkingCostRate_Ve +
    PaydInsCostRate_Ve + CarSvcCostRate_Ve
  AdjDvmt_Ve <- Dvmt_Ve - DeadheadDvmt_Ve
  TotCost_Hh <- tapply(VehCostPM_Ve * AdjDvmt_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  AdjDvmt_Hh <- tapply(AdjDvmt_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
  TotCost_Hh / AdjDvmt_Hh
})
</pre>

Code will be added to update the DVMT attributable to the households which includes the added travel due to the use of driverless vehicles and car service vehicle deadheading. In addition, code needs to added to calculate the values listed in 4 b-d above (DriverlessDvmtAdjProp, DeadheadDvmtAdjProp, DriverlessDvmtProp). Code such as the following will be added:

<pre style="font-size: 11px">
#Recalculate total household DVMT
Dvmt_Hh <- tapply(VehCostPM_Ve * DvmtProp_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
#Calculate proportion of household DVMT that is driverless DVMT adjustment
DriverlessDvmtAdj_Hh <- 
  tapply(AddPassengerDvmt_Ve + AddRemoteAccessDvmt_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
DriverlessDvmtAdjProp_Hh <- DriverlessDvmtAdj_Hh / Dvmt_Hh
#Calculate proportion of household Dvmt that is car service deadhead Dvmt
DeadheadDvmtAdj_Hh <- tapply(DeadheadDvmt_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
DeadheadDvmtAdjProp_Hh <- DeadheadDvmtAdj_Hh / Dvmt_Hh
#Calculate proportion of household Dvmt in driverless vehicles
DriverlessDvmt_Hh <- tapply(Dvmt_Ve * Driverless_Ve, L$Year$Vehicle$HhId, sum)[L$Year$Household$HhId]
DriverlessDvmtProp_Hh <- DriverlessDvmt_Hh / Dvmt_Hh
</pre>

Existing code will calculate the other averages.

The Set specifications for the module will be changed to save the adjusted DVMT values (Dvmt), DriverlessDvmtAdjProp, DeadheadDvmtAdjProp, and DriverlessDvmtProp values in the household table of the datastore, as well as saving the HhDriverlessDvmtProp dataset in the marea table. 

### BudgetHouseholdDvmt Module

The BudgetHouseholdDvmt module calculates the total out-of-pocket cost of vehicle travel for the household, calculates a household budget for vehicle travel, and compares the vehicle travel cost to the household budget. If the vehicle travel cost exceeds the budget for a household, the module adjusts the household vehicle travel so that it fits within the budget. After the budget-adjusted household DVMT is calculated, the module calls the CalculateVehicleTrips and CalculateAltModeTrips modules to calculate vehicle, transit, bike, and walk trips for the household as a function of the budget-adjusted household DVMT. Several changes need to be made this module to address the effects of driverless vehicles and car service deadhead mileage as follows:
1. The current module calls the CalculateHouseholdDvmt module to calculate the household DVMT. This will be changed to instead use the *Dvmt* dataset in the *Household* table of the datastore that is produced by the *CalculateVehicleOperatingCost* module.
2. The household DVMT will be adjusted to remove the car service deadhead mileage. The household budget will be compared to the cost of traveling this adjusted mileage.
3. After budget adjustments are made to the adjusted mileage, the car service deadhead mileage will be added back using the DeadheadDvmtAdjProp factor so that impacts calculations reflect total DVMT attributable to the household.
4. The CalculateVehicleTrips and CalculateAltModeTrips modules will be called using the budget-adjusted DVMT exclusive of car service deadhead mileage.

Using the household DVMT produced by the CalculateVehicleOperatingCost module requires the following changes:
- Adding a Get specification for *Dvmt* from the *Household* table.
- Removing the Call specification for the *CalculateHouseholdDvmt* module
- Removing the code `Dvmt_Hh <- M$CalcDvmt(L$CalcDvmt)$Year$Household$Dvmt`
- Substituting the code `Dvmt_Hh <- L$Year$Household$Dvmt`

The local function which applies the budget adjustments and produces a list of adjusted values (*Adj_ls*) will be modified to calculate and use household DVMT without car service deadhead mileage. The results that are returned from the function will include the budget-adjusted DVMT without deadhead miles along with DVMT with deadhead mileage. The code would be something like the following. Key differences with the existing function are shown in bold.

<pre style="font-size: 11px">
Adj_ls <- local({
  #Calculate DVMT without car service deadhead miles
  <b>DhAdjProp <- L$Year$Household$DeadheadDvmtAdjProp</b>
  <b>NoDhDvmt_Hh <- Dvmt_Hh * (1 - DhAdjProp)</b>
  #Calculate budget based on the adjusted income
  VehOpBudget_Hh <- AdjIncome_Hh * BudgetProp_Hh
  #Calculate the DVMT which fits in budget given DVMT cost per mile
  BudgetDvmt_Hh <- VehOpBudget_Hh / L$Year$Household$AveVehCostPM / 365
  #Adjusted DVMT is the minimum of the 'budget' DVMT and 'modeled' DVMT
  AdjDvmt_Hh <- pmin(BudgetDvmt_Hh, <b>NoDhDvmt_Hh</b>)
  #Establish a lower minimum to avoid zero values
  MinDvmt <- quantile(AdjDvmt_Hh, 0.01)
  AdjDvmt_Hh[AdjDvmt_Hh < MinDvmt] <- MinDvmt
  #Reduce DVMT to account for TDM and SOV reductions
  L$ReduceDvmt$Year$Household$Dvmt <- AdjDvmt_Hh
  AdjDvmt_Hh <- M$ReduceDvmt(L$ReduceDvmt)$Year$Household$Dvmt
  #Calculate adjusted urban and rural DVMT by Marea and location type
  AdjDvmt_MaLt <- array(0, dim = c(length(Ma), length(Lt)), dimnames = list(Ma, Lt))
  AdjDvmt_MxLx <- tapply(
    AdjDvmt_Hh,
    list(L$Year$Household$Marea, L$Year$Household$LocType),
    sum)
  AdjDvmt_MaLt[rownames(AdjDvmt_MxLx), colnames(AdjDvmt_MxLx)] <- AdjDvmt_MxLx
  AdjDvmt_MaLt[is.na(AdjDvmt_MaLt)] <- 0
  #Return list of results
    list(
      Dvmt_Hh = AdjDvmt_Hh <b>* (1 + DhAdjProp)</b>,
      UrbanDvmt = unname(AdjDvmt_MaLt[,"Urban"]) <b>* (1 + DhAdjProp)</b>,
      TownDvmt = unname(AdjDvmt_MaLt[,"Town"]) <b>* (1 + DhAdjProp)</b>,
      RuralDvmt = unname(AdjDvmt_MaLt[,"Rural"]) <b>* (1 + DhAdjProp)</b>,
      <b>NoDhDvmt_Hh <- AdjDvmt_Hh</b>
    )
})
</pre>

The code for calculating adjusted vehicle trips and alternative mode trips to use the DVMT without deadhead mileage would be modified as follows. Key modifications are shown in bold.

<pre style="font-size: 11px">
#Calculate vehicle trips
L$CalcVehTrips$Year$Household$Dvmt <- <b>Adj_ls$NoDhDvmt_Hh</b>
VehicleTrips_Hh <- M$CalcVehTrips(L$CalcVehTrips)$Year$Household$VehicleTrips
#Calculate alternative mode trips
L$CalcAltTrips$Year$Household$Dvmt <- <b>Adj_ls$NoDhDvmt_Hh</b>
AltTrips_ls <- M$CalcAltTrips(L$CalcAltTrips)$Year$Household
</pre>
