#' Celsius to Fahrenheit
#'
#' Converts temperature values from degrees Celcius to degrees Fahrenheit
#' @param tempC temperature value(s) in degrees Celcius (numeric).
#' @return Temperature value(s) in degrees Fahrenheit (numeric).
#' @keywords fahrenheit celcius
#' @examples
#' fahrenheit(15)
#' fahrenheit(-10)
#' fahrenheit(c(-17.7, -40, 4))
#' @export
fahrenheit <- function (tempC){
  tempF <- (tempC*1.8+32)
  return(tempF)
}

#' Fahrenheit to Celsius
#'
#' Converts temperature values from degrees Fahrenheit to degrees Celcius
#' @param tempC temperature value(s) in degrees Fahrenheit (numeric).
#' @return Temperature value(s) in degrees Celcius (numeric).
#' @keywords fahrenheit celcius
#' @examples
#' celcius(59)
#' celcius(14)
#' celcius(c(0.14, -40, 39.2))
#' @export
celcius <- function (tempF){
  tempC <- ((tempF-32)/1.8)
  return(tempC)
}
