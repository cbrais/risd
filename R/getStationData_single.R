#' Data retrieval from NOAA's Integrated Surface Database (ISD) for single station
#'
#' Retrieves climate data from a single ISD station for a given year range.
#' \code{getStationData_single()} expands on rnoaa's \code{isd()} function, by allowing to append data for multiple years in the same data frame and catching and ignoring errors.
#'
#' @import rnoaa
#' @import tidyverse
#' @param years year range (numeric).
#' @param usaf station USAF (United States Air Force) ID number (numeric).
#' @param wban station WBAN (Weather Bureau Army Navy) ID number (numeric).
#' @return Returns a data frame with the data for the available years in the range given.
#' @note USAF and WBAN numbers for a station can be found with the function \code{getStationInfo()} if the name of the station is known, or with rnoaa's \code{isd_stations_search()} if the station location is known.
#' @examples
#' stmatthewsIsland  <- getStationData_single(1945, 749231, 99999)
#' adakIsland        <- getStationData_single(2010:2018, 997380, 99999) # With error message
#' mtl               <- getStationData_single(1954:1956, 713721, 99999) # With warning message
#' borabora          <- getStationData_single(1942:1945, 919300, 99999) # With warning and error message
#' @export
getStationData_single <- function(years, usaf, wban) {
  isdStations <- isd_stations()              # Loading metadata for ISD stations, to retrieve start and end dates
  alldata <- data.frame(NULL)                # Creating empty data frame to host data for all years at all stations
  warningmessage <- NULL                     # Initializing warning message
  errormessage <- NULL                       # Initializing error message
  safe_isd <- safely(isd, otherwise = NULL)  # Allows isd() function to catch and ignore errors

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
        error <- output$error                     # Storing error message

        if(is.null(error)==FALSE) {                                                             # Retrieving error message if applicable
          warning(error$message)                                                                # Displaying errors (with file path)
          erroryears <- paste0(erroryears, i, " ")                                              # Years at which error occurred (for error message)
          errorstationinfo <- paste0("'Error: download failed' for station ", usaf, "-", wban,  # Error message with station info
                                     " (",  isdStations$station_name[isdStations$usaf==usaf&isdStations$wban==wban], ") for the following year(s): ")
        }

      } else {                                                   # If one or more years are unavailable
        warningstationinfo <- paste0(" YEAR(S) NOT AVAILABLE AT STATION ", usaf, "-", wban, " (",
                                     isdStations$station_name[isdStations$usaf==usaf&isdStations$wban==wban], "): ") # Warning message with station info
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
  # Displaying warning/error message if one or more years are unavailable, and/or if one or more errors occurred
  if (is.null(warningmessage) == FALSE & is.null(errormessage) == FALSE) {
    warning("\n\nWARNING SUMMARY\nThe following data are unavailable:\n", warningmessage, sep = "",
            "\nERROR SUMMARY\nWe caught and ignored the following error messages:\n", errormessage, sep = "")
  } else if (is.null(warningmessage) == FALSE) {
    warning("\n\nWARNING SUMMARY\nThe following data are unavailable:\n", warningmessage, sep = "")
  } else if (is.null(errormessage) == FALSE) {
    warning("\n\nERROR SUMMARY\nWe caught and ignored the following error messages:\n", errormessage, sep = "")
  }
  return (alldata) # Returning data frame with the station data for all years
}
