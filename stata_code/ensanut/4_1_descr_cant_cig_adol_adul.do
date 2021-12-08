
do stata_code/ensanut/0_dirEnsanut.do

/* 2018 -------------*/
use "$datos/2020/adol_adul_18_20.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
gen insample = (grupedad_comp  <6 & gr_educ < 5)

global var_desc "cant_cig"
************************************************************DESCRIPTIVOS********************************************************
set more off

/* 2018*/	
capture log close
log using resultados/ensanut/descr_cant_cig_adol_adul2018.log, replace

foreach var_fum of varlist fumador fumador_diario  fumador_ocasional {
	di "tipo de fumador: `var_fum'"    
	foreach vartab of varlist sexo grupedad_comp  gr_educ nse5f poblacion {
	    di "variable de agrupacion: vartab `vartab'"
		tabulate `vartab' `var_fum' if insample == 1 & periodo ==2018 [w=factor], sum($var_desc) nofreq nost noobs
	}
}

/* 2020*/	
capture log close
log using resultados/ensanut/descr_cant_cig_adol_adul2020.log, replace

foreach var_fum of varlist fumador fumador_diario  fumador_ocasional {
	di "tipo de fumador: `var_fum'"    
	foreach vartab of varlist sexo grupedad_comp  gr_educ nse5f poblacion {
	    di "variable de agrupacion: vartab `vartab'"
		tabulate `vartab' `var_fum' if insample == 1 & periodo ==2020 [w=factor], sum($var_desc) nofreq nost noobs
	}
}


log close



