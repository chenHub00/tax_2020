
# working directory
getwd()
#setwd("C:/Users/USUARIO/OneDrive/Documentos/colabs/salud/tabaco/datos_inpc")
#
#setwd("C:/Users/vicen/OneDrive/Documentos/colabs/salud/tabaco/datos_inpc")
directorio <- "C:/Users/vicen/Documents/R/tax_ene2020/"
setwd(directorio)
# 
# queremos las marcas o presentaciones m'as representativas
# considerar las que tienen una presencia mayor en las ciudades

library(tidyverse)
library(dplyr)

#load("df_review.RData")
load("df_review.RData")
summary(df_review)

write.csv(df_review,"df_review.csv", row.names = FALSE)

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
table11_principales7 <- table11_ %>% 
  filter(marca %in% as.vector(t(marcas_10mas)))
setwd("C:/Users/vicen/Documents/R/tax_ene2020/tax_2020/")
save(table11_principales7, file = "datos/table11_principales7.RData")
# load("~/R/tax_ene2020/table11_principales7.RData")
write.csv(table11_principales7,"datos/table11_principales7.csv", row.names = FALSE)

# Saving on object in RData format
save(principales7, file = "datos/principales7.RData")
save(menores, file = "datos/menores.RData")

#pdf("pp_ciudad_7marcasZero.pdf") 
#jpeg('rplot.jpg')

# gr'afico con las principales marcas
ggplot(principales7, aes(fecha, prom_ppu, colour = marca )) + 
  labs(title = "Precios promedio por unidad\n", x = "Periodo", y = "Pesos corrientes", color = "Marca\n") +
#  scale_y_continuous(limits =   c(0,3.5)) +
  geom_point()
#dev.off() 


rm(list=ls())

# ejemplos de instrucciones
result3 <-
  cran %>%
  group_by(package) %>%
  summarize(count = n(),
            unique = n_distinct(ip_id),
            countries = n_distinct(country),
            avg_bytes = mean(size)
  ) %>%
  filter(countries > 60) %>%
  arrange(desc(countries), avg_bytes)

# Print result to console
print(result3)


cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  filter(size_mb <= 0.5) %>%
  arrange(desc(size_mb))
