# Eunice Amissah-Mensah
#
# Assignment 4_B 
# Leaflet mapping: Make a Chloropleth map.


install.packages("leaflet", "leaflet.providers", "tidyverse", "sf")
library(leaflet)
library(leaflet.providers)
library(tidyverse)
library(readxl)
library(sf)

# Texas Shapefile
carCount<- st_read("TXCarRally.shp")

carCount <- st_transform(carCount, crs = 4326)

carCount <- carCount %>% rename(count = first_name)

txmap <- leaflet() %>%
  setView(-99.5, 32.2, 5)  %>%
  addTiles() %>%
  addPolygons(data = carCount,  
              color = "purple", fill = NA, weight = 2)
txmap

# Some counties displayed
carCount_selection1 <- carCount %>% 
  filter(CNTY_NM %in% c("Harris", "Uvalde", "Fayette"))

txmap <- leaflet() %>%
  setView(-99.5, 32.2, 5)  %>%
  addTiles() %>%
  addPolygons(data = carCount_selection1,  
              color = "#800080", fillColor = "yellow", weight = 2, opacity = 0.5)
txmap

carCount_selection2 <- carCount %>% 
  filter(is.na(count) | !count > 0)

txmap <- leaflet() %>%
  setView(-99.5, 32.2, 5)  %>%
  addTiles() %>%
  addPolygons(data = carCount_selection2,  
              color = "#000", fillColor = "darkgreen", weight = 1, 
              opacity = 0.75, fillOpacity = 0.8)
txmap


# Both NA and Selected counties

txmap <- leaflet() %>%
  setView(-99.5, 32.2, 5)  %>%
  addTiles() %>%
  addPolygons(data = carCount_selection2,  
              color = "#000", fillColor = "darkgreen", weight = 1, 
              opacity = 0.75, fillOpacity = 0.8) %>%
  
  addPolygons(data = carCount_selection1,  
              color = "#800080", fillColor = "yellow", weight = 5, 
              opacity = 0.75, fillOpacity = 0.8)
txmap

# NA to 0
carCount <- carCount %>%
  replace(is.na(.), 0)

# Select color scheme from Color Brewer
library("RColorBrewer") 
display.brewer.all()


bins <- c(0, 2, 4, 6, 8, 10, 12, 14, Inf)
pal <- colorBin("BuPu", domain = carCount$count, bins = bins)

txmap <- leaflet() %>%
  setView(-99.5, 32.2, 5)  %>%
  addTiles() %>%
  addPolygons(data = carCount,
              fillColor = ~pal(count),
              weight = 0.5,
              opacity = 1,
              color = "grey",
              dashArray = "1",
              fillOpacity = 0.8)
txmap


# Add interaction
txmap <- leaflet() %>%
  setView(-99.5, 32.2, 5)  %>%
  addTiles() %>%
  addPolygons(data = carCount,
              fillColor = ~pal(count),
              weight = 0.5,
              opacity = 1,
              color = "grey",
              dashArray = "1",
              fillOpacity = 0.8,  #be careful, you need to switch the ) to a comma
              highlightOptions = highlightOptions(
                weight = 2,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE)
  )
txmap

# Labels

labels <- sprintf(
  "<strong>%s</strong><br/>%g cars",
  carCount$CNTY_NM, carCount$count
) %>% lapply(htmltools::HTML)


longitude<- c(-95.4,-96.7, -97.7)
latitude<- c(29.7, 32.7, 30.3)
df <- data.frame(longitude, latitude)

df_sf = st_as_sf(df, coords = c("longitude", "latitude"), crs = 4326)

fitBounds(txmap, -106.630888, 31.980960, -94.064043, 33.578604,)
txmap

bounds <- df_sf %>% 
  st_bbox() %>% 
  as.character()
fitBounds(txmap, bounds[1], bounds[2], bounds[3], bounds[4])


bounds <- carCount %>% 
  st_bbox() %>% 
  as.character()
fitBounds(txmap, bounds[1], bounds[2], bounds[3], bounds[4])

txmap <- leaflet() %>%
  setView(-99.5, 32.2, 5)  %>%
  addTiles() %>%
  addMarkers(data = df_sf) %>%
  fitBounds(bounds[1], bounds[2], bounds[3], bounds[4]) %>%
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
                direction = "auto"))
txmap


# Add a legend
txmap %>% addLegend(pal = pal, values = count, opacity = 0.7, title = "Cars",
                    position = "bottomright")

library(htmlwidgets)
#This does the same as export and creates a single 1.7 MB file
saveWidget(m, file="m.html")

# however if you want to export multiple maps for a page, then you can put 
# the shared resources into a dir named lib. The m.html file then is 1.
saveWidget(m, "m.html", selfcontained = F, libdir = "lib")
