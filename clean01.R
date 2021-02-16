
# And look at the log...
#cat(readLines("test.log"), sep="\n")

#library(lubridate)
#library(dplyr)
#install.packages("plyr")
#library(plyr)

#install.packages("tidyverse")
library(tidyverse)
library(readxl)

# working directory
#getwd()
#setwd("C:/Users/USUARIO/OneDrive/Documentos/colabs/salud/tabaco/datos_inpc")
#
#setwd("C:/Users/vicen/OneDrive/Documentos/colabs/salud/tabaco/datos_inpc")


# load data
# https://drive.google.com/file/d/1gjiYxukBHpPwxGeZUK9FjCnshuQN0jPU/view?usp=sharing
# tabla2011_ <- read_xlsx("Tabla2011_.xlsx")
tabla_ago18_sep20 <- read_xlsx("Tabla_descriptivos_diciembre.xlsx",sheet="aux_ago18_sept20",range="A6:Y8196")
tabla_ene11_jul18<-read_xlsx("Tabla_descriptivos_diciembre.xlsx",sheet="aux_ene11_jul18",range="A8:Y24851")
tabla_oct20_dic20<-read_xlsx("Actualizacion_oct_dic_2020.xlsx",sheet="aux_oct_dic_2020",range="A8:Y953")

tabla2011_ <- bind_rows(tabla_ago18_sep20,tabla_ene11_jul18)
#tabla2011_ <- tabla_ago18_sep20
# summary(tabla2011_)

# variables para descripcion
# fecha
# mes y año
#Year <- tabla2011_$`Año`
Year <- tabla2011_$Año
Month <- tabla2011_$Mes
Day <- 1
df1<-data.frame(Year,Month,Day)

# fecha 
df1$fecha<-as.Date(with(df1,paste(Year,Month,Day,sep="-")),"%Y-%m-%d")
df1

# ciudad
# marca-tipo: generar un "alternativo" consecutivo?
#df <-data.frame(df1,tabla2011_$cve_ciudad,tabla2011_$pp,tabla2011_$pzas,tabla2011_$marca,tabla2011_$esp)
df <-tibble(df1,tabla2011_$cve_ciudad,tabla2011_$pp,tabla2011_$pzas,tabla2011_$marca,tabla2011_$esp)

# precio por unidad
df$ppu <- tabla2011_$pp/tabla2011_$pzas

## Agrupacion
# ppu, por ciudad, por tipo(agrupado?)
summary(df)

# http://www.sthda.com/english/wiki/creating-and-saving-graphs-r-base-graphs
pdf("rplot.pdf") 
#jpeg('rplot.jpg')

#jpeg("rplot.jpg", width = 500, height = 350)
# 2. Create a plot
#plot(x = my_data$wt, y = my_data$mpg,
#     pch = 16, frame = FALSE,
#     xlab = "wt", ylab = "mpg", col = "#2E9FDF")
# Close the pdf file
ggplot(df, aes(fecha, ppu, colour = tabla2011_.marca)) + 
  geom_point()
#dev.copy(png,'myplot.png')
dev.off() 

# identificar los que vienen por paquete
# ppu > 10
to_review <- subset(df,ppu>=10)
df_review <- subset(df,ppu<10)

# ppu, por ciudad, por tipo(agrupado?)
summary(df_review)

ggplot(df_review, aes(Date, ppu, colour = tabla2011_.marca)) + 
  geom_point()

# agrupar
# dos grupos de marca-tipo, por el precio
# qué tanto afecta los descriptivos las agrupaciones por nombre?
tabEsp <- table(df$tabla2011_.esp)
LimpiezaEsp <- data.frame(tabEsp)
write.csv(LimpiezaEsp,"LimpiezaEsp.csv", row.names = FALSE)

# by_marca
df_review %>%
  group_by(tabla2011_.marca) 

df_review %>% summarise(
  ppu = mean(ppu)
)

