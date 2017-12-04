library(shiny)
library(Quandl)
library(dplyr)
library(stringr)
library(plotly)
library(reshape2)
library(leaflet)
library(ggmap)
library(prophet)

source("data.R")

server <- function(input, output) {
  output$state.plot <- renderPlotly({
    state.data <- GetStateSaleData(input$states) 
    melt.data <- state.data %>% 
      select(input$states) %>% 
      melt() 
    melt.data$date <- state.data$Date
    melt.data$year <- state.data$Year
    melt.data <- filter(melt.data, year >= min(input$range), year <= max(input$range))
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Home Sale Price ($)"),
             title = paste("Median Home Sale Price", min(input$range), "-", max(input$range)), margin = list(t=120))
    return(p) 
  })
  
  # Genrates plot based on rental prices for given state(s)
  output$state.rent.plot <- renderPlotly({
    state.data <- GetStateRentData(input$states) 
    melt.data <- state.data %>% 
      select(input$states) %>% 
      melt() 
    melt.data$date <- state.data$Date
    melt.data$year <- state.data$Year
    melt.data <- filter(melt.data, year >= min(input$range), year <= max(input$range))
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Home Sale Price ($)"),
             title = paste("Median Home Rental Price", min(input$range), "-", max(input$range)), margin = list(t=120))
    return(p) 
  })
  
  # Genrates plot based on sale prices for given city(cities)
  output$city.sale.plot <- renderPlotly({
    sale.data <- GetCitySaleData(input$cities)
    melt.data <- sale.data %>% 
      select(input$cities) %>% 
      melt() 
    melt.data$date <- sale.data$Date
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Sale Price ($)"),
             title = "Median Sale Price Over Time", margin = list(t = 120))
    return(p)
  })
  
  # Genrates plot based on rental prices for given city(cities)
  output$city.rental.plot <- renderPlotly({
    rent.data <- GetCityRentData(input$cities)
    melt.data <- rent.data %>% 
      select(input$cities) %>% 
      melt() 
    melt.data$date <- rent.data$Date
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Rental Price ($)"),
             title = "Median Rental Price Over Time", margin = list(t=120))
    return(p)
  })
  
  # Generates the an interative map plot plot of the change in t median sale prices for the given city
  output$map <- renderLeaflet({
    city.loc <- data.frame(cities = input$cities)
    loc <- geocode(as.character(city.loc$cities))
    city.loc$lon <- loc$lon
    city.loc$lat <- loc$lat
    
    percent.change <- GetCitySaleData(input$cities) %>% 
      select(input$cities) %>% 
      melt() %>% 
      group_by(variable) %>% 
      summarize(change = PercentChange(value))
    city.loc$change <- percent.change$change
    city.loc$label <- paste0(city.loc$cities, ' - Percent Change: ', round(city.loc$change, 4), '%')
    
    return(leaflet() %>% 
             addTiles() %>% 
             addCircleMarkers(data = city.loc, radius = ~change / 10, label = ~label))
  })
  
  # Predicts and plots the predicted median sale price for the given city
  output$predict.sale <- renderPlotly({
    predict.data <- PredictCitySalePrice(input$city)
    melt.data <- predict.data %>% 
      select(Predicted, Actual) %>% 
      melt()
    melt.data$date <- predict.data$Date
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Sale Price ($)"),
             title = "Median Sale Price for Current Data and Next 5 Years", margin = list(t=120))
  })
  # Predicts and plots the predicted median rental price for the given city
  output$predict.rent <- renderPlotly({
    predict.data <- PredictCityRentalPrice(input$city)
    melt.data <- predict.data %>% 
      select(Predicted, Actual) %>% 
      melt()
    melt.data$date <- predict.data$Date
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Rental Price ($)"),
             title = "Median Rental Price for Current Data and Next 5 Years", margin = list(t=120))
  })
}
