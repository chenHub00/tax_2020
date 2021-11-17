* no se identifica adolescente o adulto por separado


do stata_code/ensanut/dirEnsanut.do

capture log close
log using $resultados/descriptivos_prevalencia_comparacion.log, replace

**************************DESCRIPTIVOS****************************
set more off


/* 2018 y 2020 */
use "$datos/2020/adol_adul_18_20.dta", clear

svyset [pweight=factor], psu(upm_dis) strata(est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
keep if grupedad_comp  <6
keep if ingr_gr  <6
/*------------------------------------------
sin distinguir adolescente / adulto
------------------------------------------*/
svy: mean fumador, over(periodo)
svy: mean fumador, over(periodo) coeflegend
test _b[c.fumador@2018bn.periodo] =   _b[c.fumador@2020.periodo]
*svy: total fumador , over(periodo) 

foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	svy: mean `var_fum', over(periodo)
	svy: mean `var_fum', over(periodo) coeflegend
	test _b[c.`var_fum'@2018bn.periodo] =   _b[c.`var_fum'@2020.periodo]
}

/*
Sexo
*/
ta sexo periodo
ta sexo periodo, nol
svy: proportion sexo, over(periodo)
foreach value of numlist 1 2 {
	
	svy: mean fumador if sexo == `value', over(periodo) 
	svy: mean fumador if sexo == `value', over(periodo) coeflegend
	test  _b[c.fumador@2018bn.periodo]=_b[c.fumador@2020.periodo]

}

tabulate sex periodo [w=factor], sum(fumador) nost 

/*
Sexo
- tipos de fumador
*/

foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"
	foreach value of numlist 1 2 {
		
		svy: mean `var_fum' if sexo == `value', over(periodo) 
		svy: mean `var_fum' if sexo == `value', over(periodo) coeflegend
		test  _b[c.`var_fum'@2018bn.periodo]=_b[c.`var_fum'@2020.periodo]

	}


tabulate sex periodo [w=factor], sum(`var_fum') nost 
}

/*
variables agrupadas:
- otros tipos de fumador
*/

foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"
	foreach vartab of varlist  sexo grupedad_comp ingr_gr gr_educ poblacion {
	    tabulate `vartab' periodo [w=factor], sum(`var_fum') nost 
		su `vartab'
		local r_max = r(max)
		foreach value of numlist 1/`r_max' {
			di "valor de `vartab': `value'"
			
			svy: mean `var_fum' if `vartab' == `value', over(periodo) 
			svy: mean `var_fum' if `vartab' == `value', over(periodo) coeflegend
			test  _b[c.`var_fum'@2018bn.periodo]=_b[c.`var_fum'@2020.periodo]

		}

	}	
}


/*------------------------------------------
/* Por adolescente / adulto */


foreach var_sum of varlist adolescente adulto {
	foreach value of numlist 1 2 {
		svy: mean fumador if sexo == `value' & `var_sum'== 1, over(periodo) 
		svy: mean fumador if sexo == `value' & `var_sum'== 1, over(periodo) coeflegend
		test  _b[c.fumador@2018bn.periodo]=_b[c.fumador@2020.periodo]
		*svy: total fumador if sexo == 1, over(periodo) 
	}
}


foreach var_sum of varlist adolescente adulto {
	tabulate sex if `var_sum'==1 [w=factor], sum(fumador) nost nofreq noobs
	tabulate sex if `var_sum'==1 [w=factor], sum(fumador_diario) nofreq nost noobs
	tabulate sex if `var_sum'==1 [w=factor], sum(fumador_ocasional) nofreq nost noobs
}

foreach var_sum of varlist adolescente adulto {
	foreach vartab of varlist  sexo grupedad_comp ingr_gr gr_educ poblacion{
		tabulate `vartab' if `var_sum'==1 [w=factor], sum(fumador) nofreq nost noobs

		tabulate `vartab' if `var_sum'==1 [w=factor], sum(fumador_diario) nofreq nost noobs

		tabulate `vartab' if `var_sum'==1 [w=factor], sum(fumador_ocasional) nofreq nost noobs
	}
}

------------------------------------------*/

log close

