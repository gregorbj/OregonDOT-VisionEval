
# CalculateAltModeTrips Module
### November 23, 2018

This module calculates household transit trips, walk trips, and bike trips. The models are sensitive to household DVMT so they are run after all household DVMT adjustments (e.g. to account for cost on household DVMT) are made.

## Model Parameter Estimation

Hurdle models are estimated for calculating the numbers of household transit, walk, and bike trips using the [pscl](https://cran.r-project.org/web/packages/pscl/vignettes/countreg.pdf) package. Separate models are calculated for metropolitan and non-metropolitan households to account for the additional variables available in metropolitan areas.

Following are the estimation statistics for the metropolitan and nonmetropolitan **walk** trip models.

**Metropolitan Walk Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-4.7355 -1.3362 -0.5992  0.5862 32.2193 

Count model coefficients (truncated poisson with log link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)   4.586e+00  6.697e-03  684.78   <2e-16 ***
HhSize        3.171e-01  8.369e-04  378.93   <2e-16 ***
LogIncome     1.418e-01  6.559e-04  216.17   <2e-16 ***
LogDensity   -3.892e-03  3.343e-04  -11.64   <2e-16 ***
BusEqRevMiPC  1.634e-03  1.301e-05  125.58   <2e-16 ***
Urban         4.588e-02  6.120e-04   74.96   <2e-16 ***
LogDvmt      -2.187e-01  7.171e-04 -304.97   <2e-16 ***
Age0to14     -3.257e-01  9.079e-04 -358.74   <2e-16 ***
Age15to19    -8.747e-02  1.099e-03  -79.61   <2e-16 ***
Age20to29     4.693e-02  9.317e-04   50.38   <2e-16 ***
Age30to54     2.097e-02  7.154e-04   29.31   <2e-16 ***
Age65Plus    -3.514e-02  8.485e-04  -41.42   <2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -2.2802072  0.2614283  -8.722  < 2e-16 ***
HhSize        0.4592411  0.0385321  11.918  < 2e-16 ***
LogIncome     0.2793604  0.0260032  10.743  < 2e-16 ***
LogDensity    0.0234602  0.0137757   1.703 0.088566 .  
BusEqRevMiPC -0.0038066  0.0005492  -6.931 4.17e-12 ***
Urban         0.0644912  0.0260828   2.473 0.013415 *  
LogDvmt      -0.2550415  0.0313328  -8.140 3.96e-16 ***
Age0to14     -0.3715549  0.0422625  -8.792  < 2e-16 ***
Age15to19    -0.1961498  0.0555821  -3.529 0.000417 ***
Age20to29     0.0930190  0.0428984   2.168 0.030132 *  
Age30to54     0.0649403  0.0309901   2.096 0.036125 *  
Age65Plus    -0.0373975  0.0344160  -1.087 0.277199    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 18 
Log-likelihood: -2.475e+06 on 24 Df
```

**Nonmetropolitan Walk Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-2.9719 -1.2631 -0.5841  0.5359 34.5831 

Count model coefficients (truncated poisson with log link):
              Estimate Std. Error z value Pr(>|z|)    
(Intercept)  6.1534205  0.0044801 1373.49   <2e-16 ***
HhSize       0.3303847  0.0006746  489.78   <2e-16 ***
LogIncome   -0.0237204  0.0005585  -42.47   <2e-16 ***
LogDensity  -0.0377357  0.0001842 -204.85   <2e-16 ***
LogDvmt     -0.0416457  0.0010319  -40.36   <2e-16 ***
Age0to14    -0.3606010  0.0007032 -512.78   <2e-16 ***
Age15to19   -0.1465534  0.0008401 -174.45   <2e-16 ***
Age20to29    0.0241755  0.0006777   35.67   <2e-16 ***
Age30to54   -0.0190084  0.0005360  -35.46   <2e-16 ***
Age65Plus   -0.0301859  0.0006138  -49.18   <2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
             Estimate Std. Error z value Pr(>|z|)    
(Intercept) -0.498756   0.159757  -3.122  0.00180 ** 
HhSize       0.145143   0.029140   4.981 6.33e-07 ***
LogIncome    0.058027   0.019806   2.930  0.00339 ** 
LogDensity  -0.034506   0.006877  -5.018 5.23e-07 ***
LogDvmt      0.117765   0.036059   3.266  0.00109 ** 
Age0to14    -0.190586   0.030038  -6.345 2.23e-10 ***
Age15to19    0.021176   0.038477   0.550  0.58209    
Age20to29    0.092786   0.028744   3.228  0.00125 ** 
Age30to54    0.064043   0.021311   3.005  0.00265 ** 
Age65Plus   -0.049887   0.023212  -2.149  0.03162 *  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 16 
Log-likelihood: -4.195e+06 on 20 Df
```

Following are the estimation statistics for the metropolitan and nonmetropolitan **bike** trip models.

**Metropolitan Bike Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-1.2353 -0.3524 -0.2790 -0.2282 34.1377 

Count model coefficients (truncated poisson with log link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)   6.329e+00  2.474e-02  255.83   <2e-16 ***
HhSize        1.106e-01  4.271e-03   25.88   <2e-16 ***
LogIncome    -6.738e-02  2.904e-03  -23.20   <2e-16 ***
BusEqRevMiPC -2.237e-03  6.017e-05  -37.18   <2e-16 ***
LogDvmt      -1.699e-01  3.329e-03  -51.05   <2e-16 ***
Age0to14     -1.938e-01  4.480e-03  -43.26   <2e-16 ***
Age15to19    -1.357e-01  5.291e-03  -25.64   <2e-16 ***
Age20to29     7.891e-02  4.425e-03   17.83   <2e-16 ***
Age30to54     7.891e-02  3.618e-03   21.81   <2e-16 ***
Age65Plus     4.907e-02  4.317e-03   11.37   <2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -4.7713410  0.3802362 -12.548  < 2e-16 ***
HhSize        0.1658571  0.0580440   2.857 0.004271 ** 
LogIncome     0.2005628  0.0431691   4.646 3.38e-06 ***
BusEqRevMiPC -0.0061584  0.0008646  -7.123 1.06e-12 ***
LogDvmt      -0.0398969  0.0495670  -0.805 0.420872    
Age0to14      0.0452274  0.0599547   0.754 0.450633    
Age15to19     0.2071852  0.0717221   2.889 0.003868 ** 
Age20to29     0.2301470  0.0614262   3.747 0.000179 ***
Age30to54     0.1713032  0.0483195   3.545 0.000392 ***
Age65Plus    -0.0756452  0.0613740  -1.233 0.217751    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 39 
Log-likelihood: -1.193e+05 on 20 Df
```

**Nonmetropolitan Bike Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-2.4410 -0.3567 -0.2792 -0.2273 57.2756 

Count model coefficients (truncated poisson with log link):
             Estimate Std. Error z value Pr(>|z|)    
(Intercept)  5.891697   0.017448  337.68   <2e-16 ***
HhSize       0.242342   0.002575   94.10   <2e-16 ***
LogIncome    0.033278   0.002125   15.66   <2e-16 ***
LogDvmt     -0.386550   0.003247 -119.03   <2e-16 ***
Age0to14    -0.289301   0.002742 -105.51   <2e-16 ***
Age15to19   -0.092239   0.003160  -29.19   <2e-16 ***
Age20to29    0.095841   0.002578   37.17   <2e-16 ***
Age30to54    0.024627   0.002280   10.80   <2e-16 ***
Age65Plus   -0.033796   0.002863  -11.80   <2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -4.62290    0.27757 -16.655  < 2e-16 ***
HhSize       0.21587    0.04551   4.743 2.10e-06 ***
LogIncome    0.19367    0.03286   5.894 3.77e-09 ***
LogDvmt     -0.12174    0.05755  -2.115  0.03441 *  
Age0to14    -0.05070    0.04527  -1.120  0.26273    
Age15to19    0.18238    0.05279   3.455  0.00055 ***
Age20to29    0.25784    0.04318   5.971 2.35e-09 ***
Age30to54    0.17486    0.03476   5.031 4.88e-07 ***
Age65Plus   -0.18272    0.04441  -4.115 3.88e-05 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 18 
Log-likelihood: -2.874e+05 on 18 Df
```

Following are the estimation statistics for the metropolitan and nonmetropolitan **transit** trip models.

**Metropolitan Transit Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-3.8981 -0.3420 -0.2262 -0.1478 34.7265 

Count model coefficients (truncated poisson with log link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)   6.028e+00  1.044e-02 577.673  < 2e-16 ***
HhSize        1.345e-02  6.683e-04  20.127  < 2e-16 ***
LogIncome     5.800e-02  1.001e-03  57.968  < 2e-16 ***
LogDensity    4.497e-02  5.878e-04  76.498  < 2e-16 ***
BusEqRevMiPC  1.888e-03  2.542e-05  74.299  < 2e-16 ***
LogDvmt      -9.587e-02  1.005e-03 -95.411  < 2e-16 ***
Urban         3.457e-02  1.076e-03  32.138  < 2e-16 ***
Age15to19    -1.206e-03  1.207e-03  -0.999    0.318    
Age20to29     6.580e-02  1.333e-03  49.373  < 2e-16 ***
Age30to54     4.879e-02  1.262e-03  38.669  < 2e-16 ***
Age65Plus     8.642e-03  1.662e-03   5.198 2.01e-07 ***
Zero hurdle model coefficients (binomial with logit link):
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -4.1817696  0.4118211 -10.154  < 2e-16 ***
HhSize        0.5178548  0.0245799  21.068  < 2e-16 ***
LogIncome     0.3444661  0.0403611   8.535  < 2e-16 ***
LogDensity   -0.0392715  0.0214122  -1.834 0.066644 .  
BusEqRevMiPC  0.0097764  0.0008813  11.093  < 2e-16 ***
LogDvmt      -1.0653408  0.0416395 -25.585  < 2e-16 ***
Urban         0.0717526  0.0400023   1.794 0.072859 .  
Age15to19     0.3072276  0.0470228   6.534 6.42e-11 ***
Age20to29     0.1943271  0.0521214   3.728 0.000193 ***
Age30to54     0.3877589  0.0466764   8.307  < 2e-16 ***
Age65Plus    -0.5826082  0.0644606  -9.038  < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 21 
Log-likelihood: -3.381e+05 on 22 Df
```

**Nonmetropolitan Transit Trip Model**
```

Call:
hurdle(formula = ModelFormula, data = Data_df, dist = "poisson", zero.dist = "binomial", 
    link = "logit")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-6.3349 -0.2401 -0.1567 -0.1048 45.2198 

Count model coefficients (truncated poisson with log link):
              Estimate Std. Error z value Pr(>|z|)    
(Intercept)  6.7696099  0.0105611 640.992  < 2e-16 ***
HhSize       0.0531910  0.0018393  28.919  < 2e-16 ***
LogIncome    0.0587909  0.0012719  46.222  < 2e-16 ***
LogDensity  -0.0124243  0.0004656 -26.684  < 2e-16 ***
LogDvmt     -0.1351324  0.0019855 -68.059  < 2e-16 ***
Age0to14    -0.0083601  0.0018217  -4.589 4.45e-06 ***
Age15to19    0.0236264  0.0020681  11.424  < 2e-16 ***
Age20to29   -0.0322994  0.0021757 -14.845  < 2e-16 ***
Age30to54   -0.0274491  0.0017202 -15.957  < 2e-16 ***
Age65Plus   -0.0709804  0.0027659 -25.663  < 2e-16 ***
Zero hurdle model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -1.44132    0.35058  -4.111 3.94e-05 ***
HhSize       0.48963    0.06451   7.590 3.19e-14 ***
LogIncome    0.23174    0.04343   5.336 9.51e-08 ***
LogDensity  -0.17538    0.01442 -12.164  < 2e-16 ***
LogDvmt     -1.27299    0.06925 -18.383  < 2e-16 ***
Age0to14     0.25542    0.06337   4.031 5.56e-05 ***
Age15to19    0.38557    0.07127   5.410 6.29e-08 ***
Age20to29    0.07005    0.07214   0.971    0.332    
Age30to54    0.53268    0.05692   9.358  < 2e-16 ***
Age65Plus   -0.60596    0.08592  -7.052 1.76e-12 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 21 
Log-likelihood: -2.818e+05 on 20 Df
```

## How the Module Works

This module is run after all household DVMT adjustments are made due to cost, travel demand management, and light-weight vehicle (e.g. bike, scooter) diversion, so that alternative mode travel reflects the result of those influences. The alternative mode trip models are run and the results are saved.


## User Inputs
This module has no user input requirements.

## Datasets Used by the Module
The following table documents each dataset that is retrieved from the datastore and used by the module. Each row in the table describes a dataset. All the datasets must be present in the datastore. One or more of these datasets may be entered into the datastore from the user input files. The table names and their meanings are as follows:

NAME - The dataset name.

TABLE - The table in the datastore that the data is retrieved from.

GROUP - The group in the datastore where the table is located. Note that the datastore has a group named 'Global' and groups for every model run year. For example, if the model run years are 2010 and 2050, then the datastore will have a group named '2010' and a group named '2050'. If the value for 'GROUP' is 'Year', then the dataset will exist in each model run year group. If the value for 'GROUP' is 'BaseYear' then the dataset will only exist in the base year group (e.g. '2010'). If the value for 'GROUP' is 'Global' then the dataset will only exist in the 'Global' group.

TYPE - The data type. The framework uses the type to check units and inputs. Refer to the model system design and users guide for information on allowed types.

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values in the datastore do not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Values in the datastore are one or more of the listed values.

|NAME            |TABLE     |GROUP |TYPE      |UNITS      |PROHIBIT |ISELEMENTOF        |
|:---------------|:---------|:-----|:---------|:----------|:--------|:------------------|
|Marea           |Marea     |Year  |character |ID         |         |                   |
|TranRevMiPC     |Marea     |Year  |compound  |MI/PRSN/YR |NA, < 0  |                   |
|Marea           |Bzone     |Year  |character |ID         |         |                   |
|Bzone           |Bzone     |Year  |character |ID         |         |                   |
|D1B             |Bzone     |Year  |compound  |PRSN/SQMI  |NA, < 0  |                   |
|Marea           |Household |Year  |character |ID         |         |                   |
|Bzone           |Household |Year  |character |ID         |         |                   |
|Age0to14        |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age15to19       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age20to29       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age30to54       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age55to64       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|Age65Plus       |Household |Year  |people    |PRSN       |NA, < 0  |                   |
|LocType         |Household |Year  |character |category   |NA       |Urban, Town, Rural |
|HhSize          |Household |Year  |people    |PRSN       |NA, <= 0 |                   |
|Income          |Household |Year  |currency  |USD.2001   |NA, < 0  |                   |
|Vehicles        |Household |Year  |vehicles  |VEH        |NA, < 0  |                   |
|IsUrbanMixNbrhd |Household |Year  |integer   |binary     |NA       |0, 1               |
|Dvmt            |Household |Year  |compound  |MI/DAY     |NA, < 0  |                   |

## Datasets Produced by the Module
The following table documents each dataset that is retrieved from the datastore and used by the module. Each row in the table describes a dataset. All the datasets must be present in the datastore. One or more of these datasets may be entered into the datastore from the user input files. The table names and their meanings are as follows:

NAME - The dataset name.

TABLE - The table in the datastore that the data is retrieved from.

GROUP - The group in the datastore where the table is located. Note that the datastore has a group named 'Global' and groups for every model run year. For example, if the model run years are 2010 and 2050, then the datastore will have a group named '2010' and a group named '2050'. If the value for 'GROUP' is 'Year', then the dataset will exist in each model run year. If the value for 'GROUP' is 'BaseYear' then the dataset will only exist in the base year group (e.g. '2010'). If the value for 'GROUP' is 'Global' then the dataset will only exist in the 'Global' group.

TYPE - The data type. The framework uses the type to check units and inputs. Refer to the model system design and users guide for information on allowed types.

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values in the datastore do not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Values in the datastore are one or more of the listed values.

DESCRIPTION - A description of the data.

|NAME         |TABLE     |GROUP |TYPE     |UNITS   |PROHIBIT |ISELEMENTOF |DESCRIPTION                                                          |
|:------------|:---------|:-----|:--------|:-------|:--------|:-----------|:--------------------------------------------------------------------|
|WalkTrips    |Household |Year  |compound |TRIP/YR |NA, < 0  |            |Average number of walk trips per year by household members           |
|BikeTrips    |Household |Year  |compound |TRIP/YR |NA, < 0  |            |Average number of bicycle trips per year by household members        |
|TransitTrips |Household |Year  |compound |TRIP/YR |NA, < 0  |            |Average number of public transit trips per year by household members |
