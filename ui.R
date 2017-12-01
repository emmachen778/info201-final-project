library(shiny)
library(plotly)
library(leaflet)
library(shinythemes)

source("data.R")

ui <- fluidPage(theme = shinytheme('flatly'),
  navbarPage("Zillow Housing Data",
             tabPanel("Home",
                      splitLayout(cellWidths = c("35%", "65%"),
                                  includeMarkdown("quandl.md"),
                                  includeMarkdown("welcome.md")
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
                            tabPanel("Sales", plotlyOutput("state.plot")), 
                            tabPanel("Rentals", plotlyOutput("state.rent.plot"))
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
                                       tags$p("This map shows the change in median sale prices from over time for the selected cities. 
                                              The circle sizes are scaled relative to the percent change in median sale prices over time.")
                                       
                              )
                              ),
                            tabPanel("Sales", tags$h3("Median Sale Prices"), plotlyOutput("city.sale.plot")),
                            tabPanel("Rentals", tags$h3("Median Rental Prices"), plotlyOutput("city.rental.plot"))
                          )
                        )
                      )
             )
  )
)
