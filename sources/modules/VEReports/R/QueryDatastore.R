#================
#QueryDatastore.R
#================
#This script defines functions for executing queries of a VisionEval datastore.
#

#Code for development/testing
# library(visioneval)
# library(filesstrings)
# library(xlsx)


#=============================
#PREPARE FOR A DATASTORE QUERY
#=============================
#' Retrieve information needed to prepare a datastore query.
#'
#' \code{prepareForDatastoreQuery} retrieves datastore listings and functions
#' required to make a datastore query.
#'
#' This function prepares a list of information that is used in making a query
#' of a VisionEval model datastore. The list includes the location(s) of the
#' datastore(s) to be queried, the listing(s) for those datastores, and the
#' functions to be used for reading the datastore(s). More than one datastore
#' may be specified so that if datastore references are used in a model run,
#' datasets from the referenced datastores may be queried as well. Note that the
#' capability for querying multiple datastores is only for the purpose of
#' querying datastores for a single model scenario. This capability should not
#' be used to compare multiple scenarios. The function does not segregate
#' datasets by datastore. Attempting to use this function to compare multiple
#' scenarios could produce unpredictable results.
#'
#' @param DstoreLocs_ a string vector identifying the paths to all of the
#' datastores to extract the datasets from. Each entry must be the full relative
#' path to a datastore (e.g. 'tests/Datastore').
#' @param DstoreType a string identifying the type of datastore
#' (e.g. 'RD', 'H5'). Note
#' @return A named list having three components. The 'Dir' component is a
#' string vector identifying the relative path(s) to the datastore(s). The
#' 'Listing' component is a list where each component is a datastore listing.
#' The 'Functions' component contains the appropriate functions for the
#' datastore type for listing the datastore contents and for reading datasets.
#' @export
prepareForDatastoreQuery <- function(DstoreLocs_, DstoreType) {
  #Initialize list to hold query preparation information
  Prep_ls <- list()
  #Check that DstoreTypes are supported
  AllowedDstoreTypes_ <- c("RD", "H5")
  if (!DstoreType %in% AllowedDstoreTypes_) {
    Msg <-
      paste0("Specified 'DatastoreType' in the 'run_parameters.json' file - ",
             DstoreType, " - is not a recognized type. ",
             "Recognized datastore types are: ",
             paste(AllowedDstoreTypes_, collapse = ", "), ".")
    stop(Msg)
  }
  #Check that DstoreLocs_ are correct and assign
  DstoreLocsExist_ <- sapply(DstoreLocs_, function(x) file.exists(x))
  if (any(!DstoreLocsExist_)) {
    Msg <-
      paste0("One or more of the specified DstoreLocs_ can not be found. ",
             "Maybe they are misspecified. Check the following: ",
             DstoreLocs_[!DstoreLocsExist_])
    stop(Msg)
  } else {
    Prep_ls$Dir <- DstoreLocs_
  }
  #Assign datastore reading functions
  Prep_ls$Functions <- list()
  DstoreFuncs_ <- c("readFromTable", "listDatastore")
  for(DstoreFunc in DstoreFuncs_) {
    Prep_ls$Functions[[DstoreFunc]] <- get(paste0(DstoreFunc, DstoreType))
  }
  #Get listing for each datastore
  Prep_ls$Listing <- lapply(DstoreLocs_, function(x) {
    SplitRef_ <- unlist(strsplit(x, "/"))
    RefHead <- paste(SplitRef_[-length(SplitRef_)], collapse = "/")
    if (RefHead == "") {
      ModelStateFile <- "ModelState.Rda"
    } else {
      ModelStateFile <- paste(RefHead, "ModelState.Rda", sep = "/")
    }
    readModelState(FileName = ModelStateFile)
  })
  names(Prep_ls$Listing) <- DstoreLocs_
  #Return the query preparation list
  Prep_ls
}


