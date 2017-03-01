----#librerias----

library(dplyr)
library(corrplot)
library(ggplot2)
library(corrgram)
library(GGally)
library(corrplot)
library(ggcorrplot)
library(reshape2)
library(igraph)
library(sp)
library(diagram)

----#grafos----

## me quedo unicamente con casos que no tengan datos faltantes

sc_grafos <- starcraft_scouting[starcraft_scouting$losses>0 | starcraft_scouting$`observable-units`>0 | starcraft_scouting$production>0
                               | starcraft_scouting$`observed-losses`>0,]

sc_grafos <- sc_grafos %>% select(cycle,unit)

red.sc <- graph.edgelist(as.matrix(sc_grafos), directed = F)
summary(red.sc)

uniq_units <- unique(starcraft_scouting$unit)

#imagen del grafo de conexiones de unidades

red_unidades <- induced_subgraph(red.sc, vids = uniq_units)

summary(red_unidades) # cantidad de nodos y aristas

plot(red_unidades, layout=layout.fruchterman.reingold, vertex.size=3, vertex.label=NA)

# descripciones de la red

vcount(red_unidades) # numero de nodos
ecount(red_unidades) # numero de aristas
graph.density(red_unidades)  # densidad

V(red_unidades) #nodos
E(red_unidades) #aristas

is.simple(red_unidades) # tiene bucles
is.connected(red_unidades) # como se ve, esta compuesto por mas de una componente conexa

# Red de interacciones observadas
diameter(red_unidades)

degree(red_unidades) # grados de los nodos
summary( degree(red_unidades)) # se puede ver que la mediana es gr(n)=4


## histograma de frecuencias
deg <- degree(red_unidades, mode="all")
hist(deg, breaks=vcount(red_unidades), main="Histograma de Frecuencia de Grados", ylab = "Frecuencia", xlab= "Grado", col='red')

## componentes conexas
cfc <- clusters(red_unidades, mode="strong")  
# Cargo los colores de acuerdo a los clusters 
V(red_unidades)$color <- rainbow(cfc$no)[cfc$membership]
plot(red_unidades, mark.groups = lapply(seq_along(cfc$csize)[cfc$csize > 1], function(x) V(red_unidades)[cfc$membership %in% x]),layout=layout.fruchterman.reingold, vertex.size=3, vertex.label=NA)

## Grafico tamaño componentes conexas / % de clientes en cada componente
distribucion_componentes = cfc$csize[order(cfc$csize)]
count_componentes = cbind(unique(distribucion_componentes),table(distribucion_componentes))
plot(x= count_componentes[,1], y = count_componentes[,2], col= "red",pch=5, cex=0.5,xlab="Tamaño Componente conexa", ylab="Cantidad",main="Grafico de componentes")


#coeficiente de clustering

coef_clustering = transitivity(red_unidades, type = "local")
coef_clustering[is.nan(coef_clustering)] <- NA

hist(coef_clustering, main = "Coeficiente de Clustering", breaks = seq(0.0, 1, 0.05), xlab = "Coeficiente", ylab="Frecuencia", col= "red")


## Probabilidad de grado
grados_nodos =degree.distribution(red_unidades,mode='all')
plot(grados_nodos, pch=5, cex=0.5, col="Blue", xlab="Grado", ylab="Prob grado = x")


# probabilidad acumulada
prob_grados_acum <- degree_distribution(red_unidades, cumulative=T, mode="all")
plot( x=0:max(deg), y= prob_grados_acum, pch=3, cex=0.5, col="Blue", xlab="Grado", ylab="Prob grado > x")


# Centralidad 
degree(red_unidades, mode="in")
centr_degree(red_unidades, mode="in", normalized=T)


sum_df <- starcraft_scouting %>% select(-unit) %>% group_by(game,cycle,vision) %>% summarise_all(sum)

names <- colnames(starcraft_scouting)



hist(starcraft_scouting$production)