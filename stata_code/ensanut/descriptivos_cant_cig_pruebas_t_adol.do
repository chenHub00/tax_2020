* sin separar adultos de adolescentes
* con pruebas de medias:
* https://stats.idre.ucla.edu/stata/faq/how-can-i-do-a-t-test-with-survey-data/

do stata_code/ensanut/dirEnsanut.do

capture log close
log using $resultados/pruebas_t_adul.log, replace


************************************************************DESCRIPTIVOS********************************************************
set more off


/* 2018 -------------
use "$datos/2018/tabla_adol_adul.dta", clear*/
* 2018-2020
use "$datos/2020/adol_18_20.dta", clear

svyset [pweight=factor], psu(upm_dis) strata(est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
gen insample = (grupedad_comp  <6 & gr_educ < 5)

/*------------------------------------------
sin distinguir adolescente / adulto
------------------------------------------*/
global var_desc "cant_cig"



foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"

	foreach vartab of varlist sexo grupedad_comp gr_educ nse5f poblacion  {
	    tabulate `vartab' periodo if insample == 1  &  `var_fum' == 1 [w=factor], sum(`var_fum') nost 
		su `vartab' if insample == 1 &  `var_fum' == 1
		local r_max = r(max)
		local r_min = r(min)
		foreach value of numlist `r_min'/`r_max' {
			di "tipo de fumador: `var_fum'"
			di "valor de `vartab': `value'"
			svy, subpop(if insample == 1 & `vartab' == `value' &  `var_fum' == 1): mean $var_desc, over(periodo) 
			svy, subpop(if insample == 1 & `vartab' == `value' &  `var_fum' == 1): mean $var_desc, over(periodo) coeflegend
			if (colsof(e(b)) == 2) ///
			{
				test  _b[c.$var_desc@2018bn.periodo] = _b[c.$var_desc@2020.periodo]
			} 
		}

	}	
}
log close

*svy, subpop(if insample == 1 & gr_educ == 4 &  fumador_diario == 1): mean $var_desc, over(periodo) 

*use "$datos/2020/adol_18_20.dta", clear
/*
foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"
	svy, subpop(if insample == 1 & `var_fum' == 1): mean $var_desc, over(periodo) 
	*svy: mean $var_desc if insample == 1 & `var_fum' == 1, over(periodo) // los errores estándar son diferentes
	svy, subpop(if insample == 1 & `var_fum' == 1): mean $var_desc, over(periodo) coeflegend
*		svy: mean $var_desc if  `var_fum' == 1, over(periodo)  coeflegend // los errores estándar son diferentes
*	svy: mean $var_desc if  `var_fum' == 1, over(periodo) coeflegend
	test _b[c.$var_desc@2018bn.periodo] = _b[c.$var_desc@2020.periodo]
}
