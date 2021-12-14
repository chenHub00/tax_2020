

use datos/prelim/de_inpc/panel_marca_ciudad.dta, clear

/*
*### ParÃ¡metros
scalar vat = .16
scalar iepsf = 0.35*20
scalar iepsf2020 = 0.4944*20 // # incremento del impuesto vigente desde 1 enero 2020
scalar iepsf2021 = 0.5108*20 //# ajuste por la inflaciÃ³n vigente desde 1 enero 2021
scalar iepsav = 1.60
scalar ret = .28
scalar infe2020 = .0343 // # inflaciÃ³n esperada para 2020 segÃºn encuesta de Banxico de dic 2019
scalar infe2021 = .0363 // # inflaciÃ³n esperada para 2021 segÃºn encuesta de Banxico de dic 2020
*/

scalar iepsf2020 = 0.4944*20 // # incremento del impuesto vigente desde 1 enero 2020
scalar iepsf2021 = 0.5108*20 //# ajuste por la inflaciÃ³n vigente desde 1 enero 2021
scalar infe2020 = .0343 // # inflaciÃ³n esperada para 2020 segÃºn encuesta de Banxico de dic 2019
scalar infe2021 = .0363 // # inflaciÃ³n esperada para 2021 segÃºn encuesta de Banxico de dic 2020


*  # Baseline=2019
* Valores antes de impuestos
* ajustados por VAT
capture program drop pass_through100
program pass_through100
version 14.0
args varname newvarname iepsf_periodo inf_e_periodo condicion_periodo
*iepsf_periodo(real 1 ) inf_e_periodo(real 1)
*syntax varname newvarname(generate) 
*,  iepsf_periodo(real 1 ) inf_e_periodo(real 1)
*display " in contains |`iepsf_periodo'|"
*display " in contains |`inf_e_periodo'|"

* parametros del programa 
* para 2020
*local iepsf_periodo = 0.4944*20 // # incremento del impuesto vigente desde 1 enero 2020
*local inf_e_periodo .0343 // # inflaciÃ³n esperada para 2020 segÃºn encuesta de Banxico de dic 2019

// usar una variable para pruebas, generar una nueva variable
tempvar p vat0  taxbase0 ret0 iepsav0
* para pruebas
tempvar vat_test
*gen `p' = `varlist'
gen `p' = `varname'
su `p'

*### ParÃ¡metros
local vat .16
di "`vat'"

local iepsf = 0.35*20
di "`iepsf'"
local ret 0.28
di "`ret'"
local iepsav 1.60
di "`iepsav'"


// original : vat0 = p-(p/(1+vat))
gen `vat0' = `p'-(`p'/(1+`vat')) `condicion_periodo'
su `vat0'

/*
// Prueba orden de operaciones:
local vat_factor = (`vat'/(1+`vat')) 
gen `vat_test' = `p'*`vat_factor'
su `vat_test'
compare `vat0' `vat_test'
*/

gen `taxbase0' = (`p'-`vat0'-`iepsf')/(1+`ret'+`iepsav')
su `taxbase0' 
*histogram `taxbase0' 

gen `ret0' = `ret'*`taxbase0'
gen  `iepsav0' = `iepsav'*`taxbase0'
su `ret0' `iepsav0' 
//  solo se define pero no se encuentra su uso: `iepsf0' = iepsf 

  
*graph twoway scatter `p' `vat0' `iepsav0' 

tempvar taxbase1 iepsav1 iepsf1 ret1 iepsav1 vat1 p1 
*   # 2020
 gen `taxbase1' = `taxbase0'*(1+`inf_e_periodo')
 // ?se puede sustituir directamente, cuando se tiene un programa independiente del periodo
gen `iepsf1' = `iepsf_periodo'
gen `iepsav1' = `iepsav'*`taxbase1'
gen `ret1' = `ret'*`taxbase1'
gen  `vat1' = (`taxbase1'+`iepsf1'+`iepsav1'+`ret1')*`vat'
gen  `p1' = `taxbase1'+`iepsf1'+`iepsav1'+`ret1'+`vat1'
su `p1' `taxbase1' `iepsf1' `iepsav1' `ret1' `vat1'

*replace `varlist' = `p1'
gen `newvarname' = `p1'

end 

* Seguimiento de versiones del programa:
* 0. el programa hace el cálculo para todas las observaciones
* 1. Se ajustó para sólo considerar la comparación de los periodos relevantes
* enero 2020, vs lo esperado de diciembre 2019 
* enero 2021, vs lo esperado de diciembre 2020
* esto es equivalente a tomar los datos de cada ciudad en lugar de considerar 
* - el promeriod
* ? en la tabla de ejemplo se consideran los promedios de todo el año para todas las ciudades?
* ? o es sólo el periodo de diciembre 2019?

pass_through100  ppu p1_2020 iepsf2020 infe2020  "if ym == ym(2019,12)"
su ppu p1_2020 
preserve
keep ppu p1_2020 marca ym cve_
keep if ym >= ym(2019,12) & ym <= ym(2020,1)

egen p1_2020a = mean(p1_2020), by(marca ym cve_)
*egen p1_2020a = min(p1_2020), by(marca ym cve_) missing
gen p1_2020a = p1_2020[_n-1]

save "datos/finales/pass_through100_jan2020.data", replace
restore

use "datos/finales/pass_through100_jan2020.data", clear

*pass_through100  ppu p1_2020 iepsf2020 infe2020 

pass_through100  ppu p1_2021 iepsf2021 infe2021  "if ym == ym(2020,12)"
preserve
keep ppu p1_2021 marca ym 
keep if ym >= ym(2020,12) & ym <= ym(2021,1)



save "datos/finales/pass_through100_jan2021.data", replace

restore


*pass_through100  ppu p1
*su p1
*, iepsf_periodo(iepsf2020) inf_e_periodo(infe2020)




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
