## API & Libraries
This application uses the [Quandl API](https://www.quandl.com/data/ZILLOW-Zillow-Real-Estate-Research), which obtains financial data for various industries and locations. We chose to use the **Zillow** portion of the API to look at housing prices in the _United States_. The API allows access to a wide variety of housing data (rental prices, sale prices, and housing supply), all of which can be filtered by a subset of location (state, zip code, city, neighborhood, etc.)

We introduced several new R libraries to help format the application and wrangle the data:
* **Quandl** - to access and utilize Zillow data
* **prophet** - to implement machine learning using an automatic forecasting procedure - great for seasonal data. Learn more [here](https://facebook.github.io/prophet/)
* **reshape2** - to flexibly restructure and aggregate the data
* **leaflet** - to facilitate the implementation of the map visualization
* **ggmap** - to obtain latitude and longitude data for cities
* **shinythemes** - to use built-in shiny app themes
