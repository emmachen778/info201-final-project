# Library to use shiny
library(shiny)

# Library to load Quandl data - data.r
library(Quandl)

# Libraries for graphing - leaflet for maps, plotly for everything else
library(plotly)
library(leaflet)

# Library to manipulate strings in data.r file
library(stringr)

# Themes & loaders to make shiny prettier
library(shinythemes)
library(shinycssloaders)

# Library to use insert markdown documents into ui
library(markdown)

# Loading in data for use in inputs
source("data.r")

# Selecting the Flatly shiny theme
ui <- fluidPage(theme = shinytheme('flatly'),
  # Intro page with banner, welcome, and background information on the project and interesting libraries used              
  navbarPage("Zillow Housing Data",
             tabPanel("Home",
                      # Our header image - in www folder as standard
                      fluidRow(
                        column(width = 12, img(src="banner.png", style = "display: block; margin-left: auto; margin-right: auto; width: 100%;"))
                      ),
                      # Text elements, linked to markdown files in markdown folder
                      fluidRow(
                        column(width = 3, offset = 1, includeMarkdown("./markdown/quandl.md")),
                        column(7, includeMarkdown("./markdown/welcome.md"))
                      )
             ),
             # Tab to compare median sales and rental prices by state
             tabPanel("State Data",
                      # Sidebar for widgets - input
                      sidebarLayout(
                        sidebarPanel(
                          # Dropdown menu to select one or multiple states
                          selectInput("states", label = "Select Your Desired State(s)", choices = states$AREA, multiple = T, selected = "Washington"),
                          # Slider menu to select range of years
                          sliderInput("range", label = "Select a Year Range", sep = "", min = 1996, max = as.integer(format(Sys.Date(), "%Y")) - 1, 
                                      value = c(1996, as.integer(format(Sys.Date(), "%Y")) - 1)),
                          tags$p("These graphs display the median sale and rental prices of the selected states within
                                 the selected years. We chose to use line graphs to clearly show pricing trends.")
                        ),
                        
                        # Main panel for output graphs
                        mainPanel(
                          # Putting each graph into a separate tab
                          tabsetPanel(
                            # Median sale price for selected states over input years
                            tabPanel("Sales", plotlyOutput("state.plot") %>% withSpinner(),
                                     tags$br(),
                                     tags$p('**Not all states have median sale data available.')), 
                            # Median rental price for selected states over input years
                            tabPanel("Rentals", plotlyOutput("state.rent.plot") %>% withSpinner(),
                                     tags$br(),
                                     tags$p('**Median rental data begins at in various years for each state, with the earliest starting in 2010'))
                          )
                        )
                      )
             ),
             # Tab to compare median sales and rental price by Washington city along with percent change median sales prices for those cities
             tabPanel("City Data",
                      # Sidebar for widgets - input
                      sidebarLayout(
                        sidebarPanel(
                          # Dropdown menu to select one or multiple Washington cities
                          selectInput("cities", label = "Select Your Desired City/Cities", choices = wa.cities$city, multiple = T, selected = c("Seattle", "Bellevue")),
                          tags$p("The map shows the location of selected cities with a circle sized by percent change in median sale price for that city.
                                 We chose to visualize the cities this way to show location in relation to other Washington cities and a summary of 
                                 price trends for the individual cities. The two graphs show the median sale and rental values for each city over time. Again, we used a line 
                                 graph to clearly demonstrate pricing trends.")
                        ),
                        
                        # Main panel for output graphs
                        mainPanel(
                          # Putting each graph into a separate tab
                          tabsetPanel(
                            # Map of percent change in median sale price for input cities over all years of data
                            tabPanel(
                              "Map", tags$h3("Change in Median Sale Prices"), leafletOutput("map") %>% withSpinner()
                            ),
                            # Median sales price for input cities over all years of data
                            tabPanel("Sales", plotlyOutput("city.sale.plot")%>% withSpinner()),
                            # Median rental price for input cities over all years of data
                            tabPanel("Rentals", plotlyOutput("city.rental.plot") %>% withSpinner())
                          )
                        )
                      )
             ),
             # Tab to predict sales and rental prices for a singular Washington city
             tabPanel("Predicted City Prices",
               # Sidebar for input widgets       
               sidebarLayout(
                 sidebarPanel(
                   # Select one Washington city - dropdown menu
                   selectInput("city", label = "Select Your Desired City", choices = wa.cities$city, multiple = F, selected = "Seattle"),
                   tags$p("These two graphs show predicted vs. actual values for a singular input Washington city. The predicted values
                          encompass the data we already have plus another five years to try and predict future pricing trends.
                          We used line graphs to clearly represent the nature of these pricing trends.")
                 ), 
                 
                 # Main panel for output visuals
                 mainPanel(
                   # Separating each graph into an individual tab
                   tabsetPanel(
                      # Output graph of predicted median sales price for input city
                      tabPanel("Sales", plotlyOutput("predict.sale") %>% withSpinner()),
                      # Output graph of predicted median rental price for input city
                      tabPanel("Rentals", plotlyOutput("predict.rent") %>% withSpinner())
                   )
                 )
               )
             ), 
             # Conclusion tab - interesting trends/outliers
             tabPanel("Conclusion",
                      # Text of conclusion - in markdown folder
                      fluidRow(
                        column(width = 5, offset = 1, includeMarkdown("./markdown/conclusion-trends.md")),
                        column(5, includeMarkdown("./markdown/conclusion-outliers.md"))
                      )
             ),
             br(),
             hr(),
             p("INFO 201 | Fall 2017 | James McCutcheon, Laura Freeman, William Baxter, Emma Chen, Emily Tao", align = "center"),
             p("Link to ", a("GitHub", href = "https://github.com/emmachen778/info201-final-project"), "Repository", align = "center")
             
  )
)
