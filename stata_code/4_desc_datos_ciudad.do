
capture log close
log using resultados/desc_datos_ciudad.log, replace

use datos\tpCiudad.dta, clear

ta cve_ciudad marca

* en algunas ciudades hay presencia de m'as marcas
* la definici'on de este grupo de marcas es 
* con base en la presencia de datos para al menos 10 ciudades
* en un periodo espec'ifico (diciembre 2019)

* cuantas 
* (y cuales) ciudades / marcas 
* coinciden con informaci'on 
* de los 120 periodos de an'alisis

* 
use datos\df_m.dta, clear

ta cve_ciudad n_pzas

* en la ciudad 1 hay 6 - 7 marcas
* sólo unas cuantas ciudades están sólo con una marca
* e.g. la ciudad 18 tiene menos 
* 

use datos\df_x.dta, clear

ta n_pzas marca 

* por marcas, 
* la que tiene menos presencia es Lucky con 35 observaciones en 
* solo una ciudad 
* se puede considerar dejar fuera esta marca, 
* sin embargo Lucky "arrastró" a Pall Mall
* por lo que si se considero que Pall Mall y Lucky se 
* consideren en estimaciones SUR
* 

		
log close
