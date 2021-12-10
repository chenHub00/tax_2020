
global datos = "datos/encuesta/"
global codigo = "stata_code\encuesta_\"
global resultados = "resultados\encuesta\"

capture log close
log using resultados/logs/reshape_wide_consumo.log, replace
// posible?

use "$datos/wave4_5unbalanced.dta", clear

global v_reshape "consumo sexo edad_gr2 educ_gr2 gr_ingr tax2020 tax2020_sexo tax2020_edad_gr2 tax2020_gr_educ"
	
keep $v_reshape wave id tipo_

egen gr_wave_id = group(wave id)

foreach value of numlist 1 2 3 4 {
preserve 
keep if tipo_ == `value'
	foreach var of varlist $v_reshape gr_wave_id wave id {
		rename `var' `var'_`value'
	}
gen consecutivo = _n
save "$datos/wave4_5unb_`value'.dta", replace
restore
}

use "$datos/wave4_5unb_1.dta", clear

joinby consecutivo using "$datos/wave4_5unb_3.dta", unmatched(both)
rename _merge m1_3
joinby consecutivo using "$datos/wave4_5unb_4.dta", unmatched(both)
rename _merge m1_3_4

joinby consecutivo using "$datos/wave4_5unb_2.dta", unmatched(both)
rename _merge m1_3_4_2

save "$datos/wave4_5unb_wide.dta", replace

log close

use "$datos/wave4_5unb_wide.dta", clear

xtsur (consumo_1 sexo_1 edad_gr2_1 educ_gr2_1 gr_ingr_1 /// 
	tax2020_1 tax2020_sexo_1 tax2020_edad_gr2_1 tax2020_gr_educ_1) ///
	(consumo_2 sexo_2 edad_gr2_2 educ_gr2_2 gr_ingr_2 /// 
	tax2020_2 tax2020_sexo_2 tax2020_edad_gr2_2 tax2020_gr_educ_2)

