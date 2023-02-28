# Eunice Amissah-Mensah
# LA 558
# Assignment 2

# Scripts and Packages
install.packages("tidyverse", "readxl", "sf", "googlesheets4")
library(tidyverse)
library(sf)
library("readxl")

Learners_data <- read_excel("Iowa Public English Learners.xlsx")

learners_list <- Learners_data %>% group_by(CountyName) %>% summarize(Grade9 =sum(Grade9), Grade10 = sum(Grade10), Grade11 = sum(Grade11), Grade12 = sum(Grade12), K12EL = sum(K12EL), K12TotalEnrollment = sum(K12TotalEnrollment), Grade9Percent = sum(Grade9)/sum(K12TotalEnrollment), Grade12Percent = sum(Grade12)/sum(K12TotalEnrollment), dcount = n())

library(googlesheets4)

championshipswon <- read_sheet("https://docs.google.com/spreadsheets/d/1To9HKmKv2VFyDjyyhpINylM-mKXk_VnqVuBa9KC-NGA/edit?usp=sharing")
head(championshipswon)

library(tidyverse)

totalSeasonsPlayed <-championshipswon %>%
  summarize(ChampionsWon= sum(Championships_Won))
totalSeasonsPlayed

view(teamsWin)

statesPerWin <- championshipswon %>%
  group_by(States) %>%
  summarize(ChampionshipsWon= sum(Championships_Won)) %>%
  mutate(percentWins = round(ChampionshipsWon / sum(ChampionshipsWon), 3)*100) %>%
  as.data.frame()

view(statesPerWin)

# Basic Barplot Generated

v1<-ggplot(data=statesPerWin, aes(x=States, y=percentWins)) +
  geom_bar(stat="identity")
v1

# Barplot Formatting

v1<-ggplot(data=statesPerWin, aes(x=States, y=percentWins)) +
  geom_bar(stat="identity", width=0.5, color="purple", fill="white")
v1

# A little more formatting

v1<-ggplot(data=statesPerWin, aes(x=States, y=percentWins)) +
  geom_bar(stat="identity", width=0.5,fill="red")+ geom_text(aes(label=percentWins), vjust=2.0, size=3.5, color="pink")+theme_minimal()
v1

# Title Added

v1 + labs(title="Percent Win for Each State", x ="Team's State", y = "Percentage") + theme(plot.title=element_text(hjust=0.5))
v1

library("sf") 
Iowacounties_sf <- st_read("IowaCounties.shp")


ggplot() + 
  geom_sf(data = Iowacounties_sf, size = 3, color = "black", fill = "blue") + 
  ggtitle("IowaMap") + 
  coord_sf()

#Join Geometry learners_list

MapIowa <- left_join(Iowacounties_sf, learners_list, by = "CountyName")

#Plot variable

ggplot(MapIowa) + 
  geom_sf(aes(fill = K12TotalEnrollment))+
  ggtitle("English Learners in Iowa")

ggplot(MapIowa) +
  geom_sf(aes(fill = K12TotalEnrollment))+
  ggtitle("English Learners in Iowa") +
  theme_void() +
  theme(plot.title=element_text(hjust=0.5))

# Plot Origin

learners_list2 <- read_excel("Iowa Public English Learners.xlsx", "Chart")

public_grade <- learners_list2 %>%
  group_by(CountyName) %>%
  mutate(PublicGrade = round(Grade12 / Grade9, 3)*100) %>%
  as.data.frame()

Plot1 <- ggplot(data=public_grade, aes(x=CountyName, y=PublicGrade)) +
  geom_bar(stat="identity", width=0.5, fill="violet") +
  geom_text(aes(label=PublicGrade), vjust=2.0,size=3.5,color="white")+
  theme_minimal()
Plot1

Plot1 + labs(title="Grades for Public English Learners", x ="CountyName",y= "Percentage") +
  theme(plot.title=element_text(hjust=0.5))
            
            