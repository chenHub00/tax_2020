* Objetivo: 
* Cargar los datos de precios y de las principales marcas presentes en el pais 
* Datos (input):
* Resultado (output):
* 
* https://www.inegi.org.mx/sistemas/bie/
* indice de precios al productor : sin petroleo
* indice de precios al consumidor

capture log close 
log using resultados\inicial.log, replace

import excel "datos\precios_indices.xlsx", firstrow clear
* Agregar informacion de periodo
gen year= real(substr(Periodo,1,4))
gen month= real(substr(Periodo,6,2))

drop D E

save datos\precios_indices.dta, replace

* C:\Users\vicen\OneDrive\Documentos\colabs\salud\tabaco\datos_inpc\
/* 
* todos los precios, corroborar fechas
import delimited df_review.csv, clear 

save datos\df_review.dta, replace


use  datos\df_review.dta, clear
drop day fecha
*/
import delimited datos/csv/table11_principales7.csv, clear 

save datos\table11_principales7.dta, replace

use  datos\table11_principales7.dta, clear
drop day fecha

/*rename tabla2011_cve_ciudad cve_ciudad 
rename tabla2011_pp pp
rename tabla2011_pzas pzas */

collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu, ///
		by(year month cve_ciudad marca)


merge m:1 year month using datos\precios_indices.dta, gen(m_df_p)
keep if m_ == 3

 // establecer el panel
 gen ym = ym(year,month)
 format ym %tm
 rename marca marca_str
 encode marca, gen(marca)

 gen m1 = month == 1

 // variables para la regresion
gen m1_20 = m1 == 1 & year == 2020

ta marca, sum(ppu)
// tipo_marca
// chesterfield + delicados?
// grupo 1
gen tipo = 1 if marca == 1 | marca == 2 | marca == 5
replace tipo = 2 if marca == 4 | marca == 7
replace tipo = 3 if marca == 3 | marca == 6

label define tipo 1 "premium" 2 "medio" 3 "bajo"
label values tipo tipo

ta tipo, su(ppu)

merge m:1 year month cve_ciudad using datos\pp_lt_cerveza11_.dta, gen(m_otro_precio)
/* ya hay datos hasta diciembre 2020
. ta month if m_otr == 2

      Month |      Freq.     Percent        Cum.
------------+-----------------------------------
         11 |         55       50.00       50.00
         12 |         55       50.00      100.00
------------+-----------------------------------
      Total |        110      100.00

. ta year if m_otr == 2
*/

*xtset cve_ciudad ym
 
gen l_ppu = log(ppu)

gen y2020 = year==2020
gen l_ppu_y2020=y2020*l_ppu 

gen ym_y2020=y2020*ym 


save datos\tpCiudad.dta, replace
* 
use datos\tpCiudad.dta, clear

collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu ///
		(count) n_pzas = pzas n_pp=pp n_ppu=ppu , by(year month marca)

// establecer el panel
 gen ym = ym(year,month)
 format ym %tm

xtset marca ym

 // variables para la regresion
gen m1 = month == 1
label variable m1 "enero_2020"

merge m:1 year month using datos\precios_indices.dta, gen(m_df_p)
keep if m_ == 3
drop m_
 
save datos\df_x.dta, replace


use datos\tpCiudad.dta, clear
collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu ///
		(count) n_pzas = pzas n_pp=pp n_ppu=ppu , by(year month cve_ciudad)

save datos\df_m.dta, replace

		
capture log close
