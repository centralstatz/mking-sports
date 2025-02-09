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
    
    ### NCAA Sports
    
    ## Participation
    
    # Make dataset
    current_ncaa_sports_participation_data <-
      reactive({
        
        # Full data by default
        temp_dat <- ncaa_participation
        
        # Filter only if selected
        if(!is.null(input$ncaa_sports_participation_gender))
          temp_dat <- temp_dat |> filter(Gender %in% input$ncaa_sports_participation_gender)
        
        temp_dat
        
      })
    
    # Make the table
    output$ncaa_sports_participation_table <- renderDataTable({current_ncaa_sports_participation_data()})
    
    ## By Year
    
    # Make dataset
    current_ncaa_sports_by_year_data <-
      reactive({
        
        ncaa_sports_by_year |>
          
          # Filter to selections
          filter(
            Gender == input$ncaa_sports_by_year_gender,
            Sport == input$ncaa_sports_by_year_sport
          )
        
      })
    
    # Make the table
    output$ncaa_sports_by_year_table <- renderDataTable({current_ncaa_sports_by_year_data()})
    
    ## Power 4 Standings
    
    # Make dataset
    current_ncaa_power4_standings_data <-
      reactive({
        
        ncaa_power4_standings |>
          
          # Filter to selections
          filter(
            Gender == input$ncaa_sports_power4_standings_gender,
            Sport == input$ncaa_sports_power4_standings_sport,
            Conference == input$ncaa_sports_power4_standings_conference
          ) |>
          
          # Rearrange
          select(
            Place,
            Points,
            School,
            Total,
            Average,
            PerSport
          ) |>
          
          # Sort by ranking
          arrange(Place)
          
        
      })
    
    # Make the table
    output$ncaa_sports_power4_standings_table <- renderDataTable({current_ncaa_power4_standings_data()})
    
    ### Soccer
    
    ## ODP Interregionals
    
    # Make dataset
    current_odp_interregionals_data <-
      reactive({
        
        odp_interregionals |>
          
          # Filter to selections
          filter(
            State == input$soccer_odp_interregionals_state
          ) |>
          
          # Keep a couple variables
          select(
            Variable,
            Value
          )
        
      })
    
    # Make the table
    output$soccer_odp_interregionals_table <- renderDataTable({current_odp_interregionals_data()})
    
    ## World Cup Matches
    
    # Make dataset
    current_world_cup_data <-
      reactive({
        
        world_cup_matches |>
          
          # Filter to selections
          filter(
            Year == input$soccer_world_cup_year
          ) |>
          
          # Keep a couple variables
          select(
            -Year
          )
        
      })
    
    # Make the table
    output$soccer_world_cup_table <- renderDataTable({current_world_cup_data()})
    
  }