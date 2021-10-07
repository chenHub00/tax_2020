# Dentro de clean02.R
# después de cálculo de
# fecha_marca_sum (línea 37)
# se usa df_review

# objetos previos que son utiles:
load("datos/prelim/de_inpc/df_review.RData")
summary(df_review)

# promedios por ciudad, una observación por periodo
load("datos/prelim/de_inpc/fecha_marca_sum.RData")
summary(fecha_marca_sum)

# UNA GRAFICA SIMILAR A LA SIGUIENTE (Clean01.R) para 
# sólo con las 7 principales y la que se quiere considerar
#plot each "other brand" with the main 7.
dfplot1 = ggplot(df_review, aes(fecha, ppu, colour = marca)) + 
  geom_point()
dfplot1

# todos los nombres de marcas:
marcas_2011_2018 <- fecha_marca_sum %>% dplyr::summarise(
  count = n(),
  unique = n_distinct(marca),
  mean_ppu = mean(prom_ppu), sd_ppu = sd(sd_ppu) )

# brand names:
marcasPrincipales_Nombres <- marcas_10mas$marca
marcas_2011_2018_Nombres <- marcas_2011_2018$marca
marcas_2011_2018_OtrosNombres <- marcas_2011_2018_Nombres[!(marcas_2011_2018_Nombres %in% marcasPrincipales_Nombres)]
marcas_2011_2018_OtrosNombres


# Otras marcas
# marcas_mayorpresencia201912
OtrasMarcas <- fecha_marca_sum  %>% 
  filter(marca %in% marcas_2011_2018_OtrosNombres)


# Otra marca + nombres de las marcas con mayor presencia:
for (x in marcas_2011_2018_OtrosNombres) {
  print(marcas_2011_2018_OtrosNombres)
  names7_1otro <- c(marcasPrincipales_Nombres, x)
  paste0("to_grap", x,"") <- names7_1otro
} 

to_graph <- filter(fecha_marca_sum,marca %in% names7_1otro)
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()


# compare each "other" with 
str(fecha_marca_sum)
to_graph <- filter(fecha_marca_sum,marca==c("MARLBORO","ALAS"))
ggplot(to_graph, aes(fecha, prom_ppu, colour = marca)) + 
  geom_point()



#