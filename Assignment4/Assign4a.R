# Eunice Amissah-Mensah
# 
# Assignment 4_A
# Leaflet mapping: adding multiple markers to slippy map

install.packages("leaflet", "leaflet.providers", "tidyverse")
library(leaflet)
library(leaflet.providers)
library(tidyverse)


CarRally100 <- read.csv("CarRally100.csv", header = TRUE)
CarRally1000 <- read.csv("CarRally1000.csv", header = TRUE)
CarData <- CarRally100

# Add markers from the CSV to this map
map <- leaflet(CarData) %>% 
  addTiles() %>%
  addMarkers(~longitude, ~latitude)
map


map <- leaflet(CarData) %>% 
  addTiles() %>%
  addCircles(~longitude, ~latitude, label = CarData$car_make)
map

# Popup of the people's car model year

map <- leaflet(CarData) %>% 
  addTiles() %>%
  addCircles(~longitude, ~latitude, popup = paste("<strong>", 
                                                  CarData$first_name, "</strong><br>", "Car Model Year: ", 
                                                  CarData$car_year))
map

# Change the size and color of the circles

map <- leaflet(CarData) %>% 
  addTiles() %>%
  addCircles(~longitude, ~latitude, popup= paste("<strong>", 
                                                 CarData$first_name, "</strong><br>", "Car Model Year: ", 
                                                 CarData$car_year), weight = 8, radius=1000, 
             color="purple", stroke = TRUE, fillOpacity = 1.0)
map

?addCircles

# Base map options

names(providers)

# Button containing a group of background layers
map <- leaflet(CarData) %>% 
  addTiles(group = "OSM", options = providerTileOptions(minZoom = 4, maxZoom = 10)) %>%
  addProviderTiles("Stamen.Terrain", group = "Terrain", 
                   options = providerTileOptions(minZoom = 8, maxZoom = 10)) %>%
  addProviderTiles("Stamen.Watercolor", group = "Water Color") %>%
  addProviderTiles("Esri.WorldStreetMap", group = "Street") %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = "Mapnik") %>%
  addProviderTiles("Thunderforest.Landscape", group = "Landscape") %>%
  addLayersControl(baseGroups = c("OSM", "Terrain", "Water Color", "Street", "Mapnik", "Landscape"),
                   options = layersControlOptions(collapsed = TRUE)) %>%
  addCircles(~longitude, ~latitude, popup= paste("<strong>", 
                                                 CarData$first_name, "</strong><br>", "Shirt Size: ", 
                                                 CarData$car_year), weight = 8, radius=40, 
             color="purple", stroke = TRUE, fillOpacity = 1.0)
map

# Add markers from the CSV with 1000 to this map. 
CarData <-CarRally1000
map <- leaflet(CarData) %>% 
  addProviderTiles("Stamen.TonerLite", 
                   options = providerTileOptions(minZoom = 4, maxZoom = 10)) %>%
  addMarkers(~longitude, ~latitude)
map

# Display first 200 observations
map <- leaflet(CarData[1:200,]) %>% 
  addProviderTiles("Stamen.TonerLite", 
                   options = providerTileOptions(minZoom = 4, maxZoom = 10))%>%
  addMarkers(~longitude, ~latitude)
map

# Make clusters
map <- leaflet(CarData[1:200,]) %>% 
  addProviderTiles("Stamen.TonerLite", 
                   options = providerTileOptions(minZoom = 4, maxZoom = 10))%>%
  addMarkers(~longitude, ~latitude, clusterOptions = markerClusterOptions())
map

# One more  on all 1,000 locations
map <- leaflet(CarData) %>% 
  addProviderTiles("Stamen.TonerLite", 
                   options = providerTileOptions(minZoom = 4, maxZoom = 10))%>%
  addMarkers(~longitude, ~latitude, clusterOptions = markerClusterOptions())
map