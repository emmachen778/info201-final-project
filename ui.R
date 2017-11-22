library(shiny)
library(plotly)

source("analysis.R")

ui <- fluidPage(
  sidebarPanel(
    selectInput("states", label = "Select Your Desired State(s)", choices = states$AREA, multiple = T, selected = "Alabama"),
    sliderInput("range", label = "Select a Year Range", sep = "", min = min(merged.data$Year), max = max(merged.data$Year), 
                value = c(min(merged.data$Year), max(merged.data$Year)))
  ),
  mainPanel(
    plotlyOutput("state.plot")
  )
)
