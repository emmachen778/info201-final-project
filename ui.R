library(shiny)
library(plotly)
library(leaflet)
library(shinythemes)

source("data.R")

ui <- fluidPage(theme = shinytheme("flatly"),
  navbarPage("Zillow Housing Data",
             
             tabPanel("Home",
                      fluidRow(
                        column(width = 3, offset = 1, includeMarkdown("quandl.md")),
                        column(7, includeMarkdown("welcome.md"))
                      )
             ),
             tabPanel("City Data",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("cities", label = "Select Your Desired City/Cities", choices = wa.cities$city, multiple = T, selected = "Seattle")
                        ),
                        mainPanel(
                          leafletOutput("map"),
                          plotlyOutput("city.sale.plot"),
                          plotlyOutput("city.rental.plot")
                        )
                      )
             )
  )
)
