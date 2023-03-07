# Eunice Amissah-Mensah



install.packages("plotly")
library(leaflet)
library(tidycensus)
library(tidyverse)
library(readxl)


# Set value for the minZoom and maxZoom settings.
leaflet(options = leafletOptions(minZoom = 0, maxZoom = 2))


map <- leaflet() %>%
  addTiles() %>%  
  addMarkers(lng=-1.2336183252233641, lat=5.121563339673754, popup="Eunice's High School")
map  

# Set the center
map %>% setView(lng= -1.2336183252233641, lat=5.121563339673754, zoom = 15)