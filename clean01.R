## Objetivo: 
## Limpiar variables: marca, jajas o cajetillas
## Calcular el precio por unidad
## Agrupación de datos: 10 ciudades (poner a Montana) > clean02.R
## Una sola observacion por ciudad, por marca. (promedio) 
## cercano al ultimo mes de 2019, podria ser trimestre?
## Resultados: graficos de tiempo, precio promedio por cada periodo
## Entrada: 
#- Tabla_descriptivos_diciembre.xlsx
#- Actualizacion_oct_dic_2020.xlsx
## Salida: 
# - df_review.RData : ?LimpiezaMarcas2.csv
# - table11_principales7.RData: table11_principales7.csv
# - principales7.RData > clean02.R
# - menores.RData  > clean02.R
## ppu por fila, en algunas ciudades hay m'as de un precio por unidad, 
## ? hacer una fila por cada ciudad, antes de calcular el precio por unidad 
## ? promedio hacerlo geometrico?

# And look at the log...
#cat(readLines("test.log"), sep="\n")

#library(lubridate)
#install.packages("dplyr")
library(dplyr)
#install.packages("plyr")
library(plyr)

#install.packages("tidyverse")
library(tidyverse)
library(readxl)

# working directory
getwd()
#setwd("C:/Users/USUARIO/OneDrive/Documentos/colabs/salud/tabaco/datos_inpc")
#
directorio <- "datos/iniciales/"

#Parte1 = read_xlsx("C:/Users/danny/Downloads/Tabla_descriptivos_diciembre.xlsx")
#Parte2 = read_xlsx("C:/Users/danny/Downloads/Actualizacion_oct_dic _2020.xlsx")

# load data
# https://drive.google.com/file/d/1gjiYxukBHpPwxGeZUK9FjCnshuQN0jPU/view?usp=sharing
# tabla2011_ <- read_xlsx("Tabla2011_.xlsx")
archivo <- paste0(directorio,"Tabla_descriptivos_diciembre.xlsx")
tabla_ago18_sep20<-read_xlsx(archivo,sheet="aux_ago18_sept20",range="A6:Y8196")
#tabla_ago18_sep20<-read_xlsx("Tabla_descriptivos_diciembre.xlsx",sheet="aux_ago18_sept20",range="A6:Y8196")
tabla_ene11_jul18<-read_xlsx(archivo,sheet="aux_ene11_jul18",range="A8:Y24851")
#tabla_ene11_jul18<-read_xlsx("Tabla_descriptivos_diciembre.xlsx",sheet="aux_ene11_jul18",range="A8:Y24851")
archivo2 <- paste0(directorio,"Actualizacion_oct_dic_2020.xlsx")
tabla_oct20_dic20<-read_xlsx(archivo2,sheet="aux_oct_dic_2020",range="A8:Y953")
#tabla_oct20_dic20<-read_xlsx("Actualizacion_oct_dic_2020.xlsx",sheet="aux_oct_dic_2020",range="A8:Y953")
# SAFETY checks?
# rangos, recortar por fechas

tabla2011_ <- bind_rows(tabla_ago18_sep20,tabla_ene11_jul18)
#tabla2011_ <- tabla_ago18_sep20
#tabla2018_20 <- bind_rows(tabla_ago18_sep20,tabla_oct20_dic20)
tabla2011_2020 <- bind_rows(tabla_oct20_dic20,tabla2011_)
# summary(tabla2011_)
summary(tabla2011_2020)
rm(tabla2011_,tabla_ago18_sep20,tabla_ene11_jul18,tabla_oct20_dic20)
rm(archivo, archivo2)
# variables para descripcion
# fecha
# mes y a?o

# ciudad
# marca-tipo: generar un "alternativo" consecutivo?

# nombres de variables
names(tabla2011_2020)[names(tabla2011_2020) == "Mes"] <- "month"
names(tabla2011_2020)[names(tabla2011_2020) == "Año"] <- "year"
names(tabla2011_2020)[names(tabla2011_2020) == "Clave ciudad"] <- "cve_ciudad"
names(tabla2011_2020)[names(tabla2011_2020) == "Precio promedio"] <- "pp"
names(tabla2011_2020)[names(tabla2011_2020) == "PIEZAS"] <- "pzas"
names(tabla2011_2020)[names(tabla2011_2020) == "marca-tipo"] <- "marca"
names(tabla2011_2020)[names(tabla2011_2020) == "Especificación"] <- "esp"
names(tabla2011_2020)[names(tabla2011_2020) == "CAJETILLAS"] <- "caj"
tabla2011_2020$day <- 1

# fecha 
tabla2011_2020$fecha<-as.Date(with(tabla2011_2020,paste(year,month,day,sep="-")),"%Y-%m-%d")

# tibble de trabajo
tabla2011_2020 <- tibble(tabla2011_2020)
df <-tabla2011_2020 %>% select(cve_ciudad,pp,pzas,marca,esp,caj,year,month,day,fecha)

 # precio por unidad
df$ppu <- df$pp/(as.integer(df$pzas))
## Agrupacion
# ppu, por ciudad, por tipo(agrupado?)
summary(df)

