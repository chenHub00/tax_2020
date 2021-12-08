
do stata_code/ensanut/0_dirEnsanut.do

capture log close
log using $resultados/descriptivos_cant_cig_adol.log, replace

global var_desc "cant_cig"
************************************************************DESCRIPTIVOS********************************************************
set more off

/* 2018 -------------*/
use "$datos/2018/tabla_adol_fin.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_dis) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
gen insample = (grupedad_comp  <6 & gr_educ < 5)

/* adolescente y adulto*/
	
	*antes 15-nov-21: sexo edad_gr3 ingr_gr educ_gr3
	*ingr_gr
foreach var_fum of varlist fumador fumador_diario  fumador_ocasional {
	di "tipo de fumador: `var_fum'"    
	foreach vartab of varlist sexo grupedad_comp  gr_educ nse5f poblacion {
	    di "variable de agrupacion: vartab `vartab'"
		tabulate `vartab' `var_fum' if insample == 1 [w=factor], sum($var_desc) nofreq nost noobs
	}
}

/* 2020 -------------*/
use "$datos/2020/tabla_adol_fin.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
gen insample = (grupedad_comp  <6 & gr_educ < 5)

	*antes 15-nov-21: sexo edad_gr3 ingr_gr educ_gr3
	* ingr_gr
foreach var_fum of varlist fumador fumador_diario  fumador_ocasional {
	di "tipo de fumador: `var_fum'"    
	foreach vartab of varlist sexo grupedad_comp  gr_educ nse5f poblacion {
	    di "variable de agrupacion: vartab `vartab'"
		tabulate `vartab' `var_fum' if insample == 1 [w=factor], sum($var_desc) nofreq nost noobs
	}
}

log close