#tabMarcas <- table(df_review$tabla2011_.marca)
LimpiezaMarcas <- data.frame(table(df_review$tabla2011_.marca))
write.csv(LimpiezaMarcas,"LimpiezaMarcas.csv", row.names = FALSE)

# Chesterfield
#
df_review$marca2 <- df_review$tabla2011_.marca
# Solo funciona si los factores se cargan como Texto
#df_review$marca2[df_review$marca2=="CHESTER FIELD"]<- "CHESTERFIELD"
#df_review$marca2[df_review$marca2=="CHESTERFIEL"]<- "CHESTERFIELD"

library(plyr)

revalue(df_review$marca2, c("`DELICADOS" = "DELICADOS")) -> df_review$marca2
revalue(df_review$marca2, c("ALAS EXTRA" = "ALAS")) -> df_review$marca2

revalue(df_review$marca2, c("BENSON" = "BENSON & HEDGES")) -> df_review$marca2
revalue(df_review$marca2, c("BENSON &HEDGES" = "BENSON & HEDGES")) -> df_review$marca2
revalue(df_review$marca2, c("BENSON AND HEDGES" = "BENSON & HEDGES")) -> df_review$marca2
revalue(df_review$marca2, c("BENSON&HEDGES" = "BENSON & HEDGES")) -> df_review$marca2

revalue(df_review$marca2, c("CHESTERFIEL" = "CHESTERFIELD")) -> df_review$marca2
revalue(df_review$marca2, c("CHESTER FIELD" = "CHESTERFIELD")) -> df_review$marca2

revalue(df_review$marca2, c("LUCKIES" = "LUCKY STRIKE")) -> df_review$marca2
revalue(df_review$marca2, c("LUCKY" = "LUCKY STRIKE")) -> df_review$marca2

revalue(df_review$marca2, c("LUCKY STRIKE ROJOS" = "LUCKY STRIKE")) -> df_review$marca2
revalue(df_review$marca2, c("MALBOO" = "MARLBORO")) -> df_review$marca2
revalue(df_review$marca2, c("MALBORO" = "MARLBORO")) -> df_review$marca2
revalue(df_review$marca2, c("MARLBORO" = "MARLBORO")) -> df_review$marca2
revalue(df_review$marca2, c("MARLBORO GOLD" = "MARLBORO")) -> df_review$marca2

revalue(df_review$marca2, c("MONTANA SHOT" = "MONTANA")) -> df_review$marca2
revalue(df_review$marca2, c("MONTANA SHOTS" = "MONTANA")) -> df_review$marca2

revalue(df_review$marca2, c("PALL MALL XL" = "PALL MALL")) -> df_review$marca2
revalue(df_review$marca2, c("PALL MALL/XL" = "PALL MALL")) -> df_review$marca2
revalue(df_review$marca2, c("PALLMALL" = "PALL MALL")) -> df_review$marca2
revalue(df_review$marca2, c("PALLMALL XL" = "PALL MALL")) -> df_review$marca2

revalue(df_review$marca2, c("RALEIGHT" = "RALEIGH")) -> df_review$marca2

revalue(df_review$marca2, c("SHOT" = "MONTANA")) -> df_review$marca2
revalue(df_review$marca2, c("SHOTS" = "MONTANA")) -> df_review$marca2

# Ejemplo
#mtcars %>%
#  mutate(mpg=replace(mpg, cyl==4, NA)) %>%
#  as.data.frame()

# by_marca2
df_review %>%
  group_by(marca2) 
#tabMarcas2 <- table(by_marca2$marca2)
LimpiezaMarcas2 <- data.frame(table(df_review$marca2))
write.csv(LimpiezaMarcas2,"LimpiezaMarcas2.csv", row.names = FALSE)

summary(df_review)
ggplot(df_review, aes(Date, ppu, colour = marca2)) + 
  geom_point()

# agregar "rangos" para el impuesto
# como porcentaje
# como cantidad fija

# Saving on object in RData format
save(df_review, file = "df_review.RData")

rm(list=ls())
