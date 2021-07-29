// se basa en inicial_marcas.do
// las diferencias est'an respecto a la definici'on de la 
// variable marca2, 
// la intenci'on era mantener los dos tipos de clasificaci'on
// para comparar resultados, sin embargo, es aparente que algunas marcas coinciden 
// por lo que ser'ia necesario hacer un criterio para separar las clasificaciones
// 
capture log close
log using resultados/inicial_marcas2.do, replace

use  datos/prelim/de_inpc/table11_principales7.dta, clear
drop day fecha
ta marca2, sum(ppu)

ta year marca
ta year marca2
// observaciones perdidas al hacer collapse?
//  Antes 1,147 en 2021 
preserve
collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu, ///
		by(year month cve_ciudad marca)
ta year marca
// observaciones perdidas al hacer collapse?
// Despu'es 808 en 2021 
restore

collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu, ///
		by(year month cve_ciudad marca2)
ta year marca
// observaciones perdidas al hacer collapse?
// Despu'es 808 en 2021 
// no cambia al hacer collapse por marca2
do stata_code/marca2.do
// marca se puede obtener a partir de marca2, 

ta year marca2

merge m:1 year month using datos/prelim/de_inpc/precios_indices.dta, gen(m_df_p)
keep if m_ == 3

ta tipo, su(ppu)

merge m:1 year month cve_ciudad using datos\pp_lt_cerveza11_.dta, gen(m_otro_precio)
 
gen l_ppu = log(ppu)

gen y2020 = year==2020
gen l_ppu_y2020=y2020*l_ppu 

gen ym_y2020=y2020*ym 

gen y2021 = year==2021
gen l_ppu_y2021=y2021*l_ppu 

do stata_code/marca_marca2.do

// etiquetas
label variable m1 "jan"
label variable m1_20 "jan20"
label variable m1_21 "jan21"

rename m1 jan
rename m1_20 jan20
rename m1_21 jan21

save datos/prelim/de_inpc/tpCiudad2.dta, replace
export excel using "datos/prelim/de_inpc/tpCiudad2.xlsx", replace

log close