#LIST GROUPS
#===========
#' Lists the names of groups in model datastores.
#'
#' \code{listGroups} a function which lists the groups in a datastore
#' or datastores that contain data for a scenario.
#'
#' This function lists the names of groups in a model datastore and any other
#' datastores that are referenced by a model run.
#'
#' @param QueryPrep_ls a list created by calling the prepareForDatastoreQuery
#' function which identifies the datastore location(s), listing(s), and
#' functions for listing and read the datastore(s).
#' @return A named list where each component is a vector of group names for a
#' datastore.
#' @export
listGroups <- function(QueryPrep_ls) {
  lapply(QueryPrep_ls$Listing, function(x) {
    DstoreListing_df <- x$Datastore
    Groups_ <- unique(DstoreListing_df$group)
    Groups_ls <- strsplit(Groups_, "/")
    Groups_ <- unique(unlist(lapply(Groups_ls, function(x) x[2])))
    Groups_[!is.na(Groups_)]
  })
}


#LIST TABLES IN GROUP
#====================
#' List names of tables in a group in a datastore.
#'
#' \code{listTables} a function which lists the tables in a group in a
#' datastore.
#'
#' This functions lists the tables in a group in a datastore.
#'
#' @param Group a string that is the name of the group to retrieve the table
#' names from.
#' @param QueryPrep_ls a list created by calling the prepareForDatastoreQuery
#' function which identifies the datastore location(s), listing(s), and
#' functions for listing and read the datastore(s).
#' @return A named list where each component is a vector of table names in the
#' group in the datastore(s).
#' @export
listTables <- function(Group, QueryPrep_ls) {
  lapply(QueryPrep_ls$Listing, function(x) {
    DstoreListing_df <- x$Datastore
    Tables_ <- unique(DstoreListing_df$group)
    Tables_ <- Tables_[grep(Group, Tables_)]
    Tables_ls <- strsplit(Tables_, "/")
    Tables_ <- unique(unlist(lapply(Tables_ls, function(x) x[3])))
    Tables_[!is.na(Tables_)]
  })
}


#LIST DATASETS IN GROUP
#======================
#' List names and descriptions datasets in a table in a datastore.
#'
#' \code{listTables} a function which lists the names and descriptions datasets
#' in a table in a datastore.
#'
#' This functions lists the names and descriptions datasets in a table in a
#' datastore.
#'
#' @param Group a string that is the name of the group to retrieve the table
#' datasets from.
#' @param Table a string that is the name of the table to retrieve the dataset
#' names and descriptions from.
#' @param QueryPrep_ls a list created by calling the prepareForDatastoreQuery
#' function which identifies the datastore location(s), listing(s), and
#' functions for listing and read the datastore(s).
#' @return A data frame which lists the dataset names and descriptions for
#' datasets in the identified table.
#' @export
listDatasets <- function(Table, Group, QueryPrep_ls) {
  lapply(QueryPrep_ls$Listing, function(x) {
    DstoreListing_df <- x$Datastore
    TableRef <- paste0("/", Group, "/", Table)
    DstoreListing_df <-
      DstoreListing_df[DstoreListing_df$group == TableRef, c("name", "attributes")]
    DstoreListing_df$Name <- DstoreListing_df$name
    DstoreListing_df$name <- NULL
    DstoreListing_df$Type <- unlist(lapply(DstoreListing_df$attributes, function(x) {
      Type <- x$TYPE
      if (is.null(Type)) Type <- ""
      Type
    }))
    DstoreListing_df$Units <- unlist(lapply(DstoreListing_df$attributes, function(x) {
      Units <- x$UNITS
      if (is.null(Units)) Units <- ""
      Units
    }))
    DstoreListing_df$Description <- unlist(lapply(DstoreListing_df$attributes, function(x) {
      Description <- x$DESCRIPTION
      if (is.null(Description)) Description <- ""
      Description
      }))
    DstoreListing_df$attributes <- NULL
    DstoreListing_df
  })
}


