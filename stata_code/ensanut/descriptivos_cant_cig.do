
do stata_code/ensanut/dirEnsanut.do

capture log close
log using $resultados/descriptivos_cant_cig.log, replace

global var_desc "cant_cig"
************************************************************DESCRIPTIVOS********************************************************
set more off


/* 2018 -------------*/
use "$datos/2018/tabla_adol_adul.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_dis) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
keep if grupedad_comp  <6
keep if ingr_gr  <6
keep if gr_educ < 5

/* adolescente y adulto*/
foreach var_sum of varlist adolescente adulto {
	
	di "promedio y total: FUMADOR "
	svy: mean $var_desc if  `var_sum'== 1 & fumador == 1
	svy: total $var_desc  if `var_sum' == 1 & fumador == 1
	di "promedio y total: FUMADOR DIARIO"
	svy: mean $var_desc if  `var_sum'== 1 & fumador_diario == 1
	svy: total $var_desc  if `var_sum' == 1 & fumador_diario == 1
	di "promedio y total: FUMADOR ocasional"
	svy: mean $var_desc if  `var_sum'== 1 & fumador_ocasional == 1
	svy: total $var_desc  if `var_sum' == 1 & fumador_ocasional== 1

	di "promedio y total: masculino, FUMADOR"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 1 & fumador == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 1 & fumador == 1
	
	di "promedio y total: masculino, FUMADOR DIARIO"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 1 & fumador_diario == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 1 & fumador_diario== 1
	
	di "promedio y total: masculino, FUMADOR ocasional"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 1 & fumador_ocasional == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 1 & fumador_ocasional == 1

	di "promedio y total: femenino"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 2
	svy: total $var_desc  if `var_sum' == 1 & sexo == 2

	di "promedio y total: masculino, FUMADOR DIARIO"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 2 & fumador_diario == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 2 & fumador_diario== 1
	
	di "promedio y total: masculino, FUMADOR ocasional"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 2 & fumador_ocasional == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 2 & fumador_ocasional == 1

	di "promedio"
*	local var_sum = "adulto"
	tabulate sex fumador if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs
	tabulate sex fumador_diario if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs
	tabulate sex fumador_ocasional if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs

	foreach vartab of varlist fumador fumador_diario  fumador_ocasional {
	    di "tipo de fumador: `var_fum'"    
		    tabulate sex `var_fum' if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs
	}
	
	*antes 15-nov-21: sexo edad_gr3 ingr_gr educ_gr3
	foreach vartab of varlist sexo grupedad_comp ingr_gr gr_educ poblacion {
	    di "variable de agrupacion: vartab `vartab'"
		foreach var_fum of varlist fumador fumador_diario  fumador_ocasional {
		di "tipo de fumador: `var_fum'"    
			tabulate `vartab' `var_fum' if `var_sum'==1  [w=factor], sum($var_desc) nofreq nost noobs
		}
	}
	
}

* collapse 
*gen sum_fumador = fumador*factor
*format %12.0g sum_fumador
*collapse (mean) fumador (sum) sum_fumador if adulto==1 [w=factor], by(sex) 

/* 2020 -------------*/
use "$datos/2020/tabla_adol_adul.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
keep if grupedad_comp  <6
keep if ingr_gr  <6
keep if gr_educ < 5

/* adolescente y adulto*/
foreach var_sum of varlist adolescente adulto {
	di "promedio y total"
	svy: mean $var_desc if  `var_sum'== 1 & fumador == 1
	svy: total $var_desc  if `var_sum' == 1 & fumador == 1

	svy: mean $var_desc if  `var_sum'== 1 & fumador_diario == 1
	svy: total $var_desc  if `var_sum' == 1 & fumador_diario == 1
	
	svy: mean $var_desc if  `var_sum'== 1 & fumador_ocasional == 1
	svy: total $var_desc  if `var_sum' == 1 & fumador_ocasional== 1

	di "promedio y total: masculino, FUMADOR"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 1 & fumador == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 1 & fumador == 1
	
	di "promedio y total: masculino, FUMADOR DIARIO"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 1 & fumador_diario == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 1 & fumador_diario== 1
	
	di "promedio y total: masculino, FUMADOR ocasional"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 1 & fumador_ocasional == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 1 & fumador_ocasional == 1

	di "promedio y total: femenino"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 2
	svy: total $var_desc  if `var_sum' == 1 & sexo == 2

	di "promedio y total: masculino, FUMADOR DIARIO"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 2 & fumador_diario == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 2 & fumador_diario== 1
	
	di "promedio y total: masculino, FUMADOR ocasional"
	svy: mean $var_desc  if `var_sum' == 1 & sexo == 2 & fumador_ocasional == 1
	svy: total $var_desc  if `var_sum' == 1 & sexo == 2 & fumador_ocasional == 1

	di "promedio"
*	local var_sum = "adulto"
	tabulate sex fumador if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs
	tabulate sex fumador_diario if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs
	tabulate sex fumador_ocasional if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs


	*antes 15-nov-21: sexo edad_gr3 ingr_gr educ_gr3
	foreach vartab of varlist sexo grupedad_comp ingr_gr gr_educ poblacion {
	    di "variable de agrupacion: vartab `vartab'"
		foreach var_fum of varlist fumador fumador_diario  fumador_ocasional {
		di "tipo de fumador: `var_fum'"    
			tabulate `vartab' `var_fum' if `var_sum'==1  [w=factor], sum($var_desc) nofreq nost noobs
		}
	}
	
}


log close

