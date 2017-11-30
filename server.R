library(shiny)
library(Quandl)
library(dplyr)
library(stringr)
library(plotly)
library(reshape2)
library(leaflet)
library(ggmap)

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
   
   return(leaflet() %>% 
            addTiles() %>% 
            addCircleMarkers(data = city.loc, radius = ~change / 10))
  })

}



    



