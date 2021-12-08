

capture log close
log using resultados/ensanut/pruebas_t_adul.log, replace

do stata_code/ensanut/dirEnsanut.do

************************************************************DESCRIPTIVOS********************************************************
set more off


use "$datos/2020/adul_18_20.dta", clear

svyset [pweight=factor], psu(upm_dis) strata(est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
gen insample = (grupedad_comp  <6 & gr_educ < 5)

/*------------------------------------------
sin distinguir adolescente / adulto
------------------------------------------*/
global depvar "cant_cig"


svy, subpop(insample): regress $depvar i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion 
outreg2 using "resultados/ensanut/lineal$depvar", word excel replace


svy, subpop(insample): regress $depvar i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion i.cons_dual
outreg2 using "resultados/ensanut/lineal$depvar", word excel append

/* Logaritmos*/
gen log_cant_cig=log(cant_cig)
global depvar "log_cant_cig"

svy, subpop(insample): regress $depvar i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion 
outreg2 using "resultados/ensanut/log_lineal$depvar", word excel replace

svy, subpop(insample): regress $depvar i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion i.cons_dual
outreg2 using "resultados/ensanut/log_lineal$depvar", word excel append

/*
* remover 

outreg2

collect: svy, subpop(insample): regress cant_cig i.sexo
