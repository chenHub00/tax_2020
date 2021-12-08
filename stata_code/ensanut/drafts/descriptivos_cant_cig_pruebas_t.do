* sin separar adultos de adolescentes
* con pruebas de medias:
* https://stats.idre.ucla.edu/stata/faq/how-can-i-do-a-t-test-with-survey-data/

do stata_code/ensanut/0_dirEnsanut.do

capture log close
log using $resultados/descriptivos_cant_cig_pruebas_t.log, replace


************************************************************DESCRIPTIVOS********************************************************
set more off


/* 2018 -------------
use "$datos/2018/tabla_adol_adul.dta", clear*/
* 2018-2020
use "$datos/2020/adol_adul_18_20.dta", clear

svyset [pweight=factor], psu(upm_dis) strata(est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
keep if grupedad_comp  <6
keep if ingr_gr  <6
keep if gr_educ < 5
/*------------------------------------------
sin distinguir adolescente / adulto
------------------------------------------*/
global var_desc "cant_cig"


foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"
	svy: mean $var_desc if  `var_fum' == 1, over(periodo) 
	svy: mean $var_desc if  `var_fum' == 1, over(periodo) coeflegend
	test _b[c.$var_desc@2018bn.periodo] = _b[c.$var_desc@2020.periodo]
}

foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"
	
	foreach vartab of varlist  sexo grupedad_comp ingr_gr gr_educ poblacion {
	    tabulate `vartab' periodo [w=factor], sum(`var_fum') nost 
		su `vartab'
		local r_max = r(max)
		local r_min = r(min)
		foreach value of numlist `r_min'/`r_max' {
			di "valor de `vartab': `value'"
			
			svy: mean $var_desc if `vartab' == `value' &  `var_fum' == 1, over(periodo) 
			svy: mean $var_desc if `vartab' == `value' &  `var_fum' == 1, over(periodo) coeflegend
			test  _b[c.$var_desc@2018bn.periodo]=_b[c.$var_desc@2020.periodo]

		}

	}	
}
log close


/*------------------------------------------
 Por adolescente / adulto 
 ------------------------------------------*/
global var_desc "cant_cig"

foreach var_sum of varlist adulto adolescente {
	di "grupo de edad: `var_sum'"
	foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
		di "tipo de fumador: `var_fum'"
		svy: mean $var_desc if  `var_sum'== 1 &  `var_fum' == 1, over(periodo) 
		svy: mean $var_desc if   `var_sum'== 1 &  `var_fum' == 1, over(periodo) coeflegend
		test _b[c.$var_desc@2018bn.periodo] = _b[c.$var_desc@2020.periodo]
	}
	
*	local `var_sum'="adulto"

	foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
		di "tipo de fumador: `var_fum'"
		
		foreach vartab of varlist  sexo grupedad_comp ingr_gr gr_educ poblacion {
			tabulate `vartab' periodo [w=factor], sum(`var_fum') nost 
			su `vartab'  if `var_sum'== 1  
			local r_max = r(max)
			local r_min = r(min)
			foreach value of numlist `r_min'/`r_max' {
				di "valor de `vartab': `value'"
				
				svy: mean $var_desc if  `var_sum'== 1 &  `vartab' == `value' &  `var_fum' == 1, over(periodo) 
				svy: mean $var_desc if  `var_sum'== 1 & `vartab' == `value' &  `var_fum' == 1, over(periodo) coeflegend
				test  _b[c.$var_desc@2018bn.periodo]=_b[c.$var_desc@2020.periodo]

			}

		}	
	}    
}

log close

/*------------------------------------------
*ANTERIOR
/* Por adolescente / adulto */

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


	foreach vartab of varlist sexo edad_gr3 ingr_gr educ_gr3 {
	
	tabulate sex `vartab' if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs

	tabulate sex `vartab' if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs

		tabulate sex `vartab' if `var_sum'==1 [w=factor], sum($var_desc) nofreq nost noobs
		
	}
	
}
*/
