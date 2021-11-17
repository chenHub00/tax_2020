
*****************************************************UNIÓN DE TABLAS*************************
set more off

capture log close
log using resultados/ensanut/tabla_join_adul.log, replace

do stata_code/ensanut/dirEnsanut.do

use "$datos/2020/tabla_adultos.dta", clear

/* EDUCACION */
merge 1:1 FOLIO_I ID_INT using "$datos\2020\vars_educ.dta", gen(m_educ)
* 25,307 obs en vars_educ, no en adolescentes ni adultos?
* todas las observaciones en la union de adolescentes y adultos (10,796) sí hacen match
keep if m_educ == 3
drop m_educ
/* INGRESO */
merge m:1  FOLIO_I using "$datos\2020\vars_ingr_gr.dta", gen(m_ingr)
* 3,922 obs en vars_ingr_, no en adolescentes ni adultos: por qué?
* todas las observaciones en la union de adolescentes y adultos (10,796) sí hacen match
keep if m_ingr == 3

rename FOLIO_I folio_i
tostring entidad, replace
merge m:1 folio_i using $datos/recibidos/economico.dta, gen(m_nse) 
ta m_nse
keep if m_nse == 3
destring entidad, replace

/* EDAD */
do $codigo/do_edad_gr.do

*Guardado de la base de datos unida (base general)

******DEFINICIÓN DE VARIABLES ADICIONALES
do $codigo/do_vars_edad_a_rural.do

save "$datos/2020/tabla_adul_fin.dta", replace

*****************************************************UNIÓN DE BASES DE DATOS*************************
use "$datos/2018/tabla_adultos.dta", clear


do $codigo/do_edad_gr.do

merge 1:1 upm_dis viv_sel hogar numren using $datos/2018/vars_educ.dta, gen(m_educ)

merge m:1 upm_dis viv_sel hogar using $datos/2018/vars_ingr_gr.dta, gen(m_ingr) 

rename upm_dis upm
merge m:1 upm viv_sel hogar using $datos/recibidos/ENSANUT2018_NSE.dta, gen(m_nse)
ta m_nse 

rename upm upm_dis 
rename nse5F nse5f
rename nseF nsef

*Guardado de la base de datos unida (base general)
g entidad=ent
******DEFINICIÓN DE VARIABLES ADICIONALES
do $codigo/do_vars_edad_a_rural.do

save "$datos/2018/tabla_adul_fin.dta", replace

log close

*****************************************************UNIÓN DE TABLAS*************************
* 2020
* 2018

capture log close
log using resultados/ensanut/tabla_join_adul.log, append

use "$datos/2018/tabla_adul_fin.dta", clear
*p1_2- p1_10  
drop p13_2- p13_6_1

gen periodo = 2018

tostring upm_dis,replace
rename est_dis est_sel


append using "$datos/2020/tabla_adul_fin.dta", generate(ap_2018_2020) 
*ad1a01- ad1a05 
drop adul1a01- adul1a05 H0326

recode periodo (. = 2020) 

svyset [pweight=factor], psu(upm_dis)strata (est_sel) singleunit(certainty)

save "$datos/2020/adul_18_20.dta", replace

log close