#CREATE EXCEL WORKBOOK TO DOCUMENT ALL DATASETS IN A DATASTORE GROUP
#===================================================================
#' Save an Excel workbook to document all tables/datasets in a datastore group.
#'
#' \code{documentGroupDatasets} save an Excel workbook which documents
#' datasets in all tables in a datastore group.
#'
#' This function inventories all datsets in the tables in a datastore group and
#' creates an Excel workbook where the dataset inventory for each table is in
#' a separate worksheet. Each worksheet lists the names of the datasets, their
#' types, their units, and descriptions.
#'
#' @param a string identifying the name of the Group in the datastore.
#' @param a string identifying the name of the Excel workbook file to save. The
#' name must include the relative path information if it is to be saved in other
#' than the current working directory.
#' @param QueryPrep_ls a list created by calling the prepareForDatastoreQuery
#' function which identifies the datastore location(s), listing(s), and
#' functions for listing and read the datastore(s).
#' @return a logical identifying whether the Excel file has been saved.
#' @export
#' @import xlsx
documentGroupDatasets <- function(Group, Filename, QueryPrep_ls) {
  Workbook_XL <- createWorkbook()
  Tables_ <- listTables(Group, QueryPrep_ls)$Datastore
  for (tb in Tables_) {
    TableSheet_XL <- createSheet(Workbook_XL, sheetName = tb)
    Dsets_df <- listDatasets(tb, Group, QueryPrep_ls)$Datastore
    addDataFrame(Dsets_df, TableSheet_XL, col.names = TRUE, row.names = FALSE,
                 startRow = 1, startColumn = 1, showNA = FALSE)
  }
  saveWorkbook(Workbook_XL, Filename)
  TRUE
}
#Example
# QPrep_ls <- prepareForDatastoreQuery(
#   DstoreLocs_ = c("Datastore"),
#   DstoreType = "RD"
# )
# documentGroupDatasets("Global", "Global_Group_Datasets.xlsx", QPrep_ls)
# documentGroupDatasets("2010", "Year_Group_Datasets.xlsx", QPrep_ls)
# rm(QPrep_ls)

#READ MULTIPLE DATASETS FROM DATASTORES
#======================================
#' Read multiple datasets from multiple tables in datastores
#'
#' \code{readDatastoreTables} a visioneval framework model user function that
#' reads datasets from one or more tables in a specified group in one or more
#' datastores
#'
#' This function can read multiple datasets in one or more tables in a group.
#' More than one datastore my be specified so that if datastore references are
#' used in a model run, datasets from the referenced datastores may be queried
#' as well. Note that the capability for querying multiple datastores is only
#' for the purpose of querying datastores for a single model scenario. This
#' capability should not be used to compare multiple scenarios. The function
#' does not segregate datasets by datastore. Attempting to use this function to
#' compare multiple scenarios could produce unpredictable results.
#'
#' @param Tables_ls a named list where the name of each component is the name of
#' a table in a datastore group and the value is a named string vector where the
#' names are the names of the datasets to be retrieved and the values are the
#' units of measure to be used for the retrieved values or NULL if the values
#' are to be retrieved in the units they are in in the datastore.
#' @param Group a string that is the name of the group to retrieve the table
#' datasets from.
#' @param QueryPrep_ls a list created by calling the prepareForDatastoreQuery
#' function which identifies the datastore location(s), listing(s), and
#' functions for listing and read the datastore(s).
#' @return A named list having two components. The 'Data' component is a list
#' containing the datasets from the datastores where the name of each component
#' of the list is the name of a table from which identified datasets are
#' retrieved and the value is a data frame containing the identified datasets.
#' The 'Missing' component is a list which identifies the datasets that are
#' missing in each table.
#' @export
readDatastoreTables <- function(Tables_ls, Group, QueryPrep_ls) {
  #Extract the datastore reading functions
  readFromTable <- QueryPrep_ls$Functions$readFromTable
  listDatastore <- QueryPrep_ls$Functions$listDatastore
  #Extract the datastore listings
  MS_ls <- QueryPrep_ls$Listing
  #Datastore locations
  DstoreLocs_ <- QueryPrep_ls$Dir
  #Get data from table
  Tb <- names(Tables_ls)
  Out_ls <- list()
  for (tb in Tb) {
    Out_ls[[tb]] <- list()
    Ds <- names(Tables_ls[[tb]])
    for (Loc in DstoreLocs_) {
      ModelState_ls <<- QueryPrep_ls$Listing[[Loc]]
      HasTable <- checkTableExistence(tb, Group, ModelState_ls$Datastore)
      if (HasTable) {
        for (ds in Ds) {
          HasDataset <- checkDataset(ds, tb, Group, ModelState_ls$Datastore)
          if (HasDataset) {
            if (is.null(Out_ls[[tb]][[ds]])) {
              Dset_ <-
                readFromTable(ds, tb, Group, DstoreLoc = Loc, ReadAttr = TRUE)
              if (Tables_ls[[tb]][ds] != "") {
                DsetType <- attributes(Dset_)$TYPE
                DsetUnits <- attributes(Dset_)$UNITS
                ToUnits <- Tables_ls[[tb]][ds]
                Dset_ <- convertUnits(Dset_, DsetType, DsetUnits, ToUnits)$Values
                attributes(Dset_)$TYPE <- DsetType
                attributes(Dset_)$UNITS <- ToUnits
              }
              Out_ls[[tb]][[ds]] <- Dset_
            }
          }
        }
      }
    }
    rm(ModelState_ls, pos = 1)
    Out_ls[[tb]] <- data.frame(Out_ls[[tb]])
  }
  #Identify missing datasets
  OutDsetNames_ls <- lapply(Out_ls, names)
  Missing_ls <- Tables_ls
  for (tb in Tb) {
    Missing_ls[[tb]] <- Tables_ls[[tb]][!(names(Tables_ls[[tb]]) %in% OutDsetNames_ls[[tb]])]
  }
  #Return the table data
  list(Data = Out_ls, Missing = Missing_ls)
}

