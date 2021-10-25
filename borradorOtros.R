# Dentro de clean02.R
# después de cálculo de
# fecha_marca_sum (línea 37)
# se usa df_review


# working directory
getwd()
directorio <- "datos/iniciales/"
# 
# queremos las marcas o presentaciones m'as representativas
# considerar las que tienen una presencia mayor en las ciudades

#library(tidyverse)
library(ggplot2)
library(dplyr)


# objetos previos que son utiles:
load("datos/prelim/de_inpc/df_review.RData")
summary(df_review)

# promedios por ciudad, una observación por periodo
load("datos/prelim/de_inpc/fecha_marca_sum.RData")
summary(fecha_marca_sum)

# UNA GRAFICA SIMILAR A LA SIGUIENTE (Clean01.R) para 
# sólo con las 7 principales y la que se quiere considerar
#plot each "other brand" with the main 7.
# dfplot1 = ggplot(df_review, aes(fecha, ppu, colour = marca)) + 
#   geom_point()
# dfplot1

# todos los nombres de marcas:
marcas_2011_2018 <- fecha_marca_sum %>% dplyr::summarise(
  count = n(),
  unique = n_distinct(marca),
  mean_ppu = mean(prom_ppu), sd_ppu = sd(sd_ppu) )

# Mayor presencia en cierto periodo
marcas_en_ciudades_201912 <- filter(fecha_marca_sum, fecha=="2019-11-01")
marcas_10mas <- marcas_en_ciudades_201912 %>%  filter(count>=10) %>% select(marca) 

# brand names:
marcasPrincipales_Nombres <- marcas_10mas$marca
marcas_2011_2018_Nombres <- marcas_2011_2018$marca
marcas_2011_2018_OtrosNombres <- marcas_2011_2018_Nombres[!(marcas_2011_2018_Nombres %in% marcasPrincipales_Nombres)]
marcas_2011_2018_OtrosNombres


# Otras marcas
# marcas_mayorpresencia201912
OtrasMarcas <- fecha_marca_sum  %>% 
  filter(marca %in% marcas_2011_2018_OtrosNombres)


# Names Otras: principales
marcas_tipo4 =  c("BAHREIN", "BARONET", "BOHEMIOS", "DALTON", "DONTABAKO","GARAÑON",
                  "L&M","LAREDO","LM BARONET","RGD", "RODEO", "ROMA","SCENIC 101", "SENECA")
marcas_tipo1 = c("DUNHILL BLONDE","SALEM","VICEROY")
marcas_tipo2 = c("FAROS", "FIESTA","KENT")
marcas_tipo3 = c("ALAS","FORTUNA","MURATTI","WINSTON")




# Graficas para comparar:
# por tipos
names_prin7_otros_tipo4 <- c(marcasPrincipales_Nombres, marcas_tipo4)
to_graph <- filter(fecha_marca_sum,marca %in% names_prin7_otros_tipo4)
tipo4_ppu_plot = ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()
pdf('resultados/doc/ppu_prin7_otros4.pdf', height=8,width=12)
# gr'afico con las otras marcas
tipo4_ppu_plot
dev.off() 

jpeg('resultados/doc/ppu_prin7_otros4.jpg', height=480,width=600)
tipo4_ppu_plot
dev.off() 


# por tipos: 3
names_prin7_otros_tipo3 <- c(marcasPrincipales_Nombres, marcas_tipo3)
to_graph <- filter(fecha_marca_sum,marca %in% names_prin7_otros_tipo3)
tipo3_ppu_plot = ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()
pdf('resultados/doc/ppu_prin7_otros3.pdf', height=12,width=8)
# gr'afico con las otras marcas
tipo3_ppu_plot
dev.off() 

jpeg('resultados/doc/ppu_prin7_otros3.jpg', height=480,width=600)
tipo3_ppu_plot
dev.off() 

# por tipos: 2
names_prin7_otros_tipo2 <- c(marcasPrincipales_Nombres, marcas_tipo2)
to_graph <- filter(fecha_marca_sum,marca %in% names_prin7_otros_tipo2)
tipo2_ppu_plot = ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()
pdf('resultados/doc/ppu_prin7_otros2.pdf', height=12,width=8)
# gr'afico con las otras marcas
tipo2_ppu_plot
dev.off() 

jpeg('resultados/doc/ppu_prin7_otros2.jpg', height=480,width=600)
tipo2_ppu_plot
dev.off() 


# por tipos: 1
names_prin7_otros_tipo1 <- c(marcasPrincipales_Nombres, marcas_tipo1)
to_graph <- filter(fecha_marca_sum,marca %in% names_prin7_otros_tipo1)
tipo1_ppu_plot = ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()
pdf('resultados/doc/ppu_prin7_otros1.pdf', height=12,width=8)
# gr'afico con las otras marcas
tipo1_ppu_plot
dev.off() 

jpeg('resultados/doc/ppu_prin7_otros1.jpg', height=480,width=600)
tipo1_ppu_plot
dev.off() 


# por marca
names7_1otro <- c(marcasPrincipales_Nombres, "ALAS")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()


#names7_1otro <- c(marcasPrincipales_Nombres,"ALAS")
names7_1otro <- c(marcasPrincipales_Nombres,"BAHREIN")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"BARONET")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"BOHEMIOS")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"DALTON")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"DONTABAKO")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"DUNHILL BLONDE")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"FAROS")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"FIESTA")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"FORTUNA")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"GARAÑON")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"KENT")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"L&M")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"LAREDO")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"LM BARONET")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"MURATTI")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"RGD")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"RODEO")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"ROMA")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"SALEM")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"SCENIC 101")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"SENECA")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"VICEROY")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()

names7_1otro <- c(marcasPrincipales_Nombres,"WINSTON")
to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()


# # Otra marca + nombres de las marcas con mayor presencia:
# listofnames <- list()
# marcas_2011_2018_OtrosNombres
# for (i in 1:24) {
#   #print(marcas_2011_2018_OtrosNombres[i])
#   name <- paste0("df",marcas_2011_2018_OtrosNombres[i])
#   print(name)
#   names7_1otro <- c(marcasPrincipales_Nombres, marcas_2011_2018_OtrosNombres[i])
#   print(names7_1otro)
#   name <- filter(fecha_marca_sum,marca %in% names7_1otro)
# }
#   
#   
# for (x in marcas_2011_2018_OtrosNombres) {
#   print(marcas_2011_2018_OtrosNombres)
#   names7_1otro <- c(marcasPrincipales_Nombres, x)
#   to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
#   compare_graph <- ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
#     geom_point()
#   compare_graph
#   #df<- data.frame(json_data$resultSets[1, "rowSet"])
#   #names(df)<-unlist(json_data$resultSets[1,"headers"])
#   #names(to_graph)<-unlist(json_data$resultSets[1,"headers"])
#   readline(prompt="Press [enter] to continue")
#   #listofdfs[[x]] <- to_graph # save your dataframes into the list
#   
# } 



#ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
#  geom_point()
# ALAS a tipo 3 (bajo)  

# # compare each "other" with 
# str(fecha_marca_sum)
# to_graph <- filter(fecha_marca_sum,marca==c("MARLBORO","ALAS"))
# ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
#   geom_point()



#