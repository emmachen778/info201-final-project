library(shiny)
library(plotly)

source("analysis.R")

ui <- fluidPage(
  navbarPage("Zillow Housing Data",
             tabPanel("City Data",
                      sidebarLayout(
                        sidebarPanel(
                          textInput("city", label = "Please Enter Your Desired City (city, state abbreviation)", value = "Seattle, WA")
                        ),
                        mainPanel(
                          plotlyOutput("city.sale.plot"),
                          plotlyOutput("city.rental.plot")
                        )
                      )
             ),
             tabPanel("State Data",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("states", label = "Select Your Desired State(s)", choices = states$AREA, multiple = T, selected = "Alabama"),
                          sliderInput("range", label = "Select a Year Range", sep = "", min = min(merged.data$Year), max = max(merged.data$Year), 
                                      value = c(min(merged.data$Year), max(merged.data$Year)))
                        ),
                        mainPanel(
                          plotlyOutput("state.plot")                       
                          )
                      )
             )
  )
)
