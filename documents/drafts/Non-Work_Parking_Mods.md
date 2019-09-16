# VE Modifications for Adjusting Non-Work Parking Costs

## Issue

The parking cost model assumes that non-work travel to a Bzone pays for parking if a parking cost has been assigned to a Bzone. This approach does not allow modeling of a scenario where workers pay for their parking but shoppers (i.e. non-work) do not.

## Approach

The calculation of parking costs is done in the AssignParkingRestrictions module of the VELandUse 
package and the corresponding module in the VESimLandUse package. The issue can be resolved by changing the specifications and functions for those modules.

### Modifications to the AssignParkingRestrictions.R script in the VELandUse Package

1. Modify the bzone_parking.csv input file and specifications (Inp and Get) to add a PropNonWrkTripPay field. This input is used to determine the proportion of shopping and other non-work trips to the Bzone that pay for parking. In most scenarios the value would probably be either 1 or 0, but the user could enter any value inbetween. Note that this would not affect residential parking costs.

2. Change the AssignParkingRestrictions module code (line 440) to multiply the Bzone parking cost values by the PropNonWrkTripPay values.

### Modifications to the AssignParkingRestrictions.R script in the VESimLandUse Package

1. Modify the marea_parking-cost_by_area-type.csv input file and specifications (Inp and Get) to add 3 fields: CenterPropNonWrkTripPay, InnerPropNonWrkTripPay, OuterPropNonWrkTripPay. This input is used to determine the proportion of shopping and other non-work trips to each of the area types that pay for parking. In most scenarios the value would probably be either 1 or 0, but the user could enter any value inbetween. Note that this would not affect residential parking costs.

2. Change the AssignParkingRestrictions module code to multiply the area type parking cost values by the PropNonWrkTripPay values. The simplest change would be to calculate a NonWorkPkgCostProp_Bz vector around line 497 and use that in modifying the parking cost for non-work trips in line 562.
