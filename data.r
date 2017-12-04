# Loading in api keys
source("keys.R")

# Setting up the Quandl api with the api key
Quandl.api_key(qndl.api)

# Reading in all cities from a Quandl text file
cities <- read.table("http://static.quandl.com/zillow/areas_city.txt", sep = "|", stringsAsFactors = F)

# Setting the first row as column titles
colnames(cities) <- cities[1,]
cities <- cities[-1,]

# Extracting which state each city is in
cities$state <- str_extract(cities$AREA, "\\S*$")

# Filter cities down to only Washington cities
wa.cities <- cities[cities$state == "WA",]

# Extracting the city name
wa.cities$city <- str_replace(wa.cities$AREA, ",.*$", "")

# Creating full Quandl code for sale and rental data for each city
wa.cities$rent.code <- paste0("ZILLOW/C", wa.cities$CODE, "_MRPAH")
wa.cities$sale.code <- paste0("ZILLOW/C", wa.cities$CODE, "_MSPAH")

# Reading in all states from a Quandl text file
states <- read.table("http://static.quandl.com/zillow/areas_state.txt", sep = "|", stringsAsFactors = F)

# Setting first row as column titles
colnames(states) <- states[1,]
states <- states[-1,]

# Creating sale and rental codes for each state
states$sale.code <- paste0("ZILLOW/S", states$CODE, "_MSPAH")
states$rent.code <- paste0("ZILLOW/S", states$CODE, "_MRPAH")

# Returns rent data for an input city
GetCityRentData <- function(my.cities) {
  # Selecting input cities
  selected <- filter(wa.cities, city %in% my.cities)
  
  # Vector of rent codes for given cities
  rent.prices <- Quandl(selected$rent.code)
  
  # Setting column names to Date, then all selected cities
  colnames(rent.prices) <- c("Date", selected$city)
  return(rent.prices)
}

# Returns sale data for an input city
GetCitySaleData <- function(my.cities) {
  # Selecting input cities
  selected <- filter(wa.cities, city %in% my.cities)
  
  # Vector of rent codes for given cities
  sale.prices <- Quandl(selected$sale.code)
  
  # Column names to date and then selected cities
  colnames(sale.prices) <- c("Date", selected$city)
  return(sale.prices)
}

# Returns sale data for an input state
GetStateSaleData <- function(my.states) {
  # Selecting states based on input
  selected <- filter(states, AREA %in% my.states)
  
  # Vector of sale codes for given states
  data <- Quandl(selected$sale.code)
  
  # Setting column names to date then selected states
  colnames(data) <- c("Date", selected$AREA)
  
  # Column of year for each date for filtering in state data tab
  data$Year <- as.numeric(str_replace(data$Date, "-.*", ""))
  return(data)
}

# Returns rent data for an input state
GetStateRentData <- function(my.states) {
  # Selecting input states
  selected <- filter(states, AREA %in% my.states)
  
  # Vector of rent codes for input states
  data <- Quandl(selected$rent.code)
  
  # Setting column names to date, then all input cities
  colnames(data) <- c("Date", selected$AREA)
  
  # Column of year for each date for filtering in state data tab
  data$Year <- as.numeric(str_replace(data$Date, "-.*", ""))
  return(data)
}

# Returns percent change in an input vector of numeric type
PercentChange <- function(vector) {
  end <- vector[length(vector)]
  start <- vector[1]
  return((end - start) / start * 100)
}

# Predicting sale price for an input city
PredictCitySalePrice <- function(city) {
  # Getting the sale data for the city
  data <- GetCitySaleData(city) 
  
  # Formatting column names for use in prophet
  colnames(data) <- c("ds", "y")
  
  # Building the model
  model <- prophet(data)
  
  # Creating an empty data frame of the sale data for the city plus 5 years
  future <- make_future_dataframe(model, periods = 60, freq = "month")
  
  # Forecasting sale prices
  forecast <- predict(model, future) %>% 
    select(ds, yhat) 
  
  # Formatting date as a date to join to city sale data
  forecast$ds <- as.Date(forecast$ds)
  
  # Joining predicted prices to actual prices by date
  join.data <- left_join(forecast, data, by = "ds")
  
  # Formatting column names for graphing
  colnames(join.data) <- c("Date", "Predicted", "Actual")
  return(join.data)
}

PredictCityRentalPrice <- function(city) {
  # Getting rent data for a city
  data <- GetCityRentData(city) 
  
  # Formatting column names for use in prophet
  colnames(data) <- c("ds", "y")
  
  # Building the model
  model <- prophet(data)
  
  # Empty data frame of dates for city rental data plus 5 years
  future <- make_future_dataframe(model, periods = 60, freq = "month")
  
  # Predicting rental prices
  forecast <- predict(model, future) %>% 
    select(ds, yhat)
  
  # Formatting date as a date object to join to original rental prices data frame
  forecast$ds <- as.Date(forecast$ds)
  
  # Joining predicted and actual prices by date
  join.data <- left_join(forecast, data, by = "ds")
  
  # Formatting column names for use in graph
  colnames(join.data) <- c("Date", "Predicted", "Actual")
  return(join.data)
}


