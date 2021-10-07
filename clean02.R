
# working directory
getwd()
directorio <- "datos/iniciales/"
# 
# queremos las marcas o presentaciones m'as representativas
# considerar las que tienen una presencia mayor en las ciudades

library(tidyverse)
library(dplyr)

load("datos/prelim/de_inpc/df_review.RData")
summary(df_review)

write.csv(df_review,"datos/prelim/de_inpc/df_review.csv", row.names = FALSE)

# tibble format
table11_ <- tibble(df_review)

# ? c'omo usar esta parte?
#df_review %>% count(fecha)

#df_review %>% 
#  group_by(tabla2011_.cve_ciudad) %>% summarise(n=n()).count()
rm(df_review)

#table11_

table11_2 <- 
  select(table11_,fecha,marca,cve_ciudad:pzas,ppu)

# agrupar por marca2 y fecha
por_fecha_marca2 <- 
  group_by(table11_2,marca,fecha)

# editar
fecha_marca_sum <- por_fecha_marca2 %>% dplyr::summarise(
                      count = n(),
                      unique = n_distinct(cve_ciudad),
                      prom_ppu = mean(ppu), sd_ppu = sd(ppu) )

save(fecha_marca_sum, file = "datos/prelim/de_inpc/fecha_marca_sum.RData")

# agrupar las que tienen menor presencia en una misma categoria
# o categorias relacionadas con su precio 
# (respecto a las que tienen menos presencia)
# AD-HOC
marcas_en_ciudades_201912 <- filter(fecha_marca_sum, fecha=="2019-11-01")
# cercano al ultimo mes de 2019, podria ser trimestre?
# son 10 el minimo "count" en CAMEL
# quedan 7 presentaciones
# DELICADOS SON CHESTERFIELD
marcas_10mas <- marcas_en_ciudades_201912 %>%  filter(count>=10) %>% select(marca) 
marcas_menor10 <- marcas_en_ciudades_201912 %>%  filter(count<10) %>% select(marca) 

# marcas_mayorpresencia201912
principales7 <- fecha_marca_sum  %>% 
    filter(marca %in% as.vector(t(marcas_10mas)))

#marcas_menores201912
menores <- fecha_marca_sum  %>% 
  filter(marca %in% (as.vector(t(marcas_menor10))) )

# como etiquetar el resto de las marcas?
# agrupar el resto de las marcas?

# brand names:
marcasPrincipales_Nombres <- marcas_10mas$marca
marcas_2011_2018_Nombres <- marcas_2011_2018$marca
marcas_2011_2018_OtrosNombres <- marcas_2011_2018_Nombres[!(marcas_2011_2018_Nombres %in% marcasPrincipales_Nombres)]
marcas_2011_2018_OtrosNombres

OtrasMarcas <- fecha_marca_sum  %>% 
  filter(marca %in% marcas_2011_2018_OtrosNombres)

# 7 marcas principales
table11_principales7 <- table11_ %>% 
  filter(marca %in% as.vector(t(marcas_10mas)))
#setwd("C:/Users/vicen/Documents/R/tax_ene2020/tax_2020/")
save(table11_principales7, file = "datos/prelim/de_inpc/table11_principales7.RData")
# load("~/R/tax_ene2020/table11_principales7.RData")
write.csv(table11_principales7,"datos/prelim/de_inpc/table11_principales7.csv", row.names = FALSE)

# Otras marcas
table11_Otras <- table11_ %>% 
  filter(marca %in% marcas_2011_2018_OtrosNombres)
save(table11_Otras, file = "datos/prelim/de_inpc/table11_Otras.RData")
write.csv(table11_Otras,"datos/prelim/de_inpc/table11_Otras.csv", row.names = FALSE)

# Saving on object in RData format
save(principales7, file = "datos/prelim/de_inpc/principales7.RData")
save(menores, file = "datos/prelim/de_inpc/menores.RData")
save(OtrasMarcas, file = "datos/prelim/de_inpc/OtrasMarcas.RData")

dfplot2 = ggplot(principales7, aes(fecha, prom_ppu, colour = marca )) + 
  labs(title = "Precios promedio por unidad\n", x = "Periodo", y = "Pesos corrientes", color = "Marca\n") +
  geom_point()
dfplot2 

#pdf("ppu_ciudad_7marcas2011.pdf") 
#jpeg('rplot.jpg')
#jpeg('resultados/doc/prin7_prom_ppu_marcas.jpg')
pdf('resultados/doc/prin7_prom_ppu_marcas.pdf', height=11,width=8.5)
# gr'afico con las principales marcas
dfplot2 
dev.off() 

# Otras
dfplot3 = ggplot(OtrasMarcas, aes(fecha, prom_ppu, colour = marca )) + 
  labs(title = "Precios promedio por unidad\n", x = "Periodo", y = "Pesos corrientes", color = "Marca\n") +
  geom_point()
dfplot3 

pdf('resultados/doc/Otras_prom_ppu_marcas.pdf', height=11,width=8.5)
# gr'afico con las otras marcas
dfplot3 
dev.off() 

#rm(list=ls())

