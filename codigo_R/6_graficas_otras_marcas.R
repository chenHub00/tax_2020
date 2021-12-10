#https://www.r-graph-gallery.com/239-custom-layout-legend-ggplot2.html

dfplot2 = ggplot(principales7, aes(fecha, prom_ppu, colour =factor(marca), shape = factor(vs) ) ) 
#para marcar de otra manera "otras marcas"  

#https://rstudio-pubs-static.s3.amazonaws.com/7953_4e3efd5b9415444ca065b1167862c349.html

library(ggthemes)
# prueba
lines_types=c("twodash", "dotted","dashed", "dotted","dashed","dashed", 
              "dotted","twodash", "dotted","twodash", "dashed","dashed", 
              "dashed","dashed", "dotted","twodash", "dotted","twodash", 
              "dotted")
shapes_types=c(3, 6, 1,8, 1, 1,
            9,11,3,6,8,1,
            1,1,9,11,3,6,
            8)
# MISMA COLUMNA
#https://r-charts.com/color-palettes/#discrete
# paletteer_d("colorBlindness::paletteMartin") 
color_types=c('#920000','#E69F00', "gray",'#DB6D00',"gray", "gray",
              '#24FF24','#6DB6FF', '#56B4E9', '#920000',"gray", "gray",
              "gray","gray", '#FF6DB6','#006DDB','#490092', '#009292', 
              '#004949')
tipo4_ppu_plot = ggplot(to_graph, aes(fecha, prom_ppu, colour = factor(marca),shape = otros)) +
#tipo4_ppu_plot = ggplot(to_graph, aes(fecha, prom_ppu, colour = factor(marca),shape = marca)) + 
#tipo4_ppu_plot = ggplot(to_graph, aes(fecha, prom_ppu, colour = factor(marca))) + 
  geom_line(aes(linetype=otros, color=marca))+
  labs(x = "Periodo", y = "Pesos corrientes", color = "Marca\n") +
  theme_light()+
  scale_linetype_manual(values=lines_types)+
     scale_shape_manual(values=shapes_types)+
 #scale_shape_manual(values=c(0,3))+
 scale_color_manual(values=color_types)+
  geom_point(size=1)
tipo4_ppu_plot



tipo4_ppu_plot = ggplot(to_graph, aes(fecha, prom_ppu, colour = factor(marca),shape = otros )) + 
  labs(x = "Periodo", y = "Pesos corrientes", color = "Marca\n") +
  theme_bw()+
  geom_line()+
  geom_point(size=1)
tipo4_ppu_plot


# SEPARADAS: wide

# Saving on object in RData format
save(to_graph, file = "datos/prelim/de_inpc/to_graph.RData")
require(foreign)
write.dta(to_graph, "datos/prelim/de_inpc/to_graph.dta")
write.csv(to_graph,"datos/prelim/de_inpc/to_graph.csv", row.names = FALSE)
# reshape in stata

library(readxl)
#to_graph_wide<-read_xlsx("datos/prelim/de_inpc/to_graph_wide_renamed.xlsx")

tipo4_ppu_plot = ggplot(to_graph_wide, aes(x=ym)) + 
  labs(x = "Periodo", y = "Pesos corrientes")+
  geom_line(aes(y = Benson), color = "gray",linetype="dashed",size=1.5) + 
  geom_line(aes(y = Camel), color = "gray",linetype="twodash") + 
  geom_line(aes(y = Chesterfield), color = "darkred") + 
  geom_line(aes(y = Lucky), color = "darkred") + 
  geom_line(aes(y = Marlboro), color = "gray") + 
  geom_line(aes(y = Montana), color = "darkred") + 
  geom_line(aes(y = PallMall), color = "darkred") + 
  geom_line(aes(y = Bahrein), color="steelblue", 
            linetype="twodash") 

tipo4_ppu_plot

# https://r-charts.com/ggplot2/themes/
#install.packages("hrbrthemes")
library(hrbrthemes)


#
# install.packages("GGally")
library(GGally)
library(dplyr)

# Data set is provided by R natively
data <- iris

# Plot
data %>%
  arrange(desc(Species)) %>%
  ggparcoord(
    columns = 1:4, groupColumn = 5, order = "anyClass",
    showPoints = TRUE, 
    title = "Original",
    alphaLines = 1
  ) + 
  scale_color_manual(values=c( "#69b3a2", "#E8E8E8", "#E8E8E8") ) +
  theme_ipsum()+
  theme(
    legend.position="Default",
    plot.title = element_text(size=10)
  ) +
  xlab("")

# theme_ipsum() not found, instead of _gray()
# 

# Data Reshape:
#https://stats.idre.ucla.edu/r/faq/how-can-i-reshape-my-data-in-r/
hsb2 <- read.table('https://stats.idre.ucla.edu/stat/r/faq/hsb2.csv', header=T, sep=",")
hsb2[1:10,]

l <- reshape(hsb2, 
             varying = c("read", "write", "math", "science", "socst"), 
             v.names = "score",
             timevar = "subj", 
             times = c("read", "write", "math", "science", "socst"), 
             new.row.names = 1:1000,
             direction = "long")

l.sort <- l[order(l$id),]
l.sort[1:10,]

# 

tg <- reshape(l_tg, 
varying = marcas_2011_2018_Nombres, 
v.names = "prom_ppu",
timevar = "fecha", 
times = marcas_2011_2018_Nombres, 
new.row.names = 1:1000,
direction = "long")


## Long to wide

w <- reshape(l.sort, 
             timevar = "subj",
             idvar = c("id", "female", "race", "ses", "schtyp", "prog"),
             direction = "wide")

w[1:10,]


## Long to wide: to_graph

w_tg <- reshape(to_graph, 
             timevar = "fecha",
             idvar = c("count"),
             direction = "wide")

w_tg[1:10,]


# https://www.datanovia.com/en/blog/how-to-create-a-ggplot-with-multiple-lines/
library(ggplot2)
theme_set(theme_minimal())
head(economics)
#Basic line plot
ggplot(data = economics, aes(x = date, y = psavert))+
  geom_line()

# plot with multiple lines
ggplot(economics, aes(x=date)) + 
  geom_line(aes(y = psavert), color = "darkred") + 
  geom_line(aes(y = uempmed), color="steelblue", 
            linetype="twodash") 

# use tidyverse
library("tidyverse")
df <- economics %>%
  select(date, psavert, uempmed) %>%
  gather(key = "variable", value = "value", -date)
head(df)
ggplot(df, aes(x = date, y = value)) + 
  geom_line(aes(color = variable, linetype = variable)) + 
  scale_color_manual(values = c("darkred", "steelblue"))

# http://www.sthda.com/english/articles/32-r-graphics-essentials/128-plot-time-series-data-using-ggplot

# line types
#http://www.sthda.com/english/wiki/ggplot2-line-types-how-to-change-line-types-of-a-graph-in-r-software

ggplot(to_graph_wide, aes(x=ym)) + 
  geom_line(aes(y = Camel), color = "darkred") + 
  geom_line(aes(y = Chesterfield), color="steelblue", 
            linetype="twodash") 
