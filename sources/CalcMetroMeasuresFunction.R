#==============================================================
#Define function to calculate metropolitan performance measures
#==============================================================
calcMetropolitanMeasures <- 
  function(Year, Ma, ModelType, DstoreLocs_ = c("Datastore"), DstoreType = "RD") {
    
    QPrep_ls <- prepareForDatastoreQuery(
      DstoreLocs_ = DstoreLocs_,
      DstoreType = DstoreType
    )
    
    #Calculate urban household characteristics
    #-----------------------------------------
    #Number of households
    HhNum_Ma <- summarizeDatasets(
      Expr = "count(HhSize[LocType == 'Urban'])",
      Units_ = c(
        HhSize = "",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Population
    HhPop_Ma <- summarizeDatasets(
      Expr = "sum(HhSize[LocType == 'Urban'])",
      Units_ = c(
        HhSize = "",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Average household size
    HhAveSize_Ma <- HhPop_Ma / HhNum_Ma
    #Number of workers
    HhWorkers_Ma <- summarizeDatasets(
      Expr = "sum(Workers[LocType == 'Urban'])",
      Units_ = c(
        Workers = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Average workers per household
    HhAveNumWkr_Ma <- HhWorkers_Ma / HhNum_Ma
    #Total household income
    HhIncome_Ma <- summarizeDatasets(
      Expr = "sum(Income[LocType == 'Urban'])",
      Units_ = c(
        Income = "USD",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Average income per household
    HhAveIncPerHh_Ma <- HhIncome_Ma / HhNum_Ma
    #Average income per person
    HhAveIncPerPrsn_Ma <- HhIncome_Ma / HhPop_Ma
    #Average income per worker
    HhAveIncPerWkr_Ma <- HhIncome_Ma / HhWorkers_Ma
    #Number of drivers
    HhDrivers_Ma <- summarizeDatasets(
      Expr = "sum(Drivers[LocType == 'Urban'])",
      Units_ = c(
        Drivers = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Average number of drivers per household
    HhAveDvrPerHh_Ma <- HhDrivers_Ma / HhNum_Ma
    #Average number of drivers per person
    HhAveDvrPerPrsn_Ma <- HhDrivers_Ma / HhPop_Ma
    #Average number of drivers per worker
    HhAveDvrPerWkr_Ma <- HhDrivers_Ma / HhWorkers_Ma
    #Number of vehicles
    HhVehicles_Ma <- summarizeDatasets(
      Expr = "sum(Vehicles[LocType == 'Urban'])",
      Units_ = c(
        Vehicles = "VEH",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Average number of vehicles per household
    HhAveVehPerHh_Ma <- HhVehicles_Ma / HhNum_Ma
    #Average number of vehicles per person
    HhAveVehPerPrsn_Ma <- HhVehicles_Ma / HhPop_Ma
    #Average number of vehicles per worker
    HhAveVehPerWkr_Ma <- HhVehicles_Ma / HhWorkers_Ma
    #Average number of vehicles per driver
    HhAveVehPerDvr_Ma <- HhVehicles_Ma / HhDrivers_Ma
    #Number of light trucks
    HhLightTrucks_Ma <- summarizeDatasets(
      Expr = "sum(NumLtTrk[LocType == 'Urban'])",
      Units_ = c(
        NumLtTrk = "VEH",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Light-truck vehicle proportion
    HhLtTrkProp_Ma <- HhLightTrucks_Ma / HhVehicles_Ma
    #Matrix of household characteristics
    HhCharacteristics_XMa <- rbind(
      Number = HhNum_Ma,
      Population = HhPop_Ma,
      AveSize = HhAveSize_Ma,
      Workers = HhWorkers_Ma,
      AveNumWkr = HhAveNumWkr_Ma,
      Income = HhIncome_Ma,
      AveInc = HhAveIncPerHh_Ma,
      AveIncPerPrsn = HhAveIncPerPrsn_Ma,
      AveIncPerWkr = HhAveIncPerWkr_Ma,
      Vehicles = HhVehicles_Ma,
      AveVehPerHh = HhAveVehPerHh_Ma,
      AveVehPerPrsn = HhAveVehPerPrsn_Ma,
      AveVehPerWkr = HhAveVehPerWkr_Ma,
      AveVehPerDvr = HhAveVehPerDvr_Ma,
      LtTrkProp = HhLtTrkProp_Ma
    )
    
    #Land use characteristics
    #------------------------
    #Average area-weighted population density
    if (ModelType == "VE-State") {
      AveAreaWtPopDen_Ma <- summarizeDatasets(
        Expr = "sum(Pop) / sum((NumHh + TotEmp) / D1D)",
        Units_ = c(
          D1D = "HHJOB/SQMI",
          Pop = "PRSN",
          NumHh = "HH",
          TotEmp = "PRSN"
        ),
        By_ = c("Marea", "LocType"),
        Table = "Bzone",
        Group = Year,
        QueryPrep_ls = QPrep_ls
      )[Ma, "Urban"]
    }
    if (ModelType == "VE-RSPM") {
      AveAreaWtPopDen_Ma <- summarizeDatasets(
        Expr = "sum(UrbanPop) / sum(UrbanArea)",
        Units_ = c(
          UrbanArea = "SQMI",
          UrbanPop = "PRSN"
        ),
        By_ = "Marea",
        Table = "Bzone",
        Group = Year,
        QueryPrep_ls = QPrep_ls
      )[Ma]	
    }
    #Average population-weighted population density
    if (ModelType == "VE-State") {
      AvePopWtPopDen_Ma <- summarizeDatasets(
        Expr = "sum(D1B * Pop) / sum(Pop)",
        Units_ = c(
          D1B = "PRSN/SQMI",
          Pop = "PRSN"
        ),
        By_ = c("Marea", "LocType"),
        Table = "Bzone",
        Group = Year,
        QueryPrep_ls = QPrep_ls
      )[Ma, "Urban"]
    }
    if (ModelType == "VE-RSPM") {
      AvePopWtPopDen_Ma <- summarizeDatasets(
        Expr = "sum(D1B * Pop) / sum(Pop)",
        Units_ = c(
          D1B = "PRSN/SQMI",
          Pop = "PRSN"
        ),
        By_ = "Marea",
        Table = "Bzone",
        Group = Year,
        QueryPrep_ls = QPrep_ls
      )[Ma]
    }
    #Number of households in urban-mixed neighborhoods
    if (ModelType == "VE-State") {
      NumUrbanMixHh_Ma <- summarizeDatasets(
        Expr = "sum(IsUrbanMixNbrhd[LocType == 'Urban'])",
        Units_ = c(
          IsUrbanMixNbrhd = "",
          LocType = ""
        ),
        By_ = "Marea",
        Table = "Household",
        Group = Year,
        QueryPrep_ls = QPrep_ls
      )[Ma]
    }
    if (ModelType == "VE-RSPM") {
      NumUrbanMixHh_Ma <- summarizeDatasets(
        Expr = "sum(IsUrbanMixNbrhd)",
        Units_ = c(
          IsUrbanMixNbrhd = ""
          
        ),
        By_ = "Marea",
        Table = "Household",
        Group = Year,
        QueryPrep_ls = QPrep_ls
      )[Ma]
    }
    #Proportion of households in urban-mixed neighborhoods
    PropUrbanMixHh_Ma <- NumUrbanMixHh_Ma / HhNum_Ma
    #Proportion of single-family dwelling units
    if (ModelType == "VE-State") {
      PropSFDU_Ma <- summarizeDatasets(
        Expr = "sum(SFDU) / (sum(SFDU) + sum(MFDU))",
        Units = c(
          SFDU = "DU",
          MFDU = "DU"
        ),
        By_ = c("Marea", "LocType"),
        Table = "Bzone",
        Group = Year,
        QueryPrep_ls = QPrep_ls
      )[Ma, "Urban"]
    }
    if (ModelType == "VE-RSPM") {
      PropSFDU_Ma <- summarizeDatasets(
        Expr = "sum(SFDU) / (sum(NumHh))",
        Units = c(
          SFDU = "DU",
          NumHh = "HH"
        ),
        By_ = "Marea",
        Table = "Bzone",
        Group = Year,
        QueryPrep_ls = QPrep_ls
      )[Ma]
    }
    #Matrix of land use characteristics
    LuCharacteristics_XMa <- rbind(
      AveAreaWtPopDen = AveAreaWtPopDen_Ma,
      AvePopWtPopDen = AvePopWtPopDen_Ma,
      PropUrbanMixHh = PropUrbanMixHh_Ma,
      PropSFDU = PropSFDU_Ma
    )
    
    #DVMT
    #----
    #Commercial service DVMT
    ComSvcDvmt_Ma <- summarizeDatasets(
      Expr = "sum(ComSvcUrbanDvmt)",
      Units = c(
        ComSvcUrbanDvmt = "MI/DAY"
      ),
      By_ = "Marea",
      Table = "Marea",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Van DVMT
    VanDvmt_Ma <- summarizeDatasets(
      Expr = "sum(VanDvmt)",
      Units = c(
        VanDvmt = "MI/DAY"
      ),
      By_ = "Marea",
      Table = "Marea",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Household DVMT
    HhDvmt_Ma <- summarizeDatasets(
      Expr = "sum(UrbanHhDvmt)",
      Units_ = c(
        UrbanHhDvmt = "MI/DAY"
      ),
      By_ = "Marea",
      Table = "Marea",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Light-duty vehicle DVMT
    LdvDvmt_Ma <- HhDvmt_Ma + VanDvmt_Ma + ComSvcDvmt_Ma
    #Urban roadway LDV DVMT
    LdvRoadDvmt_Ma <- summarizeDatasets(
      Expr = "sum(LdvFwyDvmt + LdvArtDvmt + LdvOthDvmt)",
      Units = c(
        LdvFwyDvmt = "MI/DAY",
        LdvArtDvmt = "MI/DAY",
        LdvOthDvmt = "MI/DAY"
      ),
      By = "Marea",
      Table = "Marea",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Household DVMT per household
    AveHhDvmtPerHh_Ma <- HhDvmt_Ma / HhNum_Ma
    #Household DVMT per person
    AveHhDvmtPerPrsn_Ma <- HhDvmt_Ma / HhPop_Ma
    #Household DVMT per driver
    AveHhDvmtPerDvr_Ma <- HhDvmt_Ma / HhDrivers_Ma
    #Household DVMT per vehicle
    AveHhDvmtPerVeh_Ma <- HhDvmt_Ma / HhVehicles_Ma
    #Light-duty vehicle DVMT per household
    AveLdvDvmtPerHh_Ma <- LdvDvmt_Ma / HhNum_Ma
    #Light-duty vehicle DVMT per person
    AveLdvDvmtPerPrsn_Ma <- LdvDvmt_Ma / HhPop_Ma
    #Light-duty vehicle DVMT per driver
    AveLdvDvmtPerDvr_Ma <- LdvDvmt_Ma / HhDrivers_Ma
    #Light-duty vehicle DVMT per vehicle
    AveLdvDvmtPerVeh_Ma <- LdvDvmt_Ma / HhVehicles_Ma
    #Ratio of household DVMT to light-duty DVMT
    PropHhDvmt_Ma <- HhDvmt_Ma / LdvDvmt_Ma
    #Ratio of commercial service DVMT to light-duty DVMT
    PropComSvcDvmt_Ma <- ComSvcDvmt_Ma / LdvDvmt_Ma
    #Ratio of public transit van DVMT to light-duty DVMT
    PropVanDvmt_Ma <- VanDvmt_Ma / LdvDvmt_Ma
    #Matrix of DVMT values
    Dvmt_XMa <- rbind(
      HhDvmt = HhDvmt_Ma,
      ComSvcDvmt = ComSvcDvmt_Ma,
      VanDvmt = VanDvmt_Ma,
      LdvDvmt = LdvDvmt_Ma,
      LdvRoadDvmt = LdvRoadDvmt_Ma,
      AveHhDvmtPerHh = AveHhDvmtPerHh_Ma,
      AveHhDvmtPerPrsn = AveHhDvmtPerPrsn_Ma,
      AveHhDvmtPerDvr = AveHhDvmtPerDvr_Ma,
      AveHhDvmtPerVeh = AveHhDvmtPerVeh_Ma,
      AveLdvDvmtPerHh = AveLdvDvmtPerHh_Ma,
      AveLdvDvmtPerPrsn = AveLdvDvmtPerPrsn_Ma,
      AveLdvDvmtPerDvr = AveLdvDvmtPerDvr_Ma,
      AveLdvDvmtPerVeh = AveLdvDvmtPerVeh_Ma,
      PropHhDvmt = PropHhDvmt_Ma,
      PropComSvcDvmt = PropComSvcDvmt_Ma,
      PropVanDvmt = PropVanDvmt_Ma
    )
    
    #CO2e
    #----
    #Household CO2e
    HhCO2e_Ma <- summarizeDatasets(
      Expr = "sum(DailyCO2e[LocType == 'Urban'])",
      Units = c(
        DailyCO2e = "KG",
        LocType = ""
      ),
      By = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Commercial service CO2e
    ComSvcCO2e_Ma <- summarizeDatasets(
      Expr = "sum(ComSvcUrbanCO2e)",
      Units = c(
        ComSvcUrbanCO2e = "KG"
      ),
      By_ = "Marea",
      Table = "Marea",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Van CO2e
    VanCO2e_Ma <- summarizeDatasets(
      Expr = "sum(VanCO2e)",
      Units = c(
        VanCO2e = "KG"
      ),
      By_ = "Marea",
      Table = "Marea",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Light-duty vehicle CO2e
    LdvCO2e_Ma <- HhCO2e_Ma + VanCO2e_Ma + ComSvcCO2e_Ma
    #Household vehicle CO2e per household
    HhCO2ePerHh_Ma <- HhCO2e_Ma / HhNum_Ma
    #Household vehicle CO2e per capita
    HhCO2ePerPrsn_Ma <- HhCO2e_Ma / HhPop_Ma
    #Light-duty vehicle CO2e per household
    LdvCO2ePerHh_Ma <- LdvCO2e_Ma / HhNum_Ma
    #Light-duty vehicle CO2e per capita
    LdvCO2ePerPrsn_Ma <- LdvCO2e_Ma / HhPop_Ma
    #Household CO2e rate
    HhCO2eRate_Ma <- 1000 * HhCO2e_Ma / HhDvmt_Ma
    #Commercial service CO2e rate
    ComSvcCO2eRate_Ma <- 1000 * ComSvcCO2e_Ma / ComSvcDvmt_Ma
    #Van CO2e rate
    VanCO2eRate_Ma <- 1000 * VanCO2e_Ma / VanDvmt_Ma
    #Light-duty vehicle CO2e rate
    LdvCO2eRate_Ma <- 1000 * LdvCO2e_Ma / LdvDvmt_Ma
    #Matrix of CO2e values
    CO2e_XMa <- rbind(
      HhCO2e = HhCO2e_Ma,
      ComSvcCO2e = ComSvcCO2e_Ma,
      VanCO2e = VanCO2e_Ma,
      LdvCO2e = LdvCO2e_Ma,
      HhCO2ePerHh = HhCO2ePerHh_Ma,
      HhCO2ePerPrsn = HhCO2ePerPrsn_Ma,
      LdvCO2ePerHh = LdvCO2ePerHh_Ma,
      LdvCO2ePerPrsn = LdvCO2ePerPrsn_Ma,
      HhCO2eRate = HhCO2eRate_Ma,
      ComSvcCO2eRate = ComSvcCO2eRate_Ma,
      VanCO2eRate = VanCO2eRate_Ma,
      LdvCO2eRate = LdvCO2eRate_Ma
    )
    
    #Household population by age group
    #---------------------------------
    #Age0to14
    HhPop0to14_Ma <- summarizeDatasets(
      Expr = "sum(Age0to14[LocType == 'Urban'])",
      Units_ = c(
        Age0to14 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age15to19
    HhPop15to19_Ma <- summarizeDatasets(
      Expr = "sum(Age15to19[LocType == 'Urban'])",
      Units_ = c(
        Age15to19 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age20to29
    HhPop20to29_Ma <- summarizeDatasets(
      Expr = "sum(Age20to29[LocType == 'Urban'])",
      Units_ = c(
        Age20to29 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age30to54
    HhPop30to54_Ma <- summarizeDatasets(
      Expr = "sum(Age30to54[LocType == 'Urban'])",
      Units_ = c(
        Age30to54 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age55to64
    HhPop55to64_Ma <- summarizeDatasets(
      Expr = "sum(Age55to64[LocType == 'Urban'])",
      Units_ = c(
        Age55to64 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age65Plus
    HhPop65Plus_Ma <- summarizeDatasets(
      Expr = "sum(Age65Plus[LocType == 'Urban'])",
      Units_ = c(
        Age65Plus = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Matrix of population by age and Marea
    HhPop_AgMa <- rbind(
      Pop0to14 = HhPop0to14_Ma,
      Pop15to19 = HhPop15to19_Ma,
      Pop20to29 = HhPop20to29_Ma,
      Pop30to54 = HhPop30to54_Ma,
      Pop55to64 = HhPop55to64_Ma,
      Pop65Plus = HhPop65Plus_Ma
    )
    
    #Household workers by age group
    #------------------------------
    #Age15to19
    HhWkr15to19_Ma <- summarizeDatasets(
      Expr = "sum(Wkr15to19[LocType == 'Urban'])",
      Units_ = c(
        Wkr15to19 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age20to29
    HhWkr20to29_Ma <- summarizeDatasets(
      Expr = "sum(Wkr20to29[LocType == 'Urban'])",
      Units_ = c(
        Wkr20to29 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age30to54
    HhWkr30to54_Ma <- summarizeDatasets(
      Expr = "sum(Wkr30to54[LocType == 'Urban'])",
      Units_ = c(
        Wkr30to54 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age55to64
    HhWkr55to64_Ma <- summarizeDatasets(
      Expr = "sum(Wkr55to64[LocType == 'Urban'])",
      Units_ = c(
        Wkr55to64 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age65Plus
    HhWkr65Plus_Ma <- summarizeDatasets(
      Expr = "sum(Wkr65Plus[LocType == 'Urban'])",
      Units_ = c(
        Wkr65Plus = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Matrix of drivers by age and Marea
    HhWkr_AgMa <- rbind(
      Wkr15to19 = HhWkr15to19_Ma,
      Wkr20to29 = HhWkr20to29_Ma,
      Wkr30to54 = HhWkr30to54_Ma,
      Wkr55to64 = HhWkr55to64_Ma,
      Wkr65Plus = HhWkr65Plus_Ma,
      WkrPerPop15to19 = HhWkr15to19_Ma / HhPop15to19_Ma,
      WkrPerPop20to29 = HhWkr20to29_Ma / HhPop20to29_Ma,
      WkrPerPop30to54 = HhWkr30to54_Ma / HhPop30to54_Ma,
      WkrPerPop55to64 = HhWkr55to64_Ma / HhPop55to64_Ma,
      WkrPerPop65Plus = HhWkr65Plus_Ma / HhPop65Plus_Ma
    )
    
    #Household drivers by age group
    #------------------------------
    #Age15to19
    HhDvr15to19_Ma <- summarizeDatasets(
      Expr = "sum(Drv15to19[LocType == 'Urban'])",
      Units_ = c(
        Drv15to19 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age20to29
    HhDvr20to29_Ma <- summarizeDatasets(
      Expr = "sum(Drv20to29[LocType == 'Urban'])",
      Units_ = c(
        Drv20to29 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age30to54
    HhDvr30to54_Ma <- summarizeDatasets(
      Expr = "sum(Drv30to54[LocType == 'Urban'])",
      Units_ = c(
        Drv30to54 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age55to64
    HhDvr55to64_Ma <- summarizeDatasets(
      Expr = "sum(Drv55to64[LocType == 'Urban'])",
      Units_ = c(
        Drv55to64 = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Age65Plus
    HhDvr65Plus_Ma <- summarizeDatasets(
      Expr = "sum(Drv65Plus[LocType == 'Urban'])",
      Units_ = c(
        Drv65Plus = "PRSN",
        LocType = ""
      ),
      By_ = "Marea",
      Table = "Household",
      Group = Year,
      QueryPrep_ls = QPrep_ls
    )[Ma]
    #Matrix of drivers by age and Marea
    HhDvr_AgMa <- rbind(
      Dvr15to19 = HhDvr15to19_Ma,
      Dvr20to29 = HhDvr20to29_Ma,
      Dvr30to54 = HhDvr30to54_Ma,
      Dvr55to64 = HhDvr55to64_Ma,
      Dvr65Plus = HhDvr65Plus_Ma,
      DvrPerPop15to19 = HhDvr15to19_Ma / HhPop15to19_Ma,
      DvrPerPop20to29 = HhDvr20to29_Ma / HhPop20to29_Ma,
      DvrPerPop30to54 = HhDvr30to54_Ma / HhPop30to54_Ma,
      DvrPerPop55to64 = HhDvr55to64_Ma / HhPop55to64_Ma,
      DvrPerPop65Plus = HhDvr65Plus_Ma / HhPop65Plus_Ma
    )
    
    #Return data frame of all results
    #--------------------------
    data.frame(rbind(
      HhCharacteristics_XMa,
      LuCharacteristics_XMa,
      Dvmt_XMa,
      CO2e_XMa,
      HhPop_AgMa,
      HhWkr_AgMa,
      HhDvr_AgMa
    ))
  }
