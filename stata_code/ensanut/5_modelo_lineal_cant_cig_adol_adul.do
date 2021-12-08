

capture log close
log using resultados/ensanut/modelo_lineal_cant_cig_adol_adul.log, replace

do stata_code/ensanut/0_dirEnsanut.do

************************************************************DESCRIPTIVOS********************************************************
set more off

use "$datos/2020/adol_adul_18_20.dta", clear

svyset [pweight=factor], psu(upm_dis) strata(est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
gen insample = (grupedad_comp  <6 & gr_educ < 5)

recode sexo (2=0)
recode poblacion (2 = 0)
recode periodo (2018 = 0) (2020= 1)
gen log_cant_cig=log(cant_cig)

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

/* 1. FUMADORES */
global depvar "cant_cig"

svy, subpop(if insample==1 & fumador == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion i.fumador_diario
outreg2 using "resultados/ensanut/lineal_fumador$depvar", word excel replace

svy, subpop(if insample==1 & fumador == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion i.fumador_diario i.nse5f 
outreg2 using "resultados/ensanut/lineal_fumador$depvar", word excel append

xi i.sexo*i.periodo i.grupedad_comp*i.periodo i.gr_educ*i.periodo ///
		i.poblacion*i.periodo i.fumador_diario*i.periodo i.nse5f*i.periodo  ///
		, prefix(vr_)
svy, subpop(if insample==1 & fumador == 1):  regress $depvar vr_* 
outreg2 using "resultados/ensanut/lineal_fumador$depvar", word excel append

/* Logaritmos*/
global depvar "log_cant_cig"

svy, subpop(if insample==1 & fumador == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion i.fumador_diario
outreg2 using "resultados/ensanut/log_lin_fumador$depvar", word excel replace

svy, subpop(if insample==1 & fumador == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion i.fumador_diario i.nse5f
outreg2 using "resultados/ensanut/log_lin_fumador$depvar", word excel append

xi i.sexo*i.periodo i.grupedad_comp*i.periodo i.gr_educ*i.periodo ///
		i.poblacion*i.periodo i.fumador_diario*i.periodo i.nse5f*i.periodo ///
		, prefix(vr_)
svy, subpop(if insample==1 & fumador == 1):  regress $depvar vr_* 
outreg2 using "resultados/ensanut/log_lin_fumador$depvar", word excel append

/* 2. FUMADORES diarios */
global depvar "cant_cig"

svy, subpop(if insample==1 & fumador_diario == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion 
outreg2 using "resultados/ensanut/lineal_fum_diario$depvar", word excel replace

svy, subpop(if insample==1 & fumador_diario == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion i.nse5f
outreg2 using "resultados/ensanut/lineal_fum_diario$depvar", word excel append

xi i.sexo*i.periodo i.grupedad_comp*i.periodo i.gr_educ*i.periodo ///
		i.poblacion*i.periodo i.nse5f*i.periodo ///
		, prefix(vr_)
svy, subpop(if insample==1 & fumador_diario == 1):  regress $depvar vr_* 
outreg2 using "resultados/ensanut/lineal_fum_diario$depvar", word excel append

/* Logaritmos*/
global depvar "log_cant_cig"

svy, subpop(if insample==1 & fumador_diario == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion 
outreg2 using "resultados/ensanut/log_lin_fum_diario$depvar", word excel replace

svy, subpop(if insample==1 & fumador_diario == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion i.nse5f
outreg2 using "resultados/ensanut/log_lin_fum_diario$depvar", word excel append

xi i.sexo*i.periodo i.grupedad_comp*i.periodo i.gr_educ*i.periodo ///
		i.poblacion*i.periodo i.nse5f*i.periodo ///
		, prefix(vr_)
svy, subpop(if insample==1 & fumador_diario == 1):  regress $depvar vr_* 
outreg2 using "resultados/ensanut/log_lin_fum_diario$depvar", word excel append

/* 3. FUMADORES ocasionales */
global depvar "cant_cig"

svy, subpop(if insample==1 & fumador_ocasional == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion 
outreg2 using "resultados/ensanut/lineal_fum_ocasional$depvar", word excel replace

svy, subpop(if insample==1 & fumador_ocasional == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion i.nse5f
outreg2 using "resultados/ensanut/lineal_fum_ocasional$depvar", word excel append

xi i.sexo*i.periodo i.grupedad_comp*i.periodo i.gr_educ*i.periodo ///
		i.poblacion*i.periodo i.nse5f*i.periodo ///
		, prefix(vr_)
svy, subpop(if insample==1 & fumador_ocasional == 1):  regress $depvar vr_* 
outreg2 using "resultados/ensanut/lineal_fum_ocasional$depvar", word excel append

/* Logaritmos*/
global depvar "log_cant_cig"

svy, subpop(if insample==1 & fumador_ocasional == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion 
outreg2 using "resultados/ensanut/log_lin_fum_ocasional$depvar", word excel replace

svy, subpop(if insample==1 & fumador_ocasional == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion i.nse5f
outreg2 using "resultados/ensanut/log_lin_fum_ocasional$depvar", word excel append

xi i.sexo*i.periodo i.grupedad_comp*i.periodo i.gr_educ*i.periodo ///
		i.poblacion*i.periodo i.nse5f*i.periodo ///
		, prefix(vr_)
svy, subpop(if insample==1 & fumador_ocasional == 1):  regress $depvar vr_* 
outreg2 using "resultados/ensanut/log_lin_fum_ocasional$depvar", word excel append

log close
