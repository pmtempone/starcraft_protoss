----#librerias----

library(dplyr)
library(corrplot)
library(ggplot2)
library(corrgram)
library(GGally)
library(corrplot)
library(ggcorrplot)
library(reshape2)
---#visualizaciones----


cor_values <- cor(starcraft_scouting[,4:9],use="pairwise.complete.obs")

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

##distribuciones por variables



df.m <- melt(starcraft_scouting[,c(3:8)],id.vars = "unit")

ggplot(data = df.m, aes(x = variable, y = value)) + geom_boxplot(aes(fill=unit))

ggplot(data = df.m, aes(x = variable, y = value))+facet_wrap(~unit) + geom_boxplot()


ggplot(data = df.m, aes(x = variable, y = value,fill=unit)) + geom_density(alpha=0.25)


