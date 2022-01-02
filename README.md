# risd
R Package: Climate Data from ISD (NOAA) Stations, Adding on 'rnoaa' Package

'risd' contains functions to help in the download and use of climate data from the Integrated Surface Database (ISD), which is managed by NOAA (National Oceanic and Atmospheric Administration). For more information on the ISD, see https://www.ncei.noaa.gov/products/land-based-station/integrated-surface-database. 'risd' builds on the package 'rnoaa' (https://github.com/ropensci/rnoaa), which connects to various NOAA data sources.

## Function List
`celcius()`                                  Fahrenheit to Celsius temperature conversion

`fahrenheit()`                            Celsius to Fahrenheit temperature conversion

`getStationData_single()`      Data retrieval from ISD for a single station over multiple years

`getStationData_all()`            Data retrieval from ISD for multiple stations and years

`getStationInfo()`                    Station metadata from ISD

`isdTempSummary_daily()`        Daily temperature summaries from ISD data

`isdTempSummary_monthly()`    Monthly temperature summaries from ISD data

## Installation

First, intall the 'devtools' package (if already intalled skip to step 2):

```
install.packages("devtools")
```

Installing 'risd' into R: 

```
devtools::install_github("cbrais/risd")
```

## Contact
For information please email camille.brais@mac.com
