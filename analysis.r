library(Quandl)
library(dplyr)
library(stringr)
library(reshape2)

source("keys.R")
Quandl.api_key(qndl.api)

cities <- read.table("http://static.quandl.com/zillow/areas_city.txt", sep = "|", stringsAsFactors = F)
colnames(cities) <- cities[1,]
cities <- cities[-1,]

states <- read.table("http://static.quandl.com/zillow/areas_state.txt", sep = "|", stringsAsFactors = F)
colnames(states) <- states[1,]
states <- states[-1,]

GetCityData <- function(city) {
  code <- cities %>% 
    filter(AREA == city) %>% 
    select(CODE)
  rent.query <- paste0("ZILLOW/C", code, "_MRPAH")
  sale.query <- paste0("ZILLOW/C", code, "_MSPAH")
  rent.prices <- Quandl(rent.query)
  rent.prices <- rent.prices %>% 
    mutate(Year = str_replace(Date, "-.*", "")) %>% 
    group_by(Year) %>% 
    summarize("MRP" = mean(Value))
  sale.prices <- Quandl(sale.query)
  sale.prices <- sale.prices %>% 
    mutate(Year = str_replace(Date, "-.*", "")) %>% 
    group_by(Year) %>% 
    summarize("MSP" = mean(Value))
  data <- inner_join(rent.prices, sale.prices, by = "Year")
  
  return(data)
}

states$full.code <- paste0("ZILLOW/S", states$CODE, "_MSPAH")
merged.data <- Quandl(states$full.code)
colnames(merged.data) <- c("Date", states$AREA)
merged.data$Year <- as.numeric(str_replace(merged.data$Date, "-.*", ""))




