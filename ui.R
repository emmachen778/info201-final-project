# Library to use shiny
library(shiny)

# Libraries for graphing - leaflet for maps, plotly for everything else
library(plotly)
library(leaflet)

# Themes to make shiny prettier
library(shinythemes)

# Library to use insert markdown documents into ui
library(markdown)

# Loading in data for use in inputs
source("data.R")

ui <- fluidPage(theme = shinytheme('flatly'),
  navbarPage("Zillow Housing Data",
             tabPanel("Home",
                      fluidRow(
                        column(width = 12, img(src="banner.png", style = "display: block; margin-left: auto; margin-right: auto; width: 100%;"))
                      ),
                      fluidRow(
                        column(width = 3, offset = 1, includeMarkdown("quandl.md")),
                        column(7, includeMarkdown("welcome.md"))
                      )
             ),
             
             tabPanel("State Data",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("states", label = "Select Your Desired State(s)", choices = states$AREA, multiple = T, selected = "Washington"),
                          sliderInput("range", label = "Select a Year Range", sep = "", min = 1996, max = as.integer(format(Sys.Date(), "%Y")) - 1, 
                                      value = c(1996, as.integer(format(Sys.Date(), "%Y")) - 1))
                        ),
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Sales", plotlyOutput("state.plot"),
                                     tags$br(),
                                     tags$p('**Not all states have median sale data available.')), 
                            tabPanel("Rentals", plotlyOutput("state.rent.plot"),
                                     tags$br(),
                                     tags$p('**Median rental data begins at various times for each state, starting at 2010'))
                          )
                        )
                      )
             ),
             
             tabPanel("City Data",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("cities", label = "Select Your Desired City/Cities", choices = wa.cities$city, multiple = T, selected = "Seattle")
                        ),
                        mainPanel(
                          tabsetPanel(
                            tabPanel(
                              "Map", tags$h3("Change in Median Sale Prices"), leafletOutput("map"),
                              tags$div(tags$br(),
                                       tags$p("This map shows the location of the selected city/cities, indicated by a circle. 
                                              The circle sizes are scaled relative to the percent change in median sale prices over time.")
                                       
                              )
                              ),
                            tabPanel("Sales", plotlyOutput("city.sale.plot")),
                            tabPanel("Rentals", plotlyOutput("city.rental.plot"))
                          )
                        )
                      )
             ),
             
             tabPanel("Predicted City Prices",
               sidebarLayout(
                 sidebarPanel(
                   selectInput("city", label = "Select Your Desired City", choices = wa.cities$city, multiple = F, selected = "Seattle")
                 ), 
                 mainPanel(
                   tabsetPanel(
                      tabPanel("Sales", plotlyOutput("predict.sale")),
                      tabPanel("Rentals", plotlyOutput("predict.rent"))
                   )
                 )
               )
             )
  )
)
