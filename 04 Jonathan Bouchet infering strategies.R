----#librerias----

library(dplyr)
library(ggplot2)
library(grid)
library(corrgram)
library(corrplot)

----#kernel kaggle---- 
#define a function to classifiy the units : mobile or building 
#source : http://starcraft.wikia.com/wiki/Probe

mobile<-c('Protoss Archon','Protoss Carrier','Protoss Corsair','Protoss Dark Archon','Protoss Dark Templar','Protoss Dragoon','Protoss High Templar','Protoss Interceptor','Protoss Observer','Protoss Probe','Protoss Reaver','Protoss Scarab','Protoss Scout','Protoss Shuttle','Protoss Zealot')

building<-c('Protoss Arbiter','Protoss Arbiter Tribunal','Protoss Assimilator','Protoss Citadel of Adun','Protoss Cybernetics Core','Protoss Fleet Beacon','Protoss Forge','Protoss Gateway','Protoss Nexus','Protoss Observatory','Protoss Photon Cannon','Protoss Pylon','Protoss Robotics Facility','Protoss Robotics Support Bay','Protoss Shield Battery','Protoss Stargate','Protoss Templar Archives')

unitType<-function(x){
  if(x%in% mobile){
    return('mobile')
    break
  }
  else if (x%in% building){
    return('building')
    break
  }
  else {return('other')} 
}

starcraft_scouting$type<-sapply(starcraft_scouting$unit,unitType)
pvt_001 <- starcraft_scouting %>% dplyr::filter(game=='pvt_001')

----#Selection of Units to look at----

sumProd_001<-as.data.frame(pvt_001 %>% group_by(unit) %>% select(production) %>% summarise(sumProduction = sum(production)) %>% arrange(-sumProduction)) 
#head(tt,5)
pvt_001<-merge(pvt_001,sumProd_001,by='unit')
ggplot(data=filter(pvt_001,sumProduction>0),aes(x=cycle,y=`observable-units`)) + geom_point(aes(size=production,color=unit)) + xlab('Cycle (= chunk of 7mn gameplay)') + theme(legend.position='top',legend.text=element_text(size=5),legend.key.size = unit(.3, "cm"))

----#Protoss Probe: game 1----

g1<-ggplot(data=filter(pvt_001,unit=='Protoss Probe'),aes(x=cycle,y=production)) + geom_point() + theme(axis.title.x = element_blank(), axis.text.x = element_blank())
g2<-ggplot(data=filter(pvt_001,unit=='Protoss Probe'),aes(x=cycle,y= scouting)) + geom_point() + theme(axis.title.x = element_blank(), axis.text.x = element_blank())
g3<-ggplot(data=filter(pvt_001,unit=='Protoss Probe'),aes(x=cycle,y=`observable-units`)) + geom_point() + theme(axis.title.x = element_blank(), axis.text.x = element_blank())
g4<-ggplot(data=filter(pvt_001,unit=='Protoss Probe'),aes(x=cycle,y=`observed-losses`)) + geom_point()

grid.draw(rbind(ggplotGrob(g1), ggplotGrob(g2), ggplotGrob(g3), ggplotGrob(g4),size = "last"))

----#Protoss Dragoon : game 1----

h1<-ggplot(data=filter(pvt_001,unit=='Protoss Dragoon'),aes(x=cycle,y=production)) + geom_point() + theme(axis.title.x = element_blank(), axis.text.x = element_blank())
h2<-ggplot(data=filter(pvt_001,unit=='Protoss Dragoon'),aes(x=cycle,y= scouting)) + geom_point() + theme(axis.title.x = element_blank(), axis.text.x = element_blank())
h3<-ggplot(data=filter(pvt_001,unit=='Protoss Dragoon'),aes(x=cycle,y=`observable-units`)) + geom_point() + theme(axis.title.x = element_blank(), axis.text.x = element_blank())
h4<-ggplot(data=filter(pvt_001,unit=='Protoss Dragoon'),aes(x=cycle,y=`observed-losses`)) + geom_point()

grid.draw(rbind(ggplotGrob(h1), ggplotGrob(h2), ggplotGrob(h3), ggplotGrob(h4),size = "last"))

----#average over 500 games----

# aggregate by units and cycle
byUnitsCycle<-starcraft_scouting %>% group_by(unit,cycle) %>% select(scouting,production,`observable-units`) %>% summarize(meanScouting=mean(scouting), meanProd =mean(production),meanObservable = mean(`observable-units`))
# aggregate by cycle only (reference)
byCycleAll<-starcraft_scouting %>% group_by(cycle) %>% select(scouting,production,`observable-units`) %>% summarize(meanScouting=mean(scouting), meanProd =mean(production),meanObservable = mean(`observable-units`))
# aggregate by type and cycle
byCycleType<-starcraft_scouting %>% group_by(cycle,type) %>% select(scouting,production,`observable-units`) %>% summarize(meanScouting=mean(scouting), meanProd =mean(production),meanObservable = mean(`observable-units`))


#breakdown by unit
ggplot(data=byUnitsCycle,aes(x=cycle,y=meanScouting)) + geom_point(aes(color=unit)) + xlab('Cycle (= chunk of 7mn gameplay)') + theme(legend.position='top',legend.text=element_text(size=5),legend.key.size = unit(.3, "cm"))

#all together
ggplot() + geom_point(data=byCycleType,aes(x=cycle,y=meanScouting,color=type),size=4) + geom_line(data=byCycleAll,aes(x=as.numeric(cycle),y=meanScouting),size=1) + xlab('Cycle (= chunk of 7mn gameplay)')

byCycleAll$cycle <- as.numeric(byCycleAll$cycle)
byCycleType$cycle <- as.numeric(byCycleType$cycle)



cor1<-cor(byCycleType %>% filter(type=='mobile') %>% select(-c(cycle,type)),use="pairwise.complete.obs")
cor2<-cor(byCycleType %>% filter(type=='building') %>% select(-c(cycle,type)),use="pairwise.complete.obs")
par(mfrow=c(1,2))
corrplot(cor(cor1),method="ellipse")
corrplot(cor(cor2),method="ellipse")
