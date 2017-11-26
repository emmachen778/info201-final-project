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
    p <- plot_ly(data = state.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Mean Home Sale Price ($)"),
             title = paste("Mean Home Sale Price", min(input$range), "-", max(input$range)))
    return(p)
  })
  
  output$city.sale.plot <- renderPlotly({
    city.data <- GetCityData(input$city)
    p <- plot_ly(data = city.data, type = "scatter", mode = "lines", x = ~Year, y = ~MSP) %>% 
      layout(xaxis = list(title = "Year"), yaxis = list(title = "Mean Sale Price ($)"),
             title = paste("Mean Sale Price in", input$city))
  })
  
  output$city.rental.plot <- renderPlotly({
    city.data <- GetCityData(input$city)
    p <- plot_ly(data = city.data, type = "scatter", mode = "lines", x = ~Year, y = ~MRP) %>% 
      layout(xaxis = list(title = "Year"), yaxis = list(title = "Mean Rental Price ($)"),
             title = paste("Mean Rental Price in", input$city))
  })

}

