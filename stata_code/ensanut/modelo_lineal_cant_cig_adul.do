

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
global var_reg "cant_cig"


svy, subpop(insample): regress cant_cig i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion 


svy, subpop(insample): regress cant_cig i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion i.cons_dual


/*
* remover 

outreg2

collect: svy, subpop(insample): regress cant_cig i.sexo