# #Example
# #-------
# #Prepare for datastore query
# QPrep_ls <- prepareForDatastoreQuery(
#   DstoreLocs_ = c("Datastore"),
#   DstoreType = "RD"
# )
# #Develop the list of tables to get data for
# TablesRequest_ls <- list(
#   Household = c(
#     Bzone = "",
#     HhSize = "",
#     AveCO2ePM = "GM/MI",
#     Income = "",
#     Dvmt = "MI/YR"),
#   Bzone = c(
#     Bzone = "",
#     D1B = "PRSN/ACRE",
#     MFDU = "",
#     SFDU = "")
# )
# #Get the data
# TableResults_ls <-
#   readDatastoreTables(
#     Tables_ls = TablesRequest_ls,
#     Group = "2010",
#     QueryPrep_ls = QPrep_ls
#   )


#READ AND SUMMARIZE A DATASET
#============================
#' Summarize the values in a table dataset according to the values in another
#' dataset in the table.
#'
#' \code{summarizeDataset} summarize the values in a table dataset according to
#' the values in another dataset in the table.
#'
#' This function computes either the total or average values for a table dataset
#' by the values of another dataset in the table. For example, the total income
#' of households by Azone could be computed. In addition, if averages are
#' computed a dataset may be specified to use in calculating weighted averages.
#'
#' @param Expr a string specifying an expression to use to summarize the
#' datasets. Operands in the expression are the names of datasets to use to
#' create the summary. The only operators that may be used are '+', '-', '*',
#' and '/'. The only functions that may be used are 'sum', 'count', 'mean', and
#' 'wtmean'. Note that all the datasets must be located in the table specified
#' by the 'Table' argument.
#' @param Units_ a named character vector identifying the units to be used for
#' each operand in the expression. The values are allowable VE units values.
#' The names are the names of the operands in the expression. The vector must
#' have an element for each operand in the expression. Setting the value equal
#' to "" for an operand will use the units stored in the datastore.
#' @param By_ a vector identifying the names of the datasets that are used to
#' identify datasets to be used to group the expression calculation. If NULL,
#' then the entire datasets are used in the calculation. Note that all the
#' datasets must be located in the table specified by the 'Table' argument.
#' @param Breaks_ls a named list of vectors identifying the values to use for
#' splitting numeric datasets into categories. The names must be the same as
#' names of the datasets identified in the By_ vector. Each named component of
#' the list is a vector of values to be used to split the respective By
#' dataset into groups. Minimum and maximum values do not need to be specified
#' as they are computed from the dataset.
#' @param Table a string identifying the table where the datasets are located.
#' @param Group a string identifying the group where the dataset is located.
#' @param QueryPrep_ls a list created by calling the prepareForDatastoreQuery
#' function which identifies the datastore location(s), listing(s), and
#' functions for listing and read the datastore(s).
#' @return If the By_ argument is NULL or has a length of 1, the value of the
#' specified expression is calculated. Note that if the expression produces a
#' vector of more than one number the entire vector of numbers will be returned.
#' Users should check their expression to confirm that it will produce a single
#' number if that is what is desired. If the By_ argument is not null, values
#' will be returned for each group in the datasets specified in the By_
#' argument.
#' @export
summarizeDatasets <-
  function(
    Expr,
    Units_,
    By_ = NULL,
    Breaks_ls = NULL,
    Table,
    Group,
    QueryPrep_ls)
  {
    #Count function
    count <- function(x) length(x)
    #Weighted mean function
    wtmean <- function(x, w) sum(x * w) / sum(w)
    #Function to determine if is summary function in the expression
    isFun <- function(Name) {
      Name %in% c("sum", "count", "mean", "wtmean")
    }
    #Function to determine if is operator in the expression
    isOp <- function(Name) {
      Name %in% c("+", "-", "*", "/")
    }
    #Function to get the operands in an expression
    getOperands <- function(AST, Result = "") {
      if (length(AST) == 1) {
        if (!isFun(deparse(AST)) & !isOp(deparse(AST))) deparse(AST)
      } else {
        unlist(lapply(AST, function(x) getOperands(x)))
      }
    }
    #Identify the operands of the Expr
    Operands_ <- getOperands(str2lang(Expr))
    #Check that all operands have units
    if (!all(Operands_ %in% names(Units_))) {
      stop("Some of the operands in the expression don't have specified units.")
    }
    #Add the By dataset names and units to Units_
    if (!is.null(By_)) {
      ByUnits_ <- rep("", length(By_))
      names(ByUnits_) <- By_
      # Remove ByUnits_ names that are duplicates of Units_ names
      ByUnits_ <- ByUnits_[!(names(ByUnits_) %in% names(Units_))]
      Units_ <- c(Units_, ByUnits_)
    }
    #Get the datasets from the datastore
    Tables_ls <- list()
    Tables_ls[[Table]] <- Units_
    Data_ls <- readDatastoreTables(Tables_ls, Group, QueryPrep_ls)
    #Stop if any of the datasets are missing
    if (length(Data_ls$Missing[[Table]]) != 0) {
      MissingDsets_ <- paste(Data_ls$Missing[[Table]], collapse = ", ")
      Msg <- paste("The following datasets are not present in the",
                   Table, "table", "in the", Group, "group:", MissingDsets_)
      stop(Msg)
    }
    #Simplify the data list
    Data_ls <- list(data.frame(Data_ls$Data[[Table]]))
    #Process the data list using the By_ argument
    if (!is.null(By_)) {
      By_ls <- list()
      #Check and process the By data into categories
      for (nm in By_) {
        ByData_ <- Data_ls[[1]][[nm]]
        if (is.factor(ByData_)) {
          By_ls[[nm]] <- ByData_
        }
        if (is.character(ByData_)) {
          By_ls[[nm]] <- as.factor(ByData_)
        }
        if (is.integer(ByData_) | all(round(ByData_) == as.integer(ByData_))) {
          ByData_ <- as.integer(ByData_)
          if (!is.null(Breaks_ls[[nm]])) {
            Breaks_ <- unique(c(min(ByData_), Breaks_ls[[nm]], max(ByData_)))
            By_ls[[nm]] <- cut(ByData_, Breaks_, include.lowest = TRUE)
          } else {
            By_ls[[nm]] <- as.factor(ByData_)
          }
        }
        if (is.double(ByData_) & !all(round(ByData_) == as.integer(ByData_))) {
          if (!is.null(Breaks_ls[[nm]])) {
            Breaks_ <- unique(c(min(ByData_), Breaks_ls[[nm]], max(ByData_)))
            By_ls[[nm]] <- cut(ByData_, Breaks_, include.lowest = TRUE)
          } else {
            stop(paste(nm, "is non-integer number. Breaks must be specified."))
          }
        }
      }
      Data_ls <- split(Data_ls[[1]], By_ls)
    }
    #Evaluate the expression using each component of the Data_ls
    lapply(Data_ls, function(x) {
      eval(parse(text = Expr), envir = x)
    })

  }

