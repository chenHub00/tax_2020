
use  datos\table11_principales7.dta, clear
drop day fecha

/*preserve
collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu, ///
		by(year month cve_ciudad marca2)
restore
*/
collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu, ///
		by(year month cve_ciudad marca)

do stata_code/marca.do

merge m:1 year month using datos\precios_indices.dta, gen(m_df_p)
keep if m_ == 3

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
export excel using "datos\tpCiudad.xlsx", replace
 
