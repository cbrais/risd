#' Data retrieval from NOAA's Integrated Surface Database (ISD) for multiple stations
#'
#' Retrieves climate data from a multiple ISD stations for a given year range and list of stations.
#' \code{getStationData_all()} expands on rnoaa's \code{isd()} function, by allowing to append data for multiple years and multiple stations in the same data frame and catching and ignoring errors.
#'
#' @import rnoaa
#' @import tidyverse
#' @param years year range (numeric).
#' @param stationsList list of stations (data frame, in the same format as what is returned by rnoaa's \code{isd_stations()} or \code{isd_stations_seach()}).
#' @return Returns a data frame with the data for the available years and stations in the range given.
#' @examples
#' ## Retrieving station lists used in the examples below:
#' faroeIslands <- isd_stations_search(lat = 61.883097, lon = -6.738111, radius = 92.49) # 6 stations
#' adakIsland <- isd_stations_search(lat = 51.88, lon = -176.63, radius = 1.3)           # 1 station
#' iceland <- isd_stations_search(lat = 64.827948, lon = -18.886747, radius = 314.9)     # 92 stations
#'
#'## getStationData_all() examples:
#' adak  <- getStationData_all(2008:2009, adakIsland)             # No error messages, no missing years
#' adak  <- getStationData_all(2010:2018, adakIsland)             # Error messages, no missing years
#' faroe <- getStationData_all(2020:2021, faroeIslands)           # No error messages, some missing years
#' icelandSubset <- getStationData_all(2010:2011, iceland[1:20,]) # Error messages and missing years
#' @export
getStationData_all <- function(years, stationsList) {
  isdStations <- isd_stations()              # Loading metadata for ISD stations, to retrieve start and end dates
  alldata <- data.frame(NULL)                # Creating empty data frame to host data for all years at all stations
  warningmessage <- NULL                     # Initializing warning message
  errormessage <- NULL                       # Initializing error message
  safe_isd <- safely(isd, otherwise = NULL)  # Allows isd() function to catch and ignore errors

  for (row in 1:nrow(stationsList)) {                                                         # Looping through all stations
    usaf <- stationsList$usaf[row]                                                            # Retrieving station usaf number from isdStations data frame
    wban <- stationsList$wban[row]                                                            # Retrieving station wban number from isdStations data frame
    begins <- substr(isdStations[isdStations$usaf==usaf&isdStations$wban==wban,]$begin, 1, 4) # Start date for data at that station
    ends   <- substr(isdStations[isdStations$usaf==usaf&isdStations$wban==wban,]$end, 1, 4)   # End date for data at that station
    dataRange <- c(begins:ends)                                                               # Range of data for that station
    missingyears <- NULL                         # Initializing for warning message
    erroryears <- NULL                           # Initializing for error message
    x <- 0                                       # Initializing for warning message (number of missing years)

    for (i in years) {                           # Looping through years of interest
      if (i %in% dataRange) {                    # Running code only for available years
        safe_isd(                                # Retrieving data from ISD
          usaf,                                  # Station USAF number
          wban,                                  # Station WBAN number
          i,                                     # Year
          parallel = TRUE,                       # Makes process faster
          cores = getOption("cl.cores", 2),      # Number of cores the computer has
        ) -> output                              # safe_isd() outputs both results and error messages if applicable in a list
        yeardata <- output$result                # Storing data for year i in a data frame
        alldata <- bind_rows(alldata, yeardata)  # Appending each year at the end of the data frame
        error <-output$error                     # Storing error message

        if(is.null(error)==FALSE) {                                                             # Retrieving error message if applicable
          errorstationinfo <- paste0("'Error: download failed' for station ", usaf, "-", wban,  # Error message with station info
                                     " (", stationsList$station_name[row], ") for the following year(s): ")
          erroryears <- paste0(erroryears, i, " ")                                              # Years at which error occurred (for error message)
          warning(error$message)                                                                # Displaying errors (with file path)
        }

      } else {                                                  # If one or more years are unavailable
        warningstationinfo <- paste0(" YEAR(S) NOT AVAILABLE AT STATION ", usaf, "-", wban, " (",
                                     stationsList$station_name[row], "): ") # Warning message with station info
        missingyears <- paste0(missingyears, i, " ")             # Unavailable years (for warning message)
        x <- x+1                                                 # Number of unavailable years (for warning message)
      }
    }
    # Updating warning message if one or more years is/are unavailable
    if (x >= 1) {
      warningmessage <- paste0(warningmessage, x, warningstationinfo, missingyears, "\n")
    }
    # Updating error message if an error occurs
    if (is.null(erroryears) == FALSE) {
      errormessage <- paste0(errormessage, errorstationinfo, erroryears, "\n")
    }
  }
  # Displaying warning/error message if one or more years are unavailable, and/or if one or more errors occurred
  if (is.null(warningmessage) == FALSE & is.null(errormessage) == FALSE) {
    warning("\n\nWARNING SUMMARY\nThe following data are unavailable:\n", warningmessage, sep = "",
            "\nERROR SUMMARY\nWe caught and ignored the following error messages:\n", errormessage, sep = "")
  } else if (is.null(warningmessage) == FALSE) {
    warning("\n\nWARNING SUMMARY\nThe following data are unavailable:\n", warningmessage, sep = "")
  } else if (is.null(errormessage) == FALSE) {
    warning("\n\nERROR SUMMARY\nWe caught and ignored the following error messages:\n", errormessage, sep = "")
  }
  return (alldata) # Returning data frame with data for all stations at all years
}
