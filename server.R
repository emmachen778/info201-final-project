library(shiny)
library(Quandl)
library(httr)
library(jsonlite)
library(dplyr)
library(stringr)
library(plotly)
library(reshape2)

source("data.R")

server <- function(input, output) {
  output$state.plot <- renderPlotly({
    state.data <- GetStateData(input$states) 
    melt.data <- state.data %>% 
      select(input$states) %>% 
      melt() 
    melt.data$date <- state.data$Date
    melt.data$year <- state.data$Year
    melt.data <- filter(melt.data, year >= min(input$range), year <= max(input$range))
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Home Sale Price ($)"),
             title = paste("Median Home Sale Price", min(input$range), "-", max(input$range)))
    return(p)
  })
  
  output$city.sale.plot <- renderPlotly({
    sale.data <- GetCitySaleData(input$cities)
    melt.data <- sale.data %>% 
      select(input$cities) %>% 
      melt() 
    melt.data$date <- sale.data$Date
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Year"), yaxis = list(title = "Median Sale Price ($)"),
             title = "Median Sale Price Over Time")
    return(p)
  })
  
  output$city.rental.plot <- renderPlotly({
    rent.data <- GetCityRentData(input$cities)
    melt.data <- rent.data %>% 
      select(input$cities) %>% 
      melt() 
    melt.data$date <- rent.data$Date
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Year"), yaxis = list(title = "Median Rental Price ($)"),
             title = "Median Rental Price Over Time")
    return(p)
  })

}



