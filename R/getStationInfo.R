#' Station information from NOAA's Integrated Surface Database (ISD)
#'
#' Retrieves information (including station name and USAF and WBAN numbers) for a station in the ISD based on its name OR its USAF and WBAN numbers.
#'
#' @note
#' Trying to use only a usaf or wban number (not both) will result in an error message.
#'
#' @import rnoaa
#' @param stnname station name (character).
#' @param usaf station USAF (United States Air Force) ID number (numeric).
#' @param wban station WBAN (Weather Bureau Army Navy) ID number (numeric).
#' @return Returns a data frame containing metadata for all stations that are a match for the name (station name contains stnname):
#'
#' USAF (United States Air Force) number,
#' WBAN (Weather Bureau Army Navy) number,
#' Station name,
#' Country,
#' State,
#' icao (International Civil Aviation Organization) code,
#' Latitude (decimal degrees),
#' Longitude (decimal degrees),
#' Elevation (meters),
#' Data start date,
#' Data end date.
#' @examples
#' adakInfo <- getStationInfo("adak")            # Getting station metadata on Adak, Alaska
#' mtlInfo <- getStationInfo(name = "montreal")  # Getting station metadata on Montreal, Quebec
#' adakNASInfo <- getStationInfo("ADAK (NAS)")   # Getting station metadata on Adak (NAS) station, Alaska
#' boraboraInfo <-getStationInfo(name = "bora")  # Getting station metadata on Bora Bora, French Polynesia
#' # Note that the previous example includes stations that are not Bora Bora, and that using "bora bora" would exclude
#' # stations that are Bora Bora (such as Bora-Bora). So use caution!
#'
#' adakNASInfo <- getStationInfo(usaf = 704540, wban = 99999) # Getting station metadata on Adak (NAS) station, Alaska
#' mtlEstInfo <- getStationInfo(usaf = 713721, wban = 99999)  # Getting station metadata on Montreal-Est station, Quebec
#' @export
getStationInfo <- function(name = NULL, usaf = NULL, wban = NULL) {
  isdStations <- isd_stations()                                                          # Retrieving metadata on all ISD stations
  if (is.null(name) == FALSE){                                                           # If the input is a station name
    stationInfo <- isdStations[grep(name, isdStations$station_name, ignore.case=TRUE),]  # Looking for station name in all isdStations station_name rows
  } else {                                                                               # If the input is usaf and wban numbers
    stationInfo <- isdStations[(isdStations$usaf==usaf & isdStations$wban==wban),]       # Looking for usaf-wban combination in all isdStations usaf and wban rows
  }
    return(stationInfo)                                                                  # Returning a data frame with metadata for all the matches in the ISD stations
}
