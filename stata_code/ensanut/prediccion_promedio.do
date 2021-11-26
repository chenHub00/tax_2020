

* modelo sin interacciones de 
* modelo_lineal_cant_cig_adol_adul.do
capture log close
log using resultados/ensanut/prediccion_promedio.log, replace

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
gen log_cant_cig=log(cant_cig)

/* 2. FUMADORES diarios */
global depvar "cant_cig"

*svy, subpop(if insample==1 & fumador_diario == 1): regress $depvar i.periodo i.sexo ///
*	i.grupedad_comp i.gr_educ i.poblacion 

svy, subpop(if insample==1 & fumador_diario == 1): regress $depvar i.periodo i.sexo ///
	i.grupedad_comp i.gr_educ i.poblacion i.nse5f

predict xb
predict sd, stdp
ta periodo, su(xb)
/* Funcionan estos?
*svy, subpob(if insample==1 & fumador_diario == 1) over(periodo): mean xb
*/

svy, over(periodo): mean xb
estat sd
svy, over(periodo sexo): mean xb
estat sd
/* Funcionan estos?
ta periodo sexo, su(xb) nofreq nost
ta periodo sexo, su(sd) nofreq nost
*/
log close
