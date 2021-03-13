
// preeliminar: aproximado a panel balanceado
// ajustes en numero de ciudades
// ajustes en total de marcas
// para algunas especificaciones se considerarian solo ciudades principales
cd "C:\Users\USUARIO\Desktop\tax_2020-master"

capture log close
log using resultados/paneles_promedio.log, replace

use datos\tpCiudad.dta, clear

*gen ciudades_18 = cve_ciudad > 46
drop if cve_ciudad > 46

*gen marca_3 = marca == 3
*drop if marca == 3

collapse (mean) m1 m1_20 INPPsec_nopetro INPCgen m_df_p ppu pp pp_lt_cerveza m_otro_, by(ym marca)

xtset marca ym 

save datos\xt_marca.dta, replace

* xtline ppu // promedios por ciudad

use datos\tpCiudad.dta, clear

*gen ciudades_18 = cve_ciudad > 46
drop if cve_ciudad > 46

*gen marca_3 = marca == 3
*drop if marca == 3

collapse (mean) m1 m1_20 INPPsec_nopetro INPCgen m_df_p ppu pp pp_lt_cerveza m_otro_, by(ym cve_ciudad)

xtset cve_ciudad ym 

save datos\xt_ciudad.dta, replace

xtline ppu

use datos\tpCiudad.dta, clear

drop if cve_ciudad > 46
*drop if marca == 3

*gen l_ppu = log(ppu)
egen gr_marca_ciudad = group(marca cve_ciudad)
xtset gr_marca_ciudad ym 

save datos\panel_marca_ciudad.dta, replace

use datos\panel_marca_ciudad.dta, clear

drop year month Periodo INP* tipo pp_lt_cerveza m_df_p m_otro_precio marca_str

* solo ciudades con 118 observaciones (panel completo)
*egen s_gr_m_ciudad= total(1), by(gr_)
*keep if s_ == 118

gen d_ppu = d.ppu
gen lag_ppu = L.ppu
gen lagd_ppu = L.d.ppu

drop gr_
reshape wide d_ lag_ lagd_ l_* pp ppu pzas sd_*, i(ym cve_ciudad) j(marca) 
* cómo se podría elegir solo las ciudades con mayor número de marcas?
* egen s_gr_m_ciudad= total(1), by(gr_)
* reshape wide l_ pp ppu pzas sd_* cve_ciudad marca, i(ym) j(gr_)

xtset cve_ciudad ym

save datos/wide_complete_panel.dta, replace
* inicial: febrero 2021 tiene 5 marcas 1,2,5,6,7
