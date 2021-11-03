
capture log close
log using resultados/logs/calcula_passthrough100_2019_2021.log, replace

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

keep ppu marca ym cve_ tipo
keep if ym >= ym(2019,1) & ym <= ym(2021,4) 

save "datos/finales/panel_marca_ciudad_2019a2021.dta", replace

use "datos/finales/panel_marca_ciudad_2019a2021.dta", clear

/* VALOR ESPERADO A CONTRASTAR*/
keep if ym >= ym(2020,1) & ym <= ym(2020,12) 

save datos/finales/panel_marca_ciudad_2020.dta, replace

use "datos/finales/panel_marca_ciudad_2019a2021.dta", clear

/* VALOR ESPERADO A CONTRASTAR*/
keep if ym >= ym(2021,1) & ym <= ym(2021,4) 

save datos/finales/panel_marca_ciudad_2021.dta, replace

use "datos/finales/panel_marca_ciudad_2019a2021.dta", clear

/* VALOR inicial*/
keep if ym == ym(2019,12)  

/* GENERAR EL VALOR ESPERADO */

*### ParÃ¡metros
scalar sc_vat = .16
scalar sc_iepsf = 0.35*20
scalar sc_iepsf2020 = 0.4944*20 // # incremento del impuesto vigente desde 1 enero 2020
scalar sc_iepsf2021 = 0.5108*20 //# ajuste por la inflaciÃ³n vigente desde 1 enero 2021
scalar sc_iepsav = 1.60
scalar sc_ret = .28
scalar sc_infe2020 = .0343 // # inflaciÃ³n esperada para 2020 segÃºn encuesta de Banxico de dic 2019
scalar sc_infe2021 = .0363 // # inflaciÃ³n esperada para 2021 segÃºn encuesta de Banxico de dic 2020

*  # Baseline=2019
* Valores antes de impuestos
* ajustados por VAT
* precios por cajetilla (suponemos de 20 cigarros)
gen p = ppu*20
su p

// original : vat0 = p-(p/(1+vat))
// periodo 
gen vat0 = p-(p/(1+sc_vat)) if  ym == ym(2019,12)
su vat0
*histogram vat0

/*
// Prueba orden de operaciones:
scalar sc_vat_factor = (sc_vat/(1+sc_vat)) 
gen vat_test = p*sc_vat_factor
su vat_test
compare vat0 vat_test
*/
gen taxbase0 = (p-vat0-sc_iepsf)/(1+sc_ret+sc_iepsav)
su taxbase0
*histogram taxbase0

gen ret0 = sc_ret*taxbase0
su ret0 
*histogram ret0 

gen iepsav0 = sc_iepsav*taxbase0
su iepsav0
*histogram iepsav0
//  solo se define pero no se encuentra su uso: iepsf0 = iepsf 
  
*   # 2020
gen taxbase1 = taxbase0*(1+sc_infe2020)
 // ?se puede sustituir directamente, cuando se tiene un programa independiente del periodo
gen sc_iepsf1 = sc_iepsf2020
gen iepsav1 = sc_iepsav*taxbase1
gen ret1 = sc_ret*taxbase1
gen  vat1 = (taxbase1+sc_iepsf1+iepsav1+ret1)*sc_vat
gen  p1 = taxbase1+sc_iepsf1+iepsav1+ret1+vat1
su p1 taxbase1 iepsav1 ret1 vat1

*replace varlist = p1
gen pt100_jan2020= p1

* Seguimiento de versiones del programa:
* 0. el programa hace el cálculo para todas las observaciones
* 1. Se ajustó para sólo considerar la comparación de los periodos relevantes
* enero 2020, vs lo esperado de diciembre 2019 
* enero 2021, vs lo esperado de diciembre 2020
* esto es equivalente a tomar los datos de cada ciudad en lugar de considerar 
* - el promeriod
* ? en la tabla de ejemplo se consideran los promedios de todo el año para todas las ciudades?
* ? o es sólo el periodo de diciembre 2019?

/**/
keep p pt100_jan2020 marca ym cve_ tipo

