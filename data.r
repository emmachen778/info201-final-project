source("keys.R")

Quandl.api_key(qndl.api)

cities <- read.table("http://static.quandl.com/zillow/areas_city.txt", sep = "|", stringsAsFactors = F)
colnames(cities) <- cities[1,]
cities <- cities[-1,]
cities$state <- str_extract(cities$AREA, "\\S*$")
wa.cities <- cities[cities$state == "WA",]
wa.cities$city <- str_replace(wa.cities$AREA, ",.*$", "")
wa.cities$rent.code <- paste0("ZILLOW/C", wa.cities$CODE, "_MRPAH")
wa.cities$sale.code <- paste0("ZILLOW/C", wa.cities$CODE, "_MSPAH")

states <- read.table("http://static.quandl.com/zillow/areas_state.txt", sep = "|", stringsAsFactors = F)
colnames(states) <- states[1,]
states <- states[-1,]
states$sale.code <- paste0("ZILLOW/S", states$CODE, "_MSPAH")
states$rent.code <- paste0("ZILLOW/S", states$CODE, "_MRPAH")

GetCityRentData <- function(my.cities) {
  selected <- filter(wa.cities, city %in% my.cities)
  rent.prices <- Quandl(selected$rent.code)
  colnames(rent.prices) <- c("Date", selected$city)
  return(rent.prices)
}

GetCitySaleData <- function(my.cities) {
  selected <- filter(wa.cities, city %in% my.cities)
  sale.prices <- Quandl(selected$sale.code)
  colnames(sale.prices) <- c("Date", selected$city)
  return(sale.prices)
}

GetStateSaleData <- function(my.states) {
  selected <- filter(states, AREA %in% my.states)
  data <- Quandl(selected$sale.code)
  colnames(data) <- c("Date", selected$AREA)
  data$Year <- as.numeric(str_replace(data$Date, "-.*", ""))
  return(data)
}

GetStateRentData <- function(my.states) {
  selected <- filter(states, AREA %in% my.states)
  data <- Quandl(selected$rent.code)
  colnames(data) <- c("Date", selected$AREA)
  data$Year <- as.numeric(str_replace(data$Date, "-.*", ""))
  return(data)
}

PercentChange <- function(vector) {
  end <- vector[length(vector)]
  start <- vector[1]
  return((end - start) / start * 100)
}

PredictCitySalePrice <- function(city) {
  data <- GetCitySaleData(city) 
  colnames(data) <- c("ds", "y")
  model <- prophet(data)
  future <- make_future_dataframe(model, periods = 60, freq = "month")
  forecast <- predict(model, future) %>% 
    select(ds, yhat)
  forecast$ds <- as.Date(forecast$ds)
  join.data <- left_join(forecast, data, by = "ds")
  colnames(join.data) <- c("Date", "Predicted", "Actual")
  return(join.data)
}

PredictCityRentalPrice <- function(city) {
  data <- GetCityRentData(city) 
  colnames(data) <- c("ds", "y")
  model <- prophet(data)
  future <- make_future_dataframe(model, periods = 60, freq = "month")
  forecast <- predict(model, future) %>% 
    select(ds, yhat)
  forecast$ds <- as.Date(forecast$ds)
  join.data <- left_join(forecast, data, by = "ds")
  colnames(join.data) <- c("Date", "Predicted", "Actual")
  return(join.data)
}


