# Utiliza los vectores obtenidos en borradorOtros.R
# df: fecha_marca_sum
# vectores: marcas_2011_2018_OtrosNombres
#           marcas_2011_2018_OtrosNombres
# Otras marcas - diferencia con respecto a 7 marcas principales

sink("dif_entre_7principales.txt")
manhattan_dist <- function(a, b){
  dist <- abs(a-b)
  dist <- sum(dist)
  return(dist)
}

distances = matrix(0,7,7)
Avdistances = matrix(0,7,7)
rownames(distances) <- marcasPrincipales_Nombres
colnames(distances) <- marcasPrincipales_Nombres
rownames(Avdistances) <- marcasPrincipales_Nombres
colnames(Avdistances) <- marcasPrincipales_Nombres
for (OtraMarca in marcasPrincipales_Nombres) {
  
  print(OtraMarca)
  for (marca7 in marcasPrincipales_Nombres) {
    
    print(marca7)
    
    # separar los datos para cada marca para unir por fecha
    df_Otramarca = fecha_marca_sum %>% 
      select(fecha,prom_ppu,marca) %>%
      filter(marca==OtraMarca)
    names(df_Otramarca)[names(df_Otramarca)=="marca"] <- "OtraMarca"
    names(df_Otramarca)[names(df_Otramarca)=="prom_ppu"] <- "ppu_OtraMarca"
    
    df_marca7 = fecha_marca_sum %>% 
      select(fecha,prom_ppu,marca) %>%
      filter(marca==marca7)
    names(df_marca7)[names(df_marca7)=="marca"] <- "marca7"
    names(df_marca7)[names(df_marca7)=="prom_ppu"] <- "ppu_marca7"
    
    # left join para solo tener observaciones de fecha de "otra" marca
    df_join <- left_join(df_Otramarca, df_marca7, by=c("fecha"))
    
    Description_result = paste0("Distance between ", OtraMarca, " and principal ", marca7)
    print(Description_result)
    
    dist = manhattan_dist(df_join$ppu_OtraMarca,df_join$ppu_marca7)
    distances[OtraMarca,marca7] <- dist
    Avdistances[OtraMarca,marca7] <- dist/nrow(df_join)
    print(dist)
    print(Avdistances[OtraMarca,marca7])
  }
}

directorioFinal <- "datos/finales/"

write.table(distances, file=paste0(directorioFinal,"distancias7prin.csv"),sep=",")
write.table(Avdistances, file=paste0(directorioFinal,"Avdistances7prin.csv"),sep=",")


sink()


