# Created: 2025-02-08
# Description: Defines the app functionality

# Define the server function
server <- 
  function(input, output, session) {
    
    ### High School Sports
    
    ## Participation
    
    # Current dataset
    current_map_data <- 
      reactive({
        
        state_boundaries |>
          
          # Join to get selected values
          inner_join(
            y =
              hs_sports_participation |>
              filter(
                Gender == "Girls",
                Sport == "Basketball",
                Measure == "Schools"
              ),
            by = c("STUSPS" = "State")
          ) |>
          
          filter(STUSPS %in% setdiff(hs_sports_participation$State, c("AK", "HI")))
        
      })
    
    # Make map
    output$hs_sports_participation_map <-
      renderLeaflet({
        
        # Create a color pallete
        pal <- 
          colorNumeric(
            palette = "RdYlGn",
            domain = -1*unique(current_map_data()$Value)
          )
        
        leaflet() |>
          
          # Add background
          addTiles() |>
          
          # Add state boundaries
          addPolygons(
            data = current_map_data(),
            color = "black",
            fillColor = ~pal(-1*Value),
            weight = 1,
            opacity = .5,
            fillOpacity = .35,
            highlightOptions = 
              highlightOptions(
                color = "black",
                weight = 3,
                bringToFront = FALSE
              ),
            label = ~NAME,
            popup = 
              ~paste0(
                "State: ", NAME, 
                "<br>Sport: ", Sport,
                "<br>Gender: ", Gender,
                "<br>", Measure, ": ", Value
              )
          )
        
      })
    
    
  }