
do stata_code/ensanut/dirEnsanut.do

capture log close
log using $resultados/descriptivos.log, replace

************************************************************DESCRIPTIVOS********************************************************
set more off


/* 2018 -------------*/
use "$datos/2018/tabla_adol_adul.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_dis) singleunit(certainty)

/* adolescente */
svy: mean fumador if adol == 1
svy: total fumador if adol == 1

svy: mean fumador if adol == 1 & sexo == 1
svy: total fumador if adol == 1 & sexo == 1

svy: mean fumador if adol == 1 & sexo == 2
svy: total fumador if adol == 1 & sexo == 2

tabulate sex if adol==1 [w=factor], sum(fumador) nost 

tabulate sex if adol==1 [w=factor], sum(fumador_diario) nofreq nost noobs

tabulate sex if adol==1 [w=factor], sum(fumador_ocasional) nofreq nost noobs


/* adulto*/
local var_sum = "adulto"
svy: mean fumador if  `var_sum'== 1
svy: total fumador if `var_sum' == 1

svy: mean fumador if `var_sum' == 1 & sexo == 1
svy: total fumador if `var_sum' == 1 & sexo == 1

svy: mean fumador if `var_sum' == 1 & sexo == 2
svy: total fumador if `var_sum' == 1 & sexo == 2

tabulate sex if `var_sum'==1 [w=factor], sum(fumador) nost nofreq noobs

tabulate sex if `var_sum'==1 [w=factor], sum(fumador_diario) nofreq nost noobs

tabulate sex if `var_sum'==1 [w=factor], sum(fumador_ocasional) nofreq nost noobs

*exfumador
local var_sum = "adulto"
svy: mean exfumador if `var_sum' == 1 

svy: mean nofumador if `var_sum' == 1 


* collapse 
*gen sum_fumador = fumador*factor
*format %12.0g sum_fumador
*collapse (mean) fumador (sum) sum_fumador if adulto==1 [w=factor], by(sex) 

/* 2020 -------------*/
use "$datos/2020/tabla_adol_adul.dta", clear

svyset [pweight=factor], psu(upm_dis)strata (est_dis) singleunit(certainty)

/* adolescente y adulto*/
foreach var_sum of varlist adolescente adulto {
	di "promedio y total"
	svy: mean fumador if  `var_sum'== 1
	svy: total fumador if `var_sum' == 1

	di "promedio y total: masculino"
	svy: mean fumador if `var_sum' == 1 & sexo == 1
	svy: total fumador if `var_sum' == 1 & sexo == 1

	di "promedio y total: femenino"
	svy: mean fumador if `var_sum' == 1 & sexo == 2
	svy: total fumador if `var_sum' == 1 & sexo == 2

	di "promedio"
	tabulate sex if `var_sum'==1 [w=factor], sum(fumador) nofreq nost noobs

	tabulate sex if `var_sum'==1 [w=factor], sum(fumador_diario) nofreq nost noobs

	tabulate sex if `var_sum'==1 [w=factor], sum(fumador_ocasional) nofreq nost noobs

	tabulate sex if `var_sum'==1 [w=factor], sum(fumador) nofreq nost noobs

	tabulate sex if `var_sum'==1 [w=factor], sum(fumador_diario) nofreq nost noobs

	tabulate sex if `var_sum'==1 [w=factor], sum(fumador_ocasional) nofreq nost noobs

	*
	di "ex-fumador"
	svy: mean exfumador if `var_sum' == 1 
	di "no fumador"
	svy: mean nofumador if `var_sum' == 1 
}


log close


/** ejemplo: poblacion_t?
*N EXPANDIDA EN POBLACIÓN NACIONAL POR SEXO Y REGIONES ECEA
*N EXPANDIDA EN POBLACIÓN NACIONAL (POR GRUPO DE EDAD REGIONAL) 
global vars "poblacion_t"
foreach v of global vars {
label def _var_`v' 0 "" 1 "`: var label `v''", replace
label val `v' _var_`v'
}
*Cuadro T1. En numero
tabout $vars grupedad_r using "$resultados/`x'T1.txt", ///
	append f(1) c(freq) svy replace clab(n expandida) layout(col) cisep( , ) tot(Total Global) ///
	h1("Cuadro  expandida en las prevalencia . `: label (entidad) `x''")
svy: total poblacion_t, over ( grupedad_r )
estat cv

*N EXPANDIDA EN POBLACIÓN  
global vars "poblacion_t"
foreach v of global vars {
label def _var_`v' 0 "" 1 "`: var label `v''", replace
label val `v' _var_`v'
}
*Cuadro T1. En numero
tabout $vars using "$resultados/`x'T1.txt", ///
	append f(1) c(freq) svy replace clab(n expandida) layout(col) cisep( , ) tot(Total Global) ///
	h1("Cuadro  expandida en las prevalencia . `: label (entidad) `x''")
svy: total poblacion_t
estat cv
