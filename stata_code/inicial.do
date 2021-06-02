* Objetivo: 
* Cargar los datos de precios y de las principales marcas presentes en el pais 
* Datos (input):
* - indices de precios >
* - precios_indices.xlsx > table11_principales7.dta
* Resultado (output):
* 
* https://www.inegi.org.mx/sistemas/bie/
* indice de precios al productor : sin petroleo
* indice de precios al consumidor
set more off

capture log close 
log using resultados\inicial.log, replace

/*
Otros precios
*/
import excel "datos/iniciales/precios_indices.xlsx", firstrow clear
* Agregar informacion de periodo
gen year= real(substr(Periodo,1,4))
gen month= real(substr(Periodo,6,2))

gen ym = ym(year,month)
format ym %tm

 // variables para la regresion
gen m1 = month == 1
label variable m1 "eneros"
// variables para la regresion
gen m1_20 = m1 == 1 & year == 2020
label variable m1 "enero 2020"

gen m1_21 = m1 == 1 & year == 2021
label variable m1 "enero 2021"

save datos/prelim/de_inpc/precios_indices.dta, replace

/* 
precios de las marcas principales
*/
import delimited datos/prelim/de_inpc/table11_principales7.csv, clear 

save datos/prelim/de_inpc/table11_principales7.dta, replace

use datos/prelim/de_inpc/tpCiudad2.dta, clear

collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu ///
		(count) n_pzas = pzas n_pp=pp n_ppu=ppu , by(year month marca)

// establecer el panel
 gen ym = ym(year,month)
 format ym %tm

xtset marca ym

merge m:1 year month using datos/prelim/de_inpc/precios_indices.dta, gen(m_df_p)
keep if m_ == 3
drop m_
 
save datos/prelim/de_inpc/df_x.dta, replace


use datos/prelim/de_inpc/tpCiudad2.dta, clear
collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu ///
		(count) n_pzas = pzas n_pp=pp n_ppu=ppu , by(year month cve_ciudad)

merge m:1 year month using datos/prelim/de_inpc/precios_indices.dta, gen(m_df_p)
keep if m_ == 3
drop m_

save datos/prelim/de_inpc/df_m.dta, replace

		
capture log close
