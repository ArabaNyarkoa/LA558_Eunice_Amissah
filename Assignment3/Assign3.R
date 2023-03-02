# Eunice Amissah-Mensah

# Assignment 3

# March 2, 2023


# IDBR Package
install.packages("idbr")
library(tidycensus)
library(tidyverse)
library(idbr)


vars = idb_variables()
view(vars)

ghana_pop <- get_idb(country = "Ghana", variables = "E0_F", year = 2000 :2010)

view(ghana_pop)

library(tidyverse)

ggplot(ghana_pop, aes(x = year, y = e0_f)) + 
  geom_line(color = "darkgreen") + 
  theme_minimal() + 
  scale_y_continuous(labels = scales::label_number()) + 
  labs(title = "Female Life Expectancy in Ghana",
       subtitle = "From 2000 to 2010",
       x = "Year",
       y = "Life Expectancy at birth") + theme(plot.title=element_text(hjust=0.5)) +theme(plot.subtitle=element_text(hjust=0.5))


# use of Tidycensus

library(tidycensus)
census_api_key("5e2e0a069f67147640ce3128b7beaa7ff32131f8",  overwrite = TRUE, install = TRUE)

readRenviron("~/.Renviron")

library(tidycensus)

census_api_key("5e2e0a069f67147640ce3128b7beaa7ff32131f8",overwrite = TRUE, install = TRUE)

vars1 <-load_variables(2021, "acs5")

View(vars1)

MI_population <- get_acs(
  geography = "county",
  variables = "B11011_001",
  state = "MI",
  year = 2021,
  geometry = TRUE
)
View(MI_population) 

plot(MI_population["estimate"])

MI_population <- MI_population %>%
  mutate(hsehold_percent = round(estimate/ moe, 3)*100)

plot(MI_population["hsehold_percent"]) 

plot1 <- ggplot(data = MI_population) +
  geom_sf(aes(fill = hsehold_percent)) + 
  scale_colour_brewer(palette = "Spectral") +
  coord_sf(crs = "+init=epsg:26915") +
  labs(title = "Percent of Household Type by Units.", fill="Percent")
plot1

plot1 + theme(rect = element_blank(), axis.ticks = element_blank(), 
              axis.text.x = element_blank(), axis.text.y = element_blank())

library("sf")
Michigancounties_sf <- st_read("Counties_(v17a).shp")
View(Michigancounties_sf)


# Use of Excel to Plot Map

library("readxl")
library(tidyverse)
michigan_laborforce<- read_excel("Employment_and_Unemployment_Statistics.xlsx")

michigan_labor_list <- michigan_laborforce %>%
  group_by(County) %>% summarise(Employed = sum(Employed), Workforce = sum(Workforce), Unemployed = sum(Unemployed), UnemploymentRate = sum(UnemploymentRate), EmploymentRate = sum(Employed)/sum(Workforce)* 100, dCount = n())
michigan_labor_list

library("sf")
Michigancounties_sf <- st_read("Counties_(v17a).shp")
View(Michigancounties_sf)

Michigancounties_sf <- Michigancounties_sf %>% rename("County" = "LABEL")
View(Michigancounties_sf)

#Join Geometry

MapMichigan <- left_join(Michigancounties_sf, michigan_labor_list, by = "County")
view(MapMichigan)

library(ggplot2)
ggplot(MapMichigan) + 
  geom_sf(aes(fill = Employed))+
  ggtitle("Employment in the State of Michigan")

ggplot(MapMichigan) +
  geom_sf(aes(fill = Employed))+
  ggtitle("Employment in the State of Michigan") +
  theme_void() +
  theme(plot.title=element_text(hjust=0.5))


#Plot variable

library(ggplot2)

ggplot(MapMichigan) + 
  geom_sf(aes(fill = EmploymentRate)) +
  labs(title = "Rate of Employment in the State of Michigan",
       subtitle = str_wrap("County Values", 80)) + 
  theme_void() + theme(plot.title=element_text(hjust=0)) + 
  theme(plot.subtitle=element_text(hjust=0.5)) + 
  theme(panel.background = element_rect(color = "black", fill = "white"))