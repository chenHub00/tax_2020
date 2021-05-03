
use  datos\table11_principales7.dta, clear
drop day fecha
ta marca2, sum(ppu)

collapse (mean) pzas pp ppu (sd) sd_pzas = pzas sd_pp = pp sd_ppu=ppu, ///
		by(year month cve_ciudad marca2)

do stata_code/marca2.do

merge m:1 year month using datos\precios_indices.dta, gen(m_df_p)
keep if m_ == 3

ta tipo, su(ppu)

merge m:1 year month cve_ciudad using datos\pp_lt_cerveza11_.dta, gen(m_otro_precio)
 
gen l_ppu = log(ppu)

gen y2020 = year==2020
gen l_ppu_y2020=y2020*l_ppu 

gen ym_y2020=y2020*ym 

do stata_code/marca_marca2.do

save datos\tpCiudad2.dta, replace
export excel using "datos\tpCiudad2.xlsx", replace
