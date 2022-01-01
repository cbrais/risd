# *risd*
R Package: Climate Data from ISD (NOAA) Stations, Adding on 'rnoaa' Package

Functions to help in download of climate data from the National Oceanic and Atmospheric Administration (NOAA)'s Integrated Surface Database (ISD; https://www.ncei.noaa.gov/products/land-based-station/integrated-surface-database), building on package 'rnoaa' (https://github.com/ropensci/rnoaa).

## Function List
`celcius()`                                  Fahrenheit to Celsius temperature conversion

`fahrenheit()`                            Celsius to Fahrenheit temperature conversion

`getStationData_all()`            Data retrieval from NOAA's Integrated Surface Database (ISD) for multiple stations

`getStationData_single()`      Data retrieval from NOAA's Integrated Surface Database (ISD) for single station

`getStationInfo()`                    Station information from NOAA's Integrated Surface Database (ISD)

`isdTempSummary_daily()`        Daily temperature summaries from NOAA's Integrated Surface Database (ISD)

`isdTempSummary_monthly()`    Monthly temperature summaries from NOAA's Integrated Surface Database (ISD)

## Install
To load package into R: `devtools::install_github("cbrais/risd")`

If devtools package not yet installed: `install.packages("devtools")`

## Contact
For information please email camille.brais@mac.com
