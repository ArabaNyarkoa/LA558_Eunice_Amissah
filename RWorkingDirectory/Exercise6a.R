# Eunice Amissah-Mensah

# 2/23/2023

#Load API keys

census_api_key("5e2e0a069f67147640ce3128b7beaa7ff32131f8",  overwrite = TRUE, install = TRUE)

readRenviron("~/.Renviron")

#Install Packages

install.packages(c("mapview", "leafsync", "ggspatial"))

# Brand-new Features

install.packages("remotes")
remotes::install_github("walkerke/tidycensus")

#ACS

library(tidycensus)


census_api_key("5e2e0a069f67147640ce3128b7beaa7ff32131f8", install = TRUE)
1

#Checking for Variables
vars <-load_variables(2020, "pl")

View(vars)

(tigris_use_cache = TRUE)

#Map Creation
MI_population <- get_decennial(
  geography = "county",
  variables = "H1_001N",
  state = "MI",
  year = 2020,
  geometry = TRUE
)

View(MI_population) 

plot(MI_population["value"])

library(tidyverse)

#Editing Map

MI_map <- ggplot(MI_population, aes(fill = H1_001N)) + geom_sf()+
  ggtitle("Spatial Distribution of Occupancy Status")+
  theme_void() + theme(plot.title=element_text(hjust=0.5))

MI_map