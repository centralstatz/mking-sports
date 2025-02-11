# Created: 2025-02-08
# Description: Builds the user interface

# Define the user interface
ui <- 
  navbarPage(
    theme = shinytheme("sandstone"),
    title = "Sports Dashboard",
    
    # About Tab
    tabPanel(
      title = "About",
      icon = icon("info-circle"),
      fluidPage(
        h3("About"),
        p("Welcome to Dr. King's Sports Dashboard. It features an introduction to different data on high school, college and professional sports.")
      )
    ),
    
    # Tab 1: High School Sports
    navbarMenu(
      title = "High School Sports",
      
      # HS Sports Participation
      tabPanel(
        title = "Participation",
        icon = icon("school"),
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              tabPanel(
                title = "Filters",
                selectInput(
                  inputId = "hs_sports_participation_gender", 
                  label = "Gender",
                  choices = unique(hs_sports_participation$Gender),
                  multiple = TRUE
                ),
                selectInput(
                  inputId = "hs_sports_participation_sport", 
                  label = "Sport",
                  choices = unique(hs_sports_participation$Sport),
                  multiple = TRUE
                ),
                selectInput(
                  inputId = "hs_sports_participation_measure", 
                  label = "Measure",
                  choices = unique(hs_sports_participation$Measure),
                  multiple = TRUE
                )
              ),
              tabPanel(
                title = "About",
                h3("Source"),
                h3("Description")
              )
            )
          ),
          mainPanel(
            leafletOutput("hs_sports_participation_map") |> withSpinner(color = "#007bff")
          )
        )
      )
    ),
    
    # Tab 2: NCAA Sports
    navbarMenu(
      title = "NCAA Sports",
      
      # NCAA Sports Participation
      tabPanel(
        title = "Participation",
        icon = icon("university"),
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              tabPanel(
                title = "Filters",
                selectInput(
                  inputId = "ncaa_sports_participation_gender", 
                  label = "Gender",
                  choices = unique(ncaa_participation$Gender),
                  multiple = TRUE
                )
              ),
              tabPanel(
                title = "About",
                h3("Source"),
                h3("Description")
              )
            )
          ),
          mainPanel(
            dataTableOutput("ncaa_sports_participation_table") |> withSpinner(color = "#007bff")
          )
        )
      ),
      
      # NCAA Sports by Year
      tabPanel(
        title = "By Year",
        icon = icon("calendar-days"),
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              tabPanel(
                title = "Filters",
                selectInput(
                  inputId = "ncaa_sports_by_year_sport",
                  label = "Sport",
                  choices = sort(unique(ncaa_sports_by_year$Sport))
                ),
                selectInput(
                  inputId = "ncaa_sports_by_year_gender", 
                  label = "Gender",
                  choices = unique(ncaa_sports_by_year$Gender)
                )
              ),
              tabPanel(
                title = "About",
                h3("Source"),
                h3("Description")
              )
            )
          ),
          mainPanel(
            dataTableOutput("ncaa_sports_by_year_table") |> withSpinner(color = "#007bff")
          )
        )
      ),
      
      # Power 4 Standings
      tabPanel(
        title = "Power 4 Standings",
        icon = icon("ranking-star"),
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              tabPanel(
                title = "Filters",
                selectInput(
                  inputId = "ncaa_sports_power4_standings_sport",
                  label = "Sport",
                  choices = sort(unique(ncaa_power4_standings$Sport))
                ),
                selectInput(
                  inputId = "ncaa_sports_power4_standings_conference",
                  label = "Conference",
                  choices = sort(unique(ncaa_power4_standings$Conference))
                ),
                selectInput(
                  inputId = "ncaa_sports_power4_standings_gender", 
                  label = "Gender",
                  choices = unique(ncaa_power4_standings$Gender)
                )
              ),
              tabPanel(
                title = "About",
                h3("Source"),
                h3("Description")
              )
            )
          ),
          mainPanel(
            dataTableOutput("ncaa_sports_power4_standings_table") |> withSpinner(color = "#007bff")
          )
        )
      ),
      
      # Power 4 Budgets
      tabPanel(
        title = "Power 4 Budgets",
        icon = icon("dollar-sign"),
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              tabPanel(
                title = "Filters",
                selectInput(
                  inputId = "ncaa_sports_power4_budgets_school", 
                  label = "School:",
                  choices = unique(ncaa_power4_budgets$School),
                  selected = NULL,
                  multiple = TRUE
                ),
                selectInput(
                  inputId = "ncaa_sports_power4_budgets_year", 
                  label = "Year:",
                  choices = c("All", unique(ncaa_power4_budgets$Year)),
                  selected = "All"
                ),
                selectInput(
                  inputId = "ncaa_sports_power4_budgets_conference", 
                  label = "FBS Conference:",
                  choices = c("All", unique(ncaa_power4_budgets$`FBS Conference`)),
                  selected = "All"
                ),
                selectInput(
                  inputId = "ncaa_sports_power4_budgets_metric", 
                  label = "Select Metric for Graph:",
                  choices = c("Total Expenses", "Total Revenues", "Total Football Spending"),
                  selected = "Total Expenses"
                ),
                actionButton(
                  inputId = "ncaa_sports_power4_budgets_search", 
                  label = "Search", 
                  class = "btn-primary"
                )
              ),
              tabPanel(
                title = "About",
                h3("Source"),
                h3("Description")
              )
            )
          ),
          mainPanel(
            tabsetPanel(
              tabPanel(
                title = "Data Table", 
                dataTableOutput("ncaa_sports_power4_budgets_table") |> withSpinner(color = "#007bff")
              ),
              tabPanel(
                title = "Trend Over Time",
                plotlyOutput("ncaa_sports_power4_budgets_trendPlot") |> withSpinner(color = "#007bff"),
                textOutput("ncaa_sports_power4_budgets_error_message") # Display error messages
              )
            )
          )
        )
      )
    ),
    
    # Tab 3: Soccer
    navbarMenu(
      title = "Soccer",
      
      # ODP Interregionals
      tabPanel(
        title = "ODP Interregionals",
        icon = icon("futbol"),
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              tabPanel(
                title = "Filters",
                selectInput(
                  inputId = "soccer_odp_interregionals_state",
                  label = "State",
                  choices = sort(unique(odp_interregionals$State))
                )
              ),
              tabPanel(
                title = "About",
                h3("Source"),
                h3("Description")
              )
            )
          ),
          mainPanel(
            dataTableOutput("soccer_odp_interregionals_table") |> withSpinner(color = "#007bff")
          )
        )
      ),
      
      # World Cup Matches
      tabPanel(
        title = "World Cup Matches",
        icon = icon("earth-americas"),
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              tabPanel(
                title = "Filters",
                selectInput(
                  inputId = "soccer_world_cup_year",
                  label = "Year",
                  choices = sort(unique(world_cup_matches$Year))
                )
              ),
              tabPanel(
                title = "About",
                h3("Source"),
                h3("Description")
              )
            )
          ),
          mainPanel(
            dataTableOutput("soccer_world_cup_table") |> withSpinner(color = "#007bff")
          )
        )
      )
    ),
    
    # Tab 4: Tennis
    navbarMenu(
      title = "Tennis",
      
      # Grand Slam Champions
      tabPanel(
        title = "Grand Slam Champions",
        icon = icon("table-tennis-paddle-ball"),
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              tabPanel(
                title = "Filters",
                selectInput(
                  inputId = "tennis_year", 
                  label = "Year:", 
                  choices = c("All", unique(Grand_Slam_Winners$Year)), 
                  selected = "All"
                ),
                selectInput(
                  inputId = "tennis_tournament", 
                  label = "Tournament:", 
                  choices = c("All", unique(Grand_Slam_Winners$Tournament)), 
                  selected = "All"
                ),
                selectInput(
                  inputId = "tennis_mens_winner", 
                  label = "Men's Winner:", 
                  choices = c("All", unique(Grand_Slam_Winners$Mens_Winner)), 
                  selected = "All"
                ),
                selectInput(
                  inputId = "tennis_womens_winner", 
                  label = "Women's Winner:", 
                  choices = c("All", unique(Grand_Slam_Winners$Womens_Winner)), 
                  selected = "All"
                ),
                actionButton(
                  inputId = "tennis_search",
                  label = "Search"
                )
              ),
              tabPanel(
                title = "About",
                h3("Source"),
                a("https://www.espn.com/tennis/history", href = "https://www.espn.com/tennis/history"),
                h3("Description")
              )
            )
          ),
          mainPanel(
            dataTableOutput("tennis_table") |> withSpinner(color = "#007bff")
          )
        )
      )
    ),
    
    # Footer
    tags$footer(
      style = "background-color: #343a40; color: #ffffff; text-align: center; padding: 10px; position: fixed; bottom: 0; width: 100%;",
      HTML("© 2025 Dr. King's Sports Dashboard | Built with Shiny")
    )
  )