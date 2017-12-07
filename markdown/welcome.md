## Welcome!
Property values and rental prices factor heavily into a buyer's decisions. By comparing these values geographically, we aim to help buyers and renters make informed decisions.

### Target Audience
 While this report may be useful to numerous groups, we are focusing on **normal consumer (i.e. not a corporation) home buyers/renters in Washington state** as our target audience. We do not have access to the breadth of data that would bring in researchers and investors, but our visualizations clearly show pricing data for different states compared to Washington and cities in Washington. We also show predictions for rental and housing prices in different Washington cities; when combined with the above information, this will allow to consumers make an informed housing decision.

### Questions Answered
* How have median home sale and rental prices changed across different US states from 1996 to the present?
* How have sale and rental prices changed between different cities in Washington from 1996 to the present?
* How can we expect the median sales and rental prices for Washington cities to change over the next five years?

### Design Process & Challenges
First, we chose a relevant topic that all of us were interested in: the United States housing market. The Quandl API had all of the data we needed to create meaningful and impactful visualizations that would help our target audience make informed buying and renting decisions.

From here, we divided the work. Three of us worked on wrangling the data, creating the visualizations, and implementing machine learning. One of us worked on the home page and project write-up, and one of us worked on formatting and styling the application.

As anticipated, the biggest challenge was efficiently obtaining and manipulating the data used in the visualizations. A lot of the county data was missing, so we could not slice the data by county as we had originally intended. Furthermore, some states and Washington cities return error messages for sales and/or rental codes given in the Quandl API. We wanted to exclude these locations from the dropdown menus, but any automatic implementation ended up taking a very long time. Also, our wrangling functions originally read through the entire dataset to find specific information, so the plots took a long time to render. We optimized the functions to filter through only the data requested by the user's input, which delivered results faster and more efficiently.
