#' Monthly temperature summaries from NOAA's Integrated Surface Database (ISD)
#'
#' Computes daily temperature summaries (mean, max and min) from ISD station climate data
#'
#' @import rnoaa
#' @import tidyverse
#' @import lubridate
#' @param isd_station_data  A data frame containing ISD station data, as outputed by rnoaa's \code{isd()} or risd's \code{getStationData_single()} or \code{getStationData_all()}.
#' @param f Option to convert to Fahrenheit (default is \code{FALSE}).
#' @return Returns a data frame with the monthly temperature summaries for the station data.
#' @examples
#' stmattTempSumm <-  isdTempSummary_monthly(stmatthewsIsland1940)           # Data retrieved with getStationData_single()
#' stmattTempSummF <- isdTempSummary_monthly(stmatthewsIsland1940, f = TRUE) # Same as above, but in Fahrenheit
#' icelandTempSumm <- isdTempSummary_monthly(icelandSubset)                  # Data retrieved with getStationData_all()
#' @export
isdTempSummary_monthly <- function(isd_station_data, f = FALSE) {
  ## Formatting input data:
  # Convert temperature from character to integer and putting the decimal in
  isd_station_data$temperature <- as.integer(isd_station_data$temperature)/10
  # Coding 999.9 values as NA for temperature
  isd_station_data$temperature[isd_station_data$temperature == 999.9] <- NA
  # Converting date from character to POSIXct
  isd_station_data$date <- as.POSIXct(strptime(isd_station_data$date, format="%Y%m%d", tz = "GMT"))
  if (f == TRUE) {
    # Converting to fahrenheit
    isd_station_data$temperature <- (1.8*isd_station_data$temperature+32)
  }
  # Creating usaf-wban column to identify stations:
  isd_station_data$usaf_wban <- paste(isd_station_data$usaf_station, isd_station_data$wban_station, sep = "-")

  # Monthly mean temperature
  mean <- isd_station_data %>%
    group_by(usaf_wban, year(date), month(date)) %>%
    summarize(isd.mean_temp = mean(temperature, na.rm = TRUE))
  # Monthly min temperature
  min <- isd_station_data %>%
    group_by(usaf_wban, year(date), month(date)) %>%
    summarize(isd.min_temp = min(temperature, na.rm = TRUE))
  # Monthly max temperature
  max <- isd_station_data %>%
    group_by(usaf_wban, year(date), month(date)) %>%
    summarize(isd.max_temp = max(temperature, na.rm = TRUE))
  # Grouping into one data frame
  temp_summary <- cbind(mean, isd.min_temp = min$isd.min_temp, isd.max_temp = max$isd.max_temp)
  # Adding date column for plotting purposes
  temp_summary <- temp_summary %>%
    add_column(date = as.POSIXct(strptime(paste0(temp_summary$`year(date)`,
                                                 as.character(str_pad(temp_summary$`month(date)`, 2, pad = "0")), "01"),
                                          format = "%Y%m%d", tz = "GMT")), .before = 1) %>%
    return(temp_summary) # Returning monthly temp summary data frame
}
