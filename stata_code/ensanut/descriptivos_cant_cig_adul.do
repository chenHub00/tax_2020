
do stata_code/ensanut/dirEnsanut.do

capture log close
log using $resultados/descriptivos_cant_cig_adul.log, replace

global var_desc "cant_cig"
************************************************************DESCRIPTIVOS********************************************************
set more off

/* 2018 -------------*/
use "$datos/2018/tabla_adul_fin.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_dis) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
keep if grupedad_comp  <6
*keep if ingr_gr  <6
keep if gr_educ < 5

/* adolescente y adulto*/
	
	*antes 15-nov-21: sexo edad_gr3 ingr_gr educ_gr3
	*ingr_gr
foreach var_fum of varlist fumador fumador_diario  fumador_ocasional {
	di "tipo de fumador: `var_fum'"    
	foreach vartab of varlist sexo grupedad_comp  gr_educ poblacion {
	    di "variable de agrupacion: vartab `vartab'"
		tabulate `vartab' `var_fum'  [w=factor], sum($var_desc) nofreq nost noobs
	}
}

/* 2020 -------------*/
use "$datos/2020/tabla_adul_fin.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
keep if grupedad_comp  <6
*keep if ingr_gr  <6
keep if gr_educ < 5


	*antes 15-nov-21: sexo edad_gr3 ingr_gr educ_gr3
	* ingr_gr
foreach var_fum of varlist fumador fumador_diario  fumador_ocasional {
	di "tipo de fumador: `var_fum'"    
	foreach vartab of varlist sexo grupedad_comp  gr_educ poblacion {
	    di "variable de agrupacion: vartab `vartab'"
		tabulate `vartab' `var_fum'  [w=factor], sum($var_desc) nofreq nost noobs
	}
}

log close

