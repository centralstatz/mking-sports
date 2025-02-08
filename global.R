# Created: 2025-02-08
# Description: Creates global objects for access within app

## Load packages
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(tidyverse)
library(tigris)
library(leaflet)

## Load data files

# Set base path (sourcing straight from GitHub)
base_path <- "https://raw.githubusercontent.com/mking579/Dashboard/refs/heads/main/csv%20files/"

# Import data files
hs_sports_participation <- 
  read_csv(file = paste0(base_path, "HSSportsParticipation.csv"))|>
  
  # Send everything down the rows
  pivot_longer(
    cols = -State,
    names_to = "Variable",
    values_to = "Value"
  ) |>
  
  # Separate components
  mutate(
    
    # Boy or girl sport
    Gender = str_extract(Variable, pattern = "^(Girls|Boys)"),
    
    # Sport name
    Sport =
      Variable |>
      
      # Remove the gender
      str_remove(pattern = "^(Girls|Boys)") |>
      
      # Remove the measure
      str_remove(pattern = "(Schools|Participants|Partiipants)$"),
    
    # Count of schools or participants
    Measure = str_extract(Variable, pattern = "(Schools|Participants|Partiipants)$"),
    Measure = 
      case_when(
        Measure == "Partiipants" ~ "Participants",
        TRUE ~ Measure
      )
  ) |>
  
  # Remove rows missing counts
  filter(!is.na(Value)) |>
  
  # Rearrange
  select(-Variable) |>
  relocate(Value, .after = Measure)

## Metadata

# Cache downloaded data
options(tigris_use_cache = TRUE)

# US State shape files
state_boundaries <- states()
