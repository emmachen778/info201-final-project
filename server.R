# Shiny library
library(shiny)

# Quandl library - gets Zillow data
library(Quandl)

# Libraries for data manipulation
library(dplyr)
library(reshape2)

# Library to deal with character data
library(stringr)

# Graphing libraries - leaflet is maps, plotly is everything else
library(plotly)
library(leaflet)

# Library to get latitude and longitude data for map
library(ggmap)

# Prediction library - good for seasonal data
library(prophet)

# Loading in data and functions
source("data.R")

server <- function(input, output) {
  
  # Line plot to compare state sale data
  output$state.plot <- renderPlotly({
    # Getting state sale data
    state.data <- GetStateSaleData(input$states) 
    
    # Melting the state data down to one column with a state identifier - so can be graphed
    melt.data <- state.data %>% 
      select(input$states) %>% 
      melt() 
    
    # Adding back the date and year columns
    melt.data$date <- state.data$Date
    melt.data$year <- state.data$Year
    
    # Filtering the data to only desired years
    melt.data <- filter(melt.data, year >= min(input$range), year <= max(input$range))
    
    # Line graph of median home sale price by date, colored by state
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Home Sale Price ($)"),
             title = paste("Median Home Sale Price", min(input$range), "-", max(input$range)), margin = list(t=120))
    return(p) 
  })
  
  # Genrates plot based on rental prices for given state(s)
  output$state.rent.plot <- renderPlotly({
    # Getting state rental data
    state.data <- GetStateRentData(input$states) 
    
    # Melting state data to one column with state identifier to be graphed
    melt.data <- state.data %>% 
      select(input$states) %>% 
      melt() 
    
    # Adding back year and date columns
    melt.data$date <- state.data$Date
    melt.data$year <- state.data$Year
    
    # Filtering data to only desired years
    melt.data <- filter(melt.data, year >= min(input$range), year <= max(input$range))
    
    # Line graph of median rental price by price, colored by state
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Home Sale Price ($)"),
             title = paste("Median Home Rental Price", min(input$range), "-", max(input$range)), margin = list(t=120))
    return(p) 
  })
  
  # Genrates plot based on sale prices for given city(cities)
  output$city.sale.plot <- renderPlotly({
    # Getting sale data for input cities
    sale.data <- GetCitySaleData(input$cities)
    
    # Melting city sale data to one column to be graphed
    melt.data <- sale.data %>% 
      select(input$cities) %>% 
      melt() 
    
    # Adding back date column
    melt.data$date <- sale.data$Date
    
    # Line plot of median sale price to date, colored by city
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Sale Price ($)"),
             title = "Median Sale Price Over Time", margin = list(t = 120))
    return(p)
  })
  
  # Genrates plot based on rental prices for given city(cities)
  output$city.rental.plot <- renderPlotly({
    # Getting rental data for selected cities
    rent.data <- GetCityRentData(input$cities)
    
    # Melting city rental data to one column with city identifier - for graph
    melt.data <- rent.data %>% 
      select(input$cities) %>% 
      melt() 
    
    # Adding back date column
    melt.data$date <- rent.data$Date
    
    # Line plot of median rental price by date, colored by city
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Rental Price ($)"),
             title = "Median Rental Price Over Time", margin = list(t=120))
    return(p)
  })
  
  # Generates the an interative map plot of the change in median sale prices for the given city
  output$map <- renderLeaflet({
    # Data frame with column for selected cities
    city.loc <- data.frame(cities = input$cities)
    
    # Getting latitude and longitude for each input city
    loc <- geocode(as.character(city.loc$cities))
    
    # Adding latitude and longitude columns to each city
    city.loc$lon <- loc$lon
    city.loc$lat <- loc$lat
    
    # Summary table of percent change for median sale price in each city
    percent.change <- GetCitySaleData(input$cities) %>% 
      select(input$cities) %>% 
      melt() %>% 
      group_by(variable) %>% 
      summarize(change = PercentChange(value))
    
    # Adding calculated percent changes to city location table
    city.loc$change <- percent.change$change
    
    # Label for each percent change
    city.loc$label <- paste0(city.loc$cities, ' - Percent Change: ', round(city.loc$change, 4), '%')
    
    # Returning a map of the location of each city (circles), the circles are sized by percent change in median sale price
    return(leaflet() %>% 
             addTiles() %>% 
             addCircleMarkers(data = city.loc, radius = ~change / 10, label = ~label))
  })
  
  # Predicts and plots the predicted median sale price for the given city
  output$predict.sale <- renderPlotly({
    # Getting predicted sale prices for a city
    predict.data <- PredictCitySalePrice(input$city)
    
    # Price data into one column with city identifiers to graph
    melt.data <- predict.data %>% 
      select(Predicted, Actual) %>% 
      melt()
    
    # Adding back date column
    melt.data$date <- predict.data$Date
    
    # Line plot of median sale price to date, colored by whether is actual data or predicted
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Sale Price ($)"),
             title = "Median Sale Price for Current Data and Next 5 Years", margin = list(t=120))
  })
  # Predicts and plots the predicted median rental price for the given city
  output$predict.rent <- renderPlotly({
    # Getting predicted rental prices for a city
    predict.data <- PredictCityRentalPrice(input$city)
    
    # Melting pricing data to one column to be graphed
    melt.data <- predict.data %>% 
      select(Predicted, Actual) %>% 
      melt()
    
    # Adding date column back into melted data
    melt.data$date <- predict.data$Date
    
    # Line plot of median rental price to date, colored by identity as predicted or actual
    p <- plot_ly(data = melt.data, type = "scatter", mode = "lines", x = ~date, y = ~value, color = ~variable) %>% 
      layout(xaxis = list(title = "Date"), yaxis = list(title = "Median Rental Price ($)"),
             title = "Median Rental Price for Current Data and Next 5 Years", margin = list(t=120))
  })
}