# http://www.sthda.com/english/wiki/creating-and-saving-graphs-r-base-graphs
#pdf("rplot.pdf") 
#jpeg('rplot.jpg')

#jpeg("rplot.jpg", width = 500, height = 350)
# 2. Create a plot
#plot(x = my_data$wt, y = my_data$mpg,
#     pch = 16, frame = FALSE,
#     xlab = "wt", ylab = "mpg", col = "#2E9FDF")
# Close the pdf file
ggplot(df, aes(fecha, ppu, colour = marca)) + 
  geom_point()
#dev.copy(png,'myplot.png')
#dev.off() 

# Limpiar o corregir los nombres de las marcas
tabEsp <- table(df$esp)
LimpiezaEsp <- data.frame(tabEsp)
write.csv(LimpiezaEsp,"LimpiezaEsp.csv", row.names = FALSE)

## re-code 

revalue(df$marca, c("´DELICADOS" = "DELICADOS")) -> df$marca 
revalue(df$marca, c("ALAS EXTRA" = "ALAS")) -> df$marca

revalue(df$marca, c("BENSON" = "BENSON & HEDGES")) -> df$marca
revalue(df$marca, c("BENSON &HEDGES" = "BENSON & HEDGES")) -> df$marca
revalue(df$marca, c("BENSON AND HEDGES" = "BENSON & HEDGES")) -> df$marca
revalue(df$marca, c("BENSON&HEDGES" = "BENSON & HEDGES")) -> df$marca

revalue(df$marca, c("CHESTERFIEL" = "CHESTERFIELD")) -> df$marca
revalue(df$marca, c("CHESTER FIELD" = "CHESTERFIELD")) -> df$marca

revalue(df$marca, c("LUCKIES" = "LUCKY STRIKE")) -> df$marca
revalue(df$marca, c("LUCKY" = "LUCKY STRIKE")) -> df$marca

revalue(df$marca, c("LUCKY STRIKE ROJOS" = "LUCKY STRIKE")) -> df$marca
revalue(df$marca, c("MALBOO" = "MARLBORO")) -> df$marca
revalue(df$marca, c("MALBORO" = "MARLBORO")) -> df$marca
revalue(df$marca, c("MARLBORO" = "MARLBORO")) -> df$marca
revalue(df$marca, c("MARLBORO GOLD" = "MARLBORO")) -> df$marca

revalue(df$marca, c("MONTANA SHOT" = "MONTANA")) -> df$marca
revalue(df$marca, c("MONTANA SHOTS" = "MONTANA")) -> df$marca

revalue(df$marca, c("PALL MALL XL" = "PALL MALL")) -> df$marca
revalue(df$marca, c("PALL MALL/XL" = "PALL MALL")) -> df$marca
revalue(df$marca, c("PALLMALL" = "PALL MALL")) -> df$marca
revalue(df$marca, c("PALLMALL XL" = "PALL MALL")) -> df$marca

revalue(df$marca, c("RALEIGHT" = "RALEIGH")) -> df$marca

revalue(df$marca, c("SHOT" = "MONTANA")) -> df$marca
revalue(df$marca, c("SHOTS" = "MONTANA")) -> df$marca

# ajustes de nombres
revalue(df$marca, c("DELICADOS" = "CHESTERFIELD")) -> df$marca
revalue(df$marca, c("RALEIGHT" = "LUCKY STRIKE")) -> df$marca

# plot2
ggplot(df, aes(fecha, ppu, colour = marca)) + 
  geom_point()

# identificar los que vienen por paquete
# ppu > 10
to_review <- subset(df,ppu>=10)
#view(to_review)
library("openxlsx")
write.xlsx(to_review, "to_review.xlsx")
# 103 rows, CAMEL, 2017, 22.4 por unidad
# delicados-> chesterfield
df_review <- subset(df,ppu<10)
# reemplazar
# 
#df$caj[df$ppu > 10] <- 10 
# recalcular estos
#df$pzas <-df$pzas*df$caj  
# pp
#df$ppu <-df$pp/df$pzas  
# ppu


# ppu, por ciudad, por tipo(agrupado?)
summary(df_review)

ggplot(df_review, aes(fecha, ppu, colour = marca)) + 
  geom_point()

# agrupar
# dos grupos de marca-tipo, por el precio
# qu? tanto afecta los descriptivos las agrupaciones por nombre?

# by_marca
df_review %>%
  group_by(marca) 

df_means <- df_review %>%
  group_by(marca) %>%
  summarise_at(vars(ppu), list(name = mean))

#tabMarcas <- table(df_review$tabla2011_.marca)
write.csv(df_means,"df_means.csv", row.names = FALSE)

LimpiezaMarcas2 <- data.frame(table(df_review$marca))
write.csv(LimpiezaMarcas2,"LimpiezaMarcas2.csv", row.names = FALSE)

# 

summary(df_review)
ggplot(df_review, aes(fecha, ppu, colour = marca)) + 
  geom_point()

# agregar "rangos" para el impuesto
# como porcentaje
# como cantidad fija

# Saving on object in RData format
save(df_review, file = "datos/df_review.RData")

rm(list=ls())

# notar que se puede agrupar por ciudad
# 
