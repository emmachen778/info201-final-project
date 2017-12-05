## Welcome!
Property values and rental prices factor heavily into a buyer's decisions. By comparing these values geographically, we aim to help buyers and renters make informed decisions.

### Target Audience
 While this report may be useful to numerous groups, we are focusing on **normal consumer (i.e. not a corporation) home buyers/renters in Washington state** as our target audience. We do not have access to the breadth of data that would bring in researchers and investors, but our visualizations clearly show pricing data for different states compared to Washington and cities in Washington. We also show predictions for rental and housing prices in different Washington cities, which when combined with the above information will allow consumers make an informed housing decision.

### Questions Answered
* How have median home sale prices changed across different US states from 1996 to the present?
* How have sale and rental prices changed between different cities in Washington from 1996 to the present?
* How can we expect the median sales and rental prices for Washington cities to change over the next few years?

### Design Process & Challenges
First, we chose a relevant topic that all of us were interested in: the United States housing market. The Quandl API had all of the data we needed to create meaningful and impactful visualizations that would help our target audience make informed buying and renting decisions.

From here, we divided the work. Three of us worked on wrangling the data, creating the visualizations, and implementing machine learning. One of us worked on the home page and project write-up, and one of us worked on formatting and styling the application.

As anticipated, the biggest challenge was efficiently manipulating the data for use in the visualizations. A lot of the county data was missing, so we could not slice the data by county. Also, our wrangling functions originally read through the entire dataset to find specific information, so the plots took a long time to render. We optimized the functions to filter through the data faster and more efficiently.
