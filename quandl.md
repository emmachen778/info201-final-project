## API & Libraries
This application uses the [Quandl API](https://www.quandl.com/data/ZILLOW-Zillow-Real-Estate-Research), which obtains housing data from Zillow real estate research. The dataset includes a wide variety of data, such as rental prices, sale prices, and housing supply; which can be filtered by state, zip code, city, and more.

We introduced several new R libraries to help format the application and wrangle the data:
* **Quandl** - to access and utilize the API
* **prophet** - to implement machine learning using an automatic forecasting procedure
* **reshape2** - to flexibly restructure and aggregate the data
* **leaflet** - to facilitate the implementation of the map visualization
* **ggmap** - to create the map used in one of the visualizations
* **shinythemes** - to use built-in shiny app themes
* **prophet** - to predict seasonal pricing data. Learn more [here](https://facebook.github.io/prophet/)
