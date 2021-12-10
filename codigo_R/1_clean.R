## Objetivo: 
## Limpiar variables: marca, cajas o cajetillas
## Calcular el precio por unidad
## AgrupaciÃ³n de datos: 10 ciudades (poner a Montana) > clean02.R
## Una sola observacion por ciudad, por marca. (promedio) 
## cercano al ultimo mes de 2019, podria ser trimestre?
## Resultados: graficos de tiempo, precio promedio por cada periodo
## Entrada: 
#- Tabla_descriptivos_diciembre.xlsx
#- Actualizacion_oct_dic_2020.xlsx, sustituido por Oct2020_abr2020.xlsx
## Salida: 
# - df_review.RData : ?LimpiezaMarcas2.csv
# - table11_principales7.RData: table11_principales7.csv
# - principales7.RData > clean02.R
# - menores.RData  > clean02.R
## ppu por fila, en algunas ciudades hay m'as de un precio por unidad, 
## ? hacer una fila por cada ciudad, antes de calcular el precio por unidad 
## ? promedio hacerlo geometrico?

# And look at the log...
###############################################
# Lectura de librerias
###############################################
#install.packages("dplyr")
library(dplyr)
#install.packages("plyr")
library(plyr)

#install.packages("tidyverse")
library(tidyverse)
library(readxl)

# working directory
getwd()
#
directorio <- "datos/iniciales/"

###############################################
# Carga de datos
###############################################
# termina en septiembre, se llama diciembre pues hicimos la revision en esa fecha
archivo <- paste0(directorio,"Tabla_descriptivos_diciembre.xlsx")
# Al parecer la versi'on de 14 de abril tiene alg'un tipo de ajuste en 
# el tipo de datos, no es la que estuve utilizando anteriormente
#archivoB <- paste0(directorio,"Tabla_descriptivos_diciembre (2).xlsx")

# datos de la muestra de ciudades actual desde 2018
# se hizo manual la actualizaci'on del rango
#tabla_ago18_sep20<-read_xlsx(archivo,sheet="aux_ago18_sept20",range="A6:Y8196")
tabla_ago18_sep20<-read_excel(archivo,sheet="aux_ago18_sept20",range="A6:Y8196")
# tiene hojas de INPC 2011 a 2018, con la muestra anterior de ciudades
# el rango se actualiza manualmente
tabla_ene11_jul18<-read_xlsx(archivo,sheet="aux_ene11_jul18",range="A8:Y24851")
#
archivo2 <- paste0(directorio,"Oct2020_abr2021.xlsx")
# 
tabla_oct20_abr21<-read_xlsx(archivo2,sheet="aux_oct20_abr21",range="A6:Y2211")
# SAFETY checks?
# rangos, recortar por fechas

tabla2011_ <- bind_rows(tabla_ago18_sep20,tabla_ene11_jul18)
# NECESARIO PARA ACTUALIZAR EL ARCHIVO DE ABRIL
#tabla2011_$encontrar_PZAS_ <- as.numeric(tabla2011_$encontrar_PZAS_)
#tabla2011_ <- tabla_ago18_sep20
#tabla2018_20 <- bind_rows(tabla_ago18_sep20,tabla_oct20_dic20)
#tabla2011_2020 <- bind_rows(tabla_oct20_dic20,tabla2011_)
tabla2011_2021 <- bind_rows(tabla_oct20_abr21,tabla2011_)
# summary(tabla2011_)
summary(tabla2011_2021)
rm(tabla2011_,tabla_ago18_sep20,tabla_ene11_jul18,tabla_oct20_abr21)
rm(archivo, archivo2)
# variables para descripcion
# fecha
# mes y a?o

# ciudad
# marca-tipo: generar un "alternativo" consecutivo?

###############################################
# renombrar columnas
###############################################
names(tabla2011_2021)[names(tabla2011_2021) == "Mes"] <- "month"
names(tabla2011_2021)[names(tabla2011_2021) == "Año"] <- "year"
names(tabla2011_2021)[names(tabla2011_2021) == "Clave ciudad"] <- "cve_ciudad"
names(tabla2011_2021)[names(tabla2011_2021) == "Precio promedio"] <- "pp"
names(tabla2011_2021)[names(tabla2011_2021) == "PIEZAS"] <- "pzas"
names(tabla2011_2021)[names(tabla2011_2021) == "marca-tipo"] <- "marca"
names(tabla2011_2021)[names(tabla2011_2021) == "Especificación"] <- "esp"
names(tabla2011_2021)[names(tabla2011_2021) == "CAJETILLAS"] <- "caj"
tabla2011_2021$day <- 1

# fecha 
tabla2011_2021$fecha<-as.Date(with(tabla2011_2021,paste(year,month,day,sep="-")),"%Y-%m-%d")

# tibble de trabajo
tabla2011_2021 <- tibble(tabla2011_2021)
df <-tabla2011_2021 %>% select(cve_ciudad,pp,pzas,marca,esp,caj,year,month,day,fecha)

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

#######################################################
# Limpiar/corregir los nombres de las marcas, para consistencia
#######################################################
tabEsp <- table(df$esp)
LimpiezaEsp <- data.frame(tabEsp)
write.csv(LimpiezaEsp,"datos/prelim/de_inpc/LimpiezaEsp.csv", row.names = FALSE)

## re-code 
df$marca_inicial <- df$marca
  
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

revalue(df$marca, c("SHOT" = "SHOTS")) -> df$marca

#######################################################
# Cambios en nombres por ajuste en "branding"
#######################################################
df$marca2 <- df$marca

revalue(df$marca, c("BOOTS" = "PALL MALL")) -> df$marca
revalue(df$marca, c("DELICADOS" = "CHESTERFIELD")) -> df$marca
revalue(df$marca, c("RALEIGH" = "LUCKY STRIKE")) -> df$marca
revalue(df$marca, c("SHOTS" = "MONTANA")) -> df$marca


# OTROS
revalue(df$marca, c("LM BARONET" = "BARONET")) -> df$marca
revalue(df$marca, c("L&M" = "BARONET")) -> df$marca

# plot2
ggplot(df, aes(fecha, ppu, colour = marca)) + 
  geom_point()

# identificar los que vienen por paquete
# ppu > 10
to_review <- subset(df,ppu>=10)
#view(to_review)
library("openxlsx")
write.xlsx(to_review, "datos/prelim/de_inpc/to_review.xlsx")
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

dfplot1 = ggplot(df_review, aes(fecha, ppu, colour = marca)) + 
  geom_point()
dfplot1

#pdf("df_review_ppu_marcas.pdf") 
#jpeg('graficos/df_review_ppu_marcas.jpg')
#jpeg('resultados/doc/df_review_ppu_marcas.jpg')
pdf('resultados/doc/df_review_ppu_marcas.pdf', height=11,width=8.5)
dfplot1
dev.off() 

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
write.csv(df_means,"datos/prelim/de_inpc/df_means.csv", row.names = FALSE)

LimpiezaMarcas2 <- data.frame(table(df_review$marca))
write.csv(LimpiezaMarcas2,"datos/prelim/de_inpc/LimpiezaMarcas2.csv", row.names = FALSE)

# 

summary(df_review)
ggplot(df_review, aes(fecha, ppu, colour = marca)) + 
  geom_point()

# agregar "rangos" para el impuesto
# como porcentaje
# como cantidad fija

# Saving on object in RData format
save(df_review, file = "datos/prelim/de_inpc/df_review.RData")

#rm(list=ls())

# notar que se puede agrupar por ciudad
# 
