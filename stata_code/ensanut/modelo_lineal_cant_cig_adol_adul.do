

capture log close
log using resultados/ensanut/pruebas_t_adul.log, replace

do stata_code/ensanut/dirEnsanut.do

************************************************************DESCRIPTIVOS********************************************************
set more off


use "$datos/2020/adol_adul_18_20.dta", clear

svyset [pweight=factor], psu(upm_dis) strata(est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
gen insample = (grupedad_comp  <6 & gr_educ < 5)

recode sexo (2=0)
recode poblacion (2 = 0)
recode periodo (2018 = 0) (2020= 1)

/*------------------------------------------
sin distinguir adolescente / adulto
------------------------------------------*/
global depvar "cant_cig"


svy, subpop(insample): regress $depvar i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion 
outreg2 using "resultados/ensanut/lineal$depvar", word excel replace


svy, subpop(insample): regress $depvar i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion i.nse5f
outreg2 using "resultados/ensanut/lineal$depvar", word excel append

xi i.sexo*i.periodo i.grupedad_comp*i.periodo i.gr_educ*i.periodo ///
		i.poblacion*i.periodo i.nse5f*i.periodo ///
		, prefix(vr_)
svy, subpop(insample): regress $depvar vr_* 
outreg2 using "resultados/ensanut/lineal$depvar", word excel append

/* Logaritmos*/
gen log_cant_cig=log(cant_cig)
global depvar "log_cant_cig"

svy, subpop(insample): regress $depvar i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion 
outreg2 using "resultados/ensanut/log_lineal$depvar", word excel replace

svy, subpop(insample): regress $depvar i.periodo i.sexo i.grupedad_comp i.gr_educ i.poblacion i.nse5f
outreg2 using "resultados/ensanut/log_lineal$depvar", word excel append

xi i.sexo*i.periodo i.grupedad_comp*i.periodo i.gr_educ*i.periodo ///
		i.poblacion*i.periodo i.nse5f*i.periodo ///
		, prefix(vr_)
svy, subpop(insample): regress $depvar vr_* 
outreg2 using "resultados/ensanut/log_lineal$depvar", word excel append


log close