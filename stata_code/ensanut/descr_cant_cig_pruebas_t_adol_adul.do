* sin separar adultos de adolescentes
* con pruebas de medias:
* https://stats.idre.ucla.edu/stata/faq/how-can-i-do-a-t-test-with-survey-data/

capture log close
log using resultados/ensanut/pruebas_t_adol_adul.log, replace

do stata_code/ensanut/dirEnsanut.do

************************************************************DESCRIPTIVOS********************************************************
set more off


/* 2018 -------------
use "$datos/2018/tabla_adol_adul.dta", clear*/
* 2018-2020
use "$datos/2020/adol_adul_18_20.dta", clear

svyset [pweight=factor], psu(upm_dis) strata(est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
gen insample = (grupedad_comp  <6 & gr_educ < 5)

/*------------------------------------------
sin distinguir adolescente / adulto
------------------------------------------*/
global var_desc "cant_cig"

foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"
	
	foreach vartab of varlist  sexo grupedad_comp gr_educ poblacion {
	    tabulate `vartab' periodo if insample == 1  &  `var_fum' == 1 [w=factor], sum(`var_fum') nost 
		su `vartab' if insample == 1 &  `var_fum' == 1
		local r_max = r(max)
		local r_min = r(min)
		foreach value of numlist `r_min'/`r_max' {
			di "valor de `vartab': `value'"
			svy, subpop(if insample == 1 & `vartab' == `value' &  `var_fum' == 1): mean $var_desc, over(periodo) 
			svy, subpop(if insample == 1 & `vartab' == `value' &  `var_fum' == 1): mean $var_desc, over(periodo) coeflegend
			test  _b[c.$var_desc@2018bn.periodo]=_b[c.$var_desc@2020.periodo]

		}

	}	
}

foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"
	svy, subpop(if insample == 1 &  `var_fum' == 1): mean $var_desc, over(periodo) 
	svy, subpop(if insample == 1 &  `var_fum' == 1): mean $var_desc, over(periodo) coeflegend
	test  _b[c.$var_desc@2018bn.periodo]=_b[c.$var_desc@2020.periodo]
}

log close


*fumador fumador_diario fumador_ocasional 
foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	
*	local var_fum = "fumador_ocasional" 
	di "tipo de fumador: `var_fum'"

	foreach vartab of varlist sexo grupedad_comp gr_educ nse5f poblacion  {
		putexcel set resultados\ensanut\tests_adol_adul`var_fum'.xlsx, sheet(`vartab') modify
		putexcel (a1) = "`vartab'" 
		putexcel (b1) = "r(drop)" 
		putexcel (c1) = "r(df_r)" 
		putexcel (d1) = "r(F)" 
		putexcel (e1) = "r(df)" 
		putexcel (f1) = "r(p)" 

	    tabulate `vartab' periodo if insample == 1  &  `var_fum' == 1 [w=factor], sum(`var_fum') nost 
		su `vartab' if insample == 1 &  `var_fum' == 1
		local r_max = r(max)
		local r_min = r(min)
		foreach value of numlist `r_min'/`r_max' {
			di "tipo de fumador: `var_fum'"
			di "valor de `vartab': `value'"
			svy, subpop(if insample == 1 & `vartab' == `value' &  `var_fum' == 1): mean $var_desc, over(periodo) 
			svy, subpop(if insample == 1 & `vartab' == `value' &  `var_fum' == 1): mean $var_desc, over(periodo) coeflegend
			if (colsof(e(b)) == 2) {
				test  _b[c.$var_desc@2018bn.periodo] = _b[c.$var_desc@2020.periodo]
				local num_file = 1+`value'
			putexcel (A`num_file') = "`value'"
			putexcel (B`num_file') = rscalars, colwise overwritefmt
			if (0.05< r(p) <= .10) {
				putexcel (G`num_file') = "*"
			}
			else if (.01<=r(p) <= .05) {
				putexcel (G`num_file') = "**"
			}
			else if (r(p) <= .01) {
				putexcel (G`num_file') = "***"
			}

			} 
		}

	}	
}

/* TOTALES */

foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	putexcel set resultados\ensanut\tests_adol_adul`var_fum'.xlsx, sheet("TOTAL") modify
	putexcel (a1) = "`vartab'" 
	putexcel (b1) = "r(drop)" 
	putexcel (c1) = "r(df_r)" 
	putexcel (d1) = "r(F)" 
	putexcel (e1) = "r(df)" 
	putexcel (f1) = "r(p)" 
	
	di "tipo de fumador: `var_fum'"
	svy, subpop(if insample == 1 &  `var_fum' == 1): mean $var_desc, over(periodo) 
	svy, subpop(if insample == 1 &  `var_fum' == 1): mean $var_desc, over(periodo) coeflegend
	if (colsof(e(b)) == 2) {
		test  _b[c.$var_desc@2018bn.periodo] = _b[c.$var_desc@2020.periodo]
		local num_file = 1+`value'
		putexcel (A`num_file') = "`value'"
		putexcel (B`num_file') = rscalars, colwise overwritefmt
		if (0.05< r(p) <= .10) {
			putexcel (G`num_file') = "*"
		}
		else if (.01<=r(p) <= .05) {
			putexcel (G`num_file') = "**"
		}
		else if (r(p) <= .01) {
			putexcel (G`num_file') = "***"
		}

} 