*save `file1'
save "datos/finales/pass_through100_dec2019.data", replace


use datos/finales/panel_marca_ciudad_2020.dta, clear

merge m:1 cve_ciudad marca using "datos/finales/pass_through100_dec2019.data", 

*merge 1:1 cve_ciudad marca using `file2'
ta _
drop _

gen pobs_2020 = ppu*20
rename p pobs_dic2019
drop ppu

rename pt100_jan2020 pt100_est

save "datos/finales/pass_through100_2021.dta", replace

ttest pobs_jan2020 == pt100_
/*
Paired t test
------------------------------------------------------------------------------
Variable |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
       p |     175    57.46615    .4847793    6.413027    56.50935    58.42296
pt1~2020 |     175    58.05605    .4343867    5.746396    57.19871     58.9134
---------+--------------------------------------------------------------------
    diff |     175   -.5899002    .1682181    2.225316   -.9219108   -.2578897
------------------------------------------------------------------------------
     mean(diff) = mean(p - pt100_jan2020)                         t =  -3.5068
 H0: mean(diff) = 0                              Degrees of freedom =      174

 Ha: mean(diff) < 0           Ha: mean(diff) != 0           Ha: mean(diff) > 0
 Pr(T < t) = 0.0003         Pr(|T| > |t|) = 0.0006          Pr(T > t) = 0.9997

 la diferencia del observado y el estimado es significativamente menor a cero
 es decir, el pass-through al 100 por ciento sería mayor a lo observado
*/
su pobs_* pt100_
*table marca, su(pobs_* pt100_)

/*************** dec 2020 ***********************************************/
use "datos/finales/panel_marca_ciudad_2019a2021.dta", clear

/* VALOR inicial*/
keep if ym == ym(2020,12)  


/* GENERAR EL VALOR ESPERADO */

*### ParÃ¡metros
scalar sc_vat = .16
scalar sc_iepsf = 0.35*20
*scalar sc_iepsf2020 = 0.4944*20 // # incremento del impuesto vigente desde 1 enero 2020
scalar sc_iepsf2021 = 0.5108*20 //# ajuste por la inflaciÃ³n vigente desde 1 enero 2021
scalar sc_iepsav = 1.60
scalar sc_ret = .28
*scalar sc_infe2020 = .0343 // # inflaciÃ³n esperada para 2020 segÃºn encuesta de Banxico de dic 2019
scalar sc_infe2021 = .0363 // # inflaciÃ³n esperada para 2021 segÃºn encuesta de Banxico de dic 2020

*  # Baseline=2019
* Valores antes de impuestos
* ajustados por VAT
* precios por cajetilla (suponemos de 20 cigarros)
gen p = ppu*20
su p

// original : vat0 = p-(p/(1+vat))
// periodo 
gen vat0 = p-(p/(1+sc_vat)) if  ym == ym(2020,12)
su vat0
*histogram vat0

/*
// Prueba orden de operaciones:
scalar sc_vat_factor = (sc_vat/(1+sc_vat)) 
gen vat_test = p*sc_vat_factor
su vat_test
compare vat0 vat_test
*/
gen taxbase0 = (p-vat0-sc_iepsf)/(1+sc_ret+sc_iepsav)
su taxbase0
*histogram taxbase0

gen ret0 = sc_ret*taxbase0
su ret0 
*histogram ret0 

gen iepsav0 = sc_iepsav*taxbase0
su iepsav0
*histogram iepsav0
//  solo se define pero no se encuentra su uso: iepsf0 = iepsf 
  
*   # 2021
gen taxbase1 = taxbase0*(1+sc_infe2021)
 // ?se puede sustituir directamente, cuando se tiene un programa independiente del periodo
gen sc_iepsf1 = sc_iepsf2021
gen iepsav1 = sc_iepsav*taxbase1
gen ret1 = sc_ret*taxbase1
gen  vat1 = (taxbase1+sc_iepsf1+iepsav1+ret1)*sc_vat
gen  p1 = taxbase1+sc_iepsf1+iepsav1+ret1+vat1
su p1 taxbase1 iepsav1 ret1 vat1

*replace varlist = p1
*gen pt100_jan2021= p1[_n-1]
gen pt100_jan2021= p1

keep p pt100_jan2021 marca ym cve_ tipo

