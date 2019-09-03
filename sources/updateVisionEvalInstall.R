#updateVisionEvalInstall.R
#-------------------------
#This script defines a function which enables users to update one or more
#packages in an official VisionEval installation 
#(see https://visioneval.org/category/download.html) with additional or
#modified VisionEval source packages hosted on GitHub. The function 
#documentation explains usage. Use of this function requires that the httr and 
#devtools packages be installed and loaded. Following is an example of how
#the function may be used.
#
#Example
#-------
# library(devtools)
# library(httr)
# updateVisionEvalInstall(
#   From = list(
#     Repository = "gregorbj/OregonDOT-VisionEval", 
#     Branch = "master"
#   ),
#   Packages = c(
#     "sources/modules/VEPowertrainsAndFuelsxAPx20180302x20181213",
#     "sources/modules/VEPowertrainsAndFuelsxSTSRecx2017x20181213",
#     "sources/modules/VESimLandUse",
#     "sources/modules/VETravelPerformance",
#     "sources/modules/VEReports"
#   ),
#   VEInstallationDir = "~/VE_361"
# )


#Define function to update VisionEval installation
#-------------------------------------------------
#' Updates packages in a VisionEval installation
#' 
#' \code{updateVisionEvalInstall} updates packages in a VisionEval installation
#' from a GitHub repository.
#' 
#' This function updates the packages in an official VisionEval installation
#' (see https://visioneval.org/category/download.html) from a GitHub
#' repository containing VisionEval source packages. It can be used to replace 
#' installed packages with replancements that include bug fixes or to add new 
#' packages to the installation. Note that this function currently will only
#' install R source packages. It will not install R binary packages.
#' 
#' @param From a list having the following 2 named components:
#' Repository - the name of the GitHub repository that the packages to install
#' reside in; and,
#' Branch - the repository branch to use (e.g. master).
#' @param Packages a character vector identifying the package path name(s) in 
#' the repository for the package(s) to be installed
#' (e.g. 'sources/modules/VETravelPerformance').
#' @param VEInstallationDir a string identifying the path of the directory
#' to the VisionEval installation that is to be updated (e.g. '~/VisionEval')
#' @param Host a string identifying the URL where the repository is hosted. The
#' default value is 'https://api.github.com/repos/'. 
#' @return None.
#' @export
#' @import httr devtools
updateVisionEvalInstall <- 
  function(From, Packages, VEInstallationDir, Host = "https://api.github.com/repos/") {
    
    #Set up
    #------
    #Identify CRAN repository if not set
    if (is.null(getOption("repos")["CRAN"])) {
      options(repos = c(CRAN = "https://cran.rstudio.com/"))
    }
    #Check path of VisionEval installation
    if (!dir.exists(VEInstallationDir)) {
      ErrMsg <- "Installed VisionEval directory identified by 'Where' argument is not present. Recheck to make sure that the proper path is specified."
      stop(ErrMsg)
    }
    #Identify where VisionEval packages are to be installed and check that exists
    PkgInstallDir <- file.path(VEInstallationDir, "ve-lib")
    if (!dir.exists(PkgInstallDir)) {
      ErrMsg <- "The specified VisionEval directory does not appear to be a standard VisionEval installation (see https://visioneval.org/category/download.html). This function will only update a standard VisionEval installation."
    } else {
      .libPaths(PkgInstallDir)
    }
    
    #Download the GitHub repository where the packages are located
    #-------------------------------------------------------------
    #Create a temporary directory in which to store the copy of the repository
    TempDir <- tempdir()
    dir.create(TempDir)
    #Name of downloaded zip file
    RepoDownloadFile <- file.path(TempDir, "Repo.zip")
    #Download the repository
    cat("\nDownloading VE repository to", RepoDownloadFile, "\n")
    request <- httr::GET(paste0(Host, From$Repository, "/zipball/", From$Branch))
    if(httr::status_code(request) >= 400){
      stop("\nError downloading the repository\n")
    }
    #Write the downloaded repository to zip file
    writeBin(httr::content(request, "raw"), RepoDownloadFile)
    
    #Install the packages from the downloaded copy of the repository
    #---------------------------------------------------------------
    #Unzip the repository copy
    TempRepoDir <- file.path(TempDir, "Repo")
    unzip(zipfile = RepoDownloadFile, exdir = file.path(TempDir, "Repo"))
    RepoName <- dir(TempRepoDir) #The unzipped repository name
    #Install packages
    for (Pkg in Packages) {
      devtools::install_local(
        path = file.path(TempRepoDir, RepoName, Pkg), 
        dependencies = TRUE,
        upgrade = FALSE)
    }
}