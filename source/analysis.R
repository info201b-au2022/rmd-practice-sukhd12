# A brief analysis of the NYT COVID-19 data

# Load the tidyverse package
library(tidyverse)

# Load the *national level* data into a variable. `national`
national <- read.csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us.csv")

# This function returns total cases in the US
get_total_cases <- function() {
  total_cases <- national %>%
    filter(cases == max(cases)) %>%
    pull(cases)
  return(prettyNum(total_cases,big.mark=",",scientific=FALSE))
}

?prettyNum()

# This function returns the total number of cases in the US
get_total_deaths <- function() {
  total_deaths <- national %>%
    filter(deaths == max(deaths)) %>%
    pull(deaths)
  return(prettyNum(total_deaths,big.mark=",",scientific=FALSE))
}

# Run the following code to create a plot of cumulative cases over time
# (we'll explain the ggplot2 syntax next week)
cases_plot <- ggplot(data = national) +
  geom_line(mapping = aes(x = as.Date(date), y = cases)) +
  labs(x = "Date", y = "Cumulative Cases", title = "U.S. COVID Cases")

ballot_locations <- read.csv("/Users/sukhmandhillon/Library/CloudStorage/OneDrive-UW/Undergrad/2.Sophomore/Autumn 22/Info 201/Voting_Locations_and_Ballot_Boxes.R")
View(ballot_locations)

state <- map_data("state")
washington <- subset(state, region == "washington")
counties <- map_data("county")
washington_county <- subset(counties, region == "washington")

filtered_counties <- data.frame(
  county = ballot_locations$County, type = ballot_locations$Type, lat = ballot_locations$Lat, long = ballot_locations$Long
)
View(filtered_counties)

overall_map <- ggplot(washington) +
  geom_polygon(mapping = aes(x = long, y = lat, group = group)) + 
  geom_point(
    data = filtered_counties, 
    mapping = aes(x = long, y = lat, color = type),
    pch = 10
  )+
  scale_color_manual(values=c('Light Blue','Red'))+
  labs(title = "Voting Locations and Type") +
  coord_map() # use a map-based coordinate system
overall_map

complete_map <- overall_map +
  geom_polygon(data = washington_county, mapping = aes(x = long, y = lat, group=group), fill = NA, color = "white") +
  geom_polygon(fill = NA, mapping = aes(x = long, y = lat))
complete_map

complete_map <- complete_map + labs(x = "Longitude", y = "Latitude")