# #Examples of summarizing datasets
# #================================
# #Assumes Datastore of VE-RSPM in working directory
#
# #Prepare to make dataset summaries
# QPrep_ls <- prepareForDatastoreQuery(
#   DstoreLocs_ = c("Datastore"),
#   DstoreType = "RD"
# )
#
# #Summing a dataset
# summarizeDatasets(
#   Expr = "sum(Dvmt)",
#   Units_ = c(
#     Dvmt = "MI/DAY"
#   ),
#   Table = "Household",
#   Group = "2010",
#   QueryPrep_ls = QPrep_ls
# )
#
# #Converting units while summing a dataset
# summarizeDatasets(
#   Expr = "sum(Dvmt)",
#   Units_ = c(
#     Dvmt = "KM/DAY"
#   ),
#   Table = "Household",
#   Group = "2010",
#   QueryPrep_ls = QPrep_ls
# )
#
# #Counting number of records in dataset
# #Note: "" for units uses units stored in datastore
# summarizeDatasets(
#   Expr = "count(HhSize)",
#   Units_ = c(
#     HhSize = ""
#   ),
#   Table = "Household",
#   Group = "2010",
#   QueryPrep_ls = QPrep_ls
# )
#
# #Mean of dataset
# summarizeDatasets(
#   Expr = "mean(AveGPM)",
#   Units_ = c(
#     AveGPM = "GGE/MI"
#   ),
#   Table = "Household",
#   Group = "2010",
#   QueryPrep_ls = QPrep_ls
# )
#
# #Weighted mean of dataset
# summarizeDatasets(
#   Expr = "wtmean(AveGPM, Dvmt)",
#   Units_ = c(
#     AveGPM = "GGE/MI",
#     Dvmt = "MI/DAY"
#   ),
#   Table = "Household",
#   Group = "2010",
#   QueryPrep_ls = QPrep_ls
# )
#
# #More complicated expression to calculate average autos per household
# summarizeDatasets(
#     Expr = "sum(NumAuto) / sum(HhSize)",
#     Units_ = c(
#       NumAuto = "VEH",
#       HhSize = "PRSN"
#     ),
#     Table = "Household",
#     Group = "2010",
#     QueryPrep_ls = QPrep_ls)
#
# #Alternate expression to calculate average autos per household using weighted mean
# summarizeDatasets(
#   Expr = "wtmean(NumAuto / HhSize, HhSize)",
#   Units_ = c(
#     NumAuto = "VEH",
#     HhSize = "PRSN"
#   ),
#   Table = "Household",
#   Group = "2010",
#   QueryPrep_ls = QPrep_ls)
#
# #Calculate average autos per household by household size
# summarizeDatasets(
#   Expr = "sum(NumAuto) / sum(HhSize)",
#   Units_ = c(
#     NumAuto = "VEH",
#     HhSize = "PRSN"
#   ),
#   By_ = "HhSize",
#   Table = "Household",
#   Group = "2010",
#   QueryPrep_ls = QPrep_ls)
#
# #Specify breaks for establish household size groups
# summarizeDatasets(
#   Expr = "sum(NumAuto) / sum(HhSize)",
#   Units_ = c(
#     NumAuto = "VEH",
#     HhSize = "PRSN"
#   ),
#   By_ = "HhSize",
#   Breaks_ls = list(
#     HhSize = c(0,1,2,3,4)
#   ),
#   Table = "Household",
#   Group = "2010",
#   QueryPrep_ls = QPrep_ls)
#
# #Split by household size and income groups
# summarizeDatasets(
#   Expr = "sum(NumAuto) / sum(HhSize)",
#   Units_ = c(
#     NumAuto = "VEH",
#     HhSize = "PRSN"
#   ),
#   By_ = c(
#     "HhSize",
#     "Income"),
#   Breaks_ls = list(
#     HhSize = c(0,1,2,3,4),
#     Income = c(20000, 40000, 60000, 80000, 100000)
#   ),
#   Table = "Household",
#   Group = "2010",
#   QueryPrep_ls = QPrep_ls)
