install.packages("googlesheets4")
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

v1<-ggplot(data=statesPerWin, aes(x=States, y=percentWins)) +
  geom_bar(stat="identity")
v1

v1<-ggplot(data=statesPerWin, aes(x=States, y=percentWins)) +
  geom_bar(stat="identity", width=0.5, color="purple", fill="white")
v1

v1 + labs(title="Percent Win for Each State", x ="Team's State", y = "Percentage")
v1


install.packages("sf")
library("sf")
michiganCounties_sf <- st_read("Michigan_State_Senate_Districts_2021.shp")


ggplot() + 
  geom_sf(data = michiganCounties_sf, size = 3, color = "black", fill = "blue") + 
  ggtitle("Michigan Map") + 
  coord_sf()
