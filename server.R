library(shiny)
library(Quandl)
library(httr)
library(jsonlite)
library(dplyr)
library(stringr)
library(plotly)
library(reshape2)

source("analysis.R")

server <- function(input, output) {
  output$state.plot <- renderPlotly({
    state.data <- merged.data %>% 
      filter(Year >= min(input$range), Year <= max(input$range)) %>% 
      select(input$states) %>% 
      melt() 
    state.data$date <- filter(merged.data, Year >= min(input$range), Year <= max(input$range))$Date
    p <- plot_ly(data = state.data, type = "scatter", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Mean Home Sale Price ($)"),
             title = paste("Mean Home Sale Price", input$range))
    return(p)
  })
}