save "datos/finales/pass_through100_dec2021.dta", replace

/**/
use datos/finales/panel_marca_ciudad_2021.dta, clear

merge m:1 cve_ciudad marca using "datos/finales/pass_through100_dec2021.dta", 

ta _
*drop _

gen pobs_jan2021 = ppu*20
rename p pobs_dic2020
drop ppu

rename pt100_jan2021 pt100_est

save "datos/finales/pass_through100_2020.data", replace

ttest pobs_jan2021 == pt100_


use "datos/finales/panel_marca_ciudad_2019a2021.dta", clear

/* VALOR ESPERADO A CONTRASTAR*/
keep if ym >= ym(2019,1) & ym <= ym(2019,12) 

save "datos/finales/panel_marca_ciudad_2019.dta", replace

gen pobs_jan2021 = ppu*20
rename p pobs_dic2020
drop ppu

append using "datos/finales/pass_through100_2020.data"


/*

Paired t test
------------------------------------------------------------------------------
Variable |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
       p |     175    60.62629    .4702493    6.220813    59.69816    61.55441
pt1~2020 |     175     64.7735    .4638368    6.135985    63.85803    65.68897
---------+--------------------------------------------------------------------
    diff |     175   -4.147214    .0942024     1.24618    -4.33314   -3.961287
------------------------------------------------------------------------------
     mean(diff) = mean(p - pt100_jan2020)                         t = -44.0245
 H0: mean(diff) = 0                              Degrees of freedom =      174

 Ha: mean(diff) < 0           Ha: mean(diff) != 0           Ha: mean(diff) > 0
 Pr(T < t) = 0.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 1.0000



*/



/*
Programa inicial en R
# 16 de septiembre de 2021

### ParÃ¡metros
vat = .16
iepsf = 0.35*20
iepsf2020 = 0.4944*20 # incremento del impuesto vigente desde 1 enero 2020
iepsf2021 = 0.5108*20 # ajuste por la inflaciÃ³n vigente desde 1 enero 2021
iepsav = 1.60
ret = .28
infe2020 = .0343 # inflaciÃ³n esperada para 2020 segÃºn encuesta de Banxico de dic 2019
infe2021 = .0363 # inflaciÃ³n esperada para 2021 segÃºn encuesta de Banxico de dic 2020

P2019=c(55.58,54.55,41.78,49.61,62.91,39.4,46.06,33.04) # Precios x caj x marca observados de INEGI
P2020=c(62.48,60.47,49.33,56.74,68.44,47.38,52.97,38.56) # Precios x caj x marca observados de INEGI

### Rutina para cÃ¡lculo de precio 2020 con pass-through del impuesto del 100%
for (p in P2019) {
  # Baseline=2019
  vat0 = p-(p/(1+vat))
  taxbase0 = (p-vat0-iepsf)/(1+ret+iepsav)  
  ret0 = ret*taxbase0
  iepsav0 = iepsav*taxbase0
  iepsf0 = iepsf
 
  # 2020
  taxbase1 = taxbase0*(1+infe2020)
  iepsf1 = iepsf2020
  iepsav1 = iepsav*taxbase1
  ret1 = ret*taxbase1
  vat1 = (taxbase1+iepsf1+iepsav1+ret1)*vat
  p1 = taxbase1+iepsf1+iepsav1+ret1+vat1
 
  print(p1)
}

### Rutina para cÃ¡lculo de precio 2021 con pass-through del impuesto del 100%
for (p in P2020) {
  # Baseline=2020
  vat0 = p-(p/(1+vat))
  taxbase0 = (p-vat0-iepsf2020)/(1+ret+iepsav)  
  ret0 = ret*taxbase0
  iepsav0 = iepsav*taxbase0
  iepsf0 = iepsf2020
  
  # 2021
  taxbase1 = taxbase0*(1+infe2021)
  iepsf1 = iepsf2021
  iepsav1 = iepsav*taxbase1
  ret1 = ret*taxbase1
  vat1 = (taxbase1+iepsf1+iepsav1+ret1)*vat
  p1 = taxbase1+iepsf1+iepsav1+ret1+vat1
  
  print(p1)
}

log close
