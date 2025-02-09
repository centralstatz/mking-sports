# Created: 2025-02-08
# Description: Creates global objects for access within app

## Load packages
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(tidyverse)
library(tigris)
library(leaflet)
library(DT)

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

# NCAA participation
ncaa_participation <-
  read_csv(
    file = paste0(base_path, "NCAA_Participation_Numbers.csv")
  ) |>
  
  # Extract components
  mutate(
    Gender = str_extract(Sport, pattern = "^(Mens|Womens)"),
    Sport = str_remove(Sport, pattern = "^(Mens|Womens)")
  ) |>
  
  # Move around
  relocate(Gender, .after = Sport)

# NCAA sports by year
ncaa_sports_by_year <- 
  read_csv(
    file = paste0(base_path, "NCAA_Sports_by_Year.csv")
  ) |>
  
  # Extract components
  mutate(
    Gender = str_extract(Sport, pattern = "^(M|W)"),
    Gender = 
      case_when(
        Gender == "M" ~ "Mens",
        TRUE ~ "Womens"
      ),
    Sport = str_remove(Sport, pattern = "^(M|W)_")
  ) |>
  
  # Move around
  relocate(Gender, .after = Sport)

# NCAA Power 4 Standings
ncaa_power4_standings <- 
  read_csv(
    file = paste0(base_path, "Power4_Standings.csv")
  ) |>
  
  # Send down the rows
  pivot_longer(
    cols = -c(Year, School, Conference, Total, Average, PerSport),
    names_to = "Variable",
    values_to = "Value"
  ) |>
  
  # Separate components
  mutate(
    
    # Boy or girl sport
    Gender = str_extract(Variable, pattern = "^(Mens|Womens)"),
    
    # Sport name
    Sport =
      Variable |>
      
      # Remove the gender
      str_remove(pattern = "^(Mens|Womens)") |>
      
      # Remove the measure
      str_remove(pattern = "_(Place|Points)$"),
    
    # Count of schools or participants
    Measure = str_extract(Variable, pattern = "(Place|Points)$")
  ) |>
  
  # Send measures across the columns
  pivot_wider(
    names_from = Measure,
    values_from = Value,
    id_cols = 
      c(
        School,
        Conference,
        Gender,
        Sport,
        Total,
        Average,
        PerSport
      )
  ) |>
  
  # Remove non-ranked categories
  filter(!is.na(Place))

# ODP Interregionals
odp_interregionals <-
  read_csv(
    file = paste0(base_path, "ODP_Interregionals.csv")
  ) |>
  
  # Send down the rows
  pivot_longer(
    cols = -c(State, Region),
    names_to = "Variable",
    values_to = "Value"
  ) 

# World Cup Matches
world_cup_matches <-
  read_csv(
    file = paste0(base_path, "WorldCup_Matches.csv")
  )

## Metadata

# Cache downloaded data
options(tigris_use_cache = TRUE)

# US State shape files
state_boundaries <- states()
