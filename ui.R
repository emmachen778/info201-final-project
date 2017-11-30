library(shiny)
library(plotly)

source("data.R")

ui <- fluidPage(
  navbarPage("Zillow Housing Data",
             
             tabPanel("State Data",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("states", label = "Select Your Desired State(s)", choices = states$AREA, multiple = T, selected = "Washington"),
                          sliderInput("range", label = "Select a Year Range", sep = "", min = 1996, max = as.integer(format(Sys.Date(), "%Y")) - 1, 
                                      value = c(1996, as.integer(format(Sys.Date(), "%Y")) - 1))
                        ),
                        mainPanel(
                          plotlyOutput("state.plot")                       
                          )
                      )
             ),
             tabPanel("City Data",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("cities", label = "Select Your Desired City/Cities", choices = wa.cities$city, multiple = T, selected = "Seattle")
                        ),
                        mainPanel(
                          plotlyOutput("city.sale.plot"),
                          plotlyOutput("city.rental.plot")
                        )
                      )
             )
  )
)
