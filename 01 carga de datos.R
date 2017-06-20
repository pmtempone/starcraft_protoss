<<<<<<< HEAD
----#libreria---
  
library(readr)
library(data.table)
library(dplyr)
library(ggplot2)
library(grid)
library(corrgram)
library(corrplot)
library(rvest)
library(stringr)
library(reshape)

----#carga-----
  
starcraft_scouting <- read_csv("C:/Users/Pablo/OneDrive/Starcraft kaggle datasets/starcraft_scouting.csv")
 
starcraft_scouting$unit <- as.factor(starcraft_scouting$unit) 
starcraft_scouting$cycle <- as.factor(starcraft_scouting$cycle) 


summary(starcraft_scouting)

----#scrape unit data from teamliquid-----


url_protoss_units <- "http://wiki.teamliquid.net/starcraft/Protoss_Unit_Statistics"
protoss_units <- url_protoss_units %>%  read_html() %>% html_nodes(xpath='//*[@id="mw-content-text"]/table[1]') %>% html_table()
protoss_units <- protoss_units[[1]]
=======
----#libreria----
  
library(readr)
library(data.table)
library(dplyr)
library(ggplot2)
library(grid)
library(corrgram)
library(corrplot)
library(rvest)
library(stringr)
library(reshape)

----#carga-----
  
starcraft_scouting <- read_csv("C:/Users/Pablo/OneDrive/Starcraft kaggle datasets/starcraft_scouting.csv")
 
starcraft_scouting$unit <- as.factor(starcraft_scouting$unit) 
starcraft_scouting$cycle <- as.factor(starcraft_scouting$cycle) 


summary(starcraft_scouting)

----#scrape unit data from teamliquid-----


url_protoss_units <- "http://wiki.teamliquid.net/starcraft/Protoss_Unit_Statistics"
protoss_units <- url_protoss_units %>%  read_html() %>% html_nodes(xpath='//*[@id="mw-content-text"]/table[1]') %>% html_table()
protoss_units <- protoss_units[[1]]
>>>>>>> origin/master
rownames(units_dark_templar) <- units_dark_templar[complete.cases(units_dark_templar),1]