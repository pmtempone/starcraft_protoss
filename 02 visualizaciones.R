----#librerias----

library(dplyr)
library(corrplot)
library(ggplot2)
library(corrgram)
library(GGally)
library(corrplot)
library(ggcorrplot)

---#visualizaciones----


cor_values <- cor(starcraft_scouting[,4:9],use="complete.obs")

ggcorrplot(cor_values, hc.order = TRUE, 
           type = "lower", 
           lab = TRUE, 
           lab_size = 3, 
           method="circle", 
           colors = c("tomato2", "white", "springgreen3"), 
           title="Correlogram of units", 
           ggtheme=theme_bw)


corrgram(starcraft_scouting[,4:9], order=TRUE, lower.panel=panel.shade,
         upper.panel=panel.pie, text.panel=panel.txt,
         main="correlations") 
