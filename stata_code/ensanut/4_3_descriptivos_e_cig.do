
do stata_code/ensanut/0_dirEnsanut.do

capture log close
log using $resultados/descriptivos_e_cig.log, replace

global var_desc "cant_cig"
************************************************************DESCRIPTIVOS********************************************************
set more off


/* 2018 -------------*/
use "$datos/2018/tabla_adol_adul.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_dis) singleunit(certainty)


/* cigarros electrónicos y consumo dual*/
foreach var_desc of varlist e_cig cons_dual {
    di "Variable describir: `var_desc'"
	/* adolescente y adulto*/
	foreach var_sum of varlist adolescente adulto {
	    di "Variable submuestra: `var_sum'"
		di "promedio y total"
		svy: mean `var_desc' if  `var_sum'== 1 
		svy: total `var_desc'  if `var_sum' == 1 
		
		di "promedio y total: masculino"
		svy: mean `var_desc' if `var_sum' == 1 & sexo == 1 
		svy: total `var_desc'  if `var_sum' == 1 & sexo == 1 
		
		di "promedio y total: femenino"
		svy: mean `var_desc'  if `var_sum' == 1 & sexo == 2
		svy: total `var_desc'  if `var_sum' == 1 & sexo == 2

		di "promedio"
		tabulate sex if `var_sum'==1 [w=factor], sum(`var_desc') nofreq nost noobs


		foreach vartab of varlist sexo edad_gr3 ingr_gr educ_gr3 {
			tabulate sex `vartab' if `var_sum'==1 [w=factor], ///
				sum(`var_desc') nofreq nost noobs
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

/* cigarros electrónicos y consumo dual*/
foreach var_desc of varlist e_cig cons_dual {
    di "Variable describir: `var_desc'"
	/* adolescente y adulto*/
	foreach var_sum of varlist adolescente adulto {
	    di "Variable submuestra: `var_sum'"
		di "promedio y total"
		svy: mean `var_desc' if  `var_sum'== 1 
		svy: total `var_desc'  if `var_sum' == 1 
		
		di "promedio y total: masculino"
		svy: mean `var_desc' if `var_sum' == 1 & sexo == 1 
		svy: total `var_desc'  if `var_sum' == 1 & sexo == 1 
		
		di "promedio y total: femenino"
		svy: mean `var_desc'  if `var_sum' == 1 & sexo == 2
		svy: total `var_desc'  if `var_sum' == 1 & sexo == 2

		di "promedio"
		tabulate sex if `var_sum'==1 [w=factor], sum(`var_desc') nofreq nost noobs


		foreach vartab of varlist sexo edad_gr3 ingr_gr educ_gr3 {
			tabulate sex `vartab' if `var_sum'==1 [w=factor], ///
				sum(`var_desc') nofreq nost noobs
		}
	}
}


log close

