# mking-sports

A [Shiny](https://shiny.posit.co/) application hosted on [Posit Connect Cloud](https://connect.posit.cloud/) containing various high school, college and professional sports data analyses.

# Change Log

## 2/8/2025

* Copy theme and appearance of the [existing data dashboard](https://01949177-2ccc-ffe2-3233-5a7c0dade354.share.connect.posit.cloud/) ([Source code](https://github.com/centralstatz/mking-dashboard))
* Added dependency for the `tidyverse` package
* Added dependency for the `tigris` package for retrieving map data
* Added dependency for `leaflet` to create interactive maps
* HS Sports Participation
  + Separated out gender, sport, and measure
  + Missing (blank) cells in original data were treated as missing (unknown) instead of implied 0's
  + Displaying data through an interactive USA map (structure up, not reactive yet)
* Created initial `manifest.json` file with `rsconnect::writeManifest()` to deploy to Posit Connect Cloud

## 2/9/2025

* Added dependency to the `DT` package
* Added all datasets currently available on GitHub (missing Power 4 Budgets and Grand Slam Champions)
  + For now, just added a simple data table to see the (lightly processed) raw data