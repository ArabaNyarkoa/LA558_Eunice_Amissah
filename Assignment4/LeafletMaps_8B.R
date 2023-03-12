# Eunice Amissah-Mensah
#
# March 10,2023
# Assignment 4 Combined 
# Leaflet Maps - HTML


install.packages("leaflet", "leaflet.providers", "tidyverse", "sf")
library(leaflet)
library(leaflet.providers)
library(tidyverse)
library(readxl)
library(sf)

carCount <- st_read("TXCarRally.shp")
carCount <- st_transform(carCount, crs = 4326)
carCount <- carCount %>% rename(count = first_name)
carCount <- carCount %>% replace(is.na(.), 0)

library("RColorBrewer")
display.brewer.all() 
bins <- c(0, 2, 4, 6, 8, 10, 12, 14, Inf)
pal <- colorBin("BuPu", domain = carCount$count, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>%g cars",
  carCount$COUNTY, carCount$count) %>% lapply(htmltools::HTML)

# Add markers, convert to data frame, and spatial data frame
longitude<- c(-95.4,-96.7, -97.7)
latitude<- c(29.7, 32.7, 30.3)
df <- data.frame(longitude, latitude)

df_sf = st_as_sf(df, coords = c("longitude", "latitude"), crs = 4326)

bounds <- df_sf %>% 
  st_bbox() %>% 
  as.character()
#fitBounds(txmap, bounds[1], bounds[2], bounds[3], bounds[4])


bounds <- carCount %>% 
  st_bbox() %>% 
  as.character()
#fitBounds(txmap, bounds[1], bounds[2], bounds[3], bounds[4])

txmap <- leaflet() %>%
  setView(-99.5, 32.2, 5)  %>%
  addTiles() %>%
  addMarkers(data = df_sf) %>%
  addPolygons(data = carCount,
              fillColor = ~pal(count),
              weight = 0.5,
              opacity = 1,
              color = "grey",
              dashArray = "1",
              fillOpacity = 0.8,  
              highlightOptions = highlightOptions(
                weight = 2,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "10px",
                direction = "auto")) %>% addLegend(pal = pal, values = count, opacity = 0.7, title = "Cars",
                                                  position = "bottomright")
txmap


txmap %>% addLegend(pal = pal, values = count, opacity = 0.7, title = "Cars",
                    position = "bottomright")