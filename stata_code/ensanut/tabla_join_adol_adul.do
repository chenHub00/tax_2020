
*****************************************************UNIÓN DE TABLAS*************************
set more off

capture log close
log using resultados/ensanut/descriptivos.log, replace

do stata_code/ensanut/dirEnsanut.do

use "$datos/2020/tabla_adolescentes.dta", clear

*Se une con la base de datos de adultos (append)
append using "$datos/2020/tabla_adultos.dta"
*? SIN VALORES DE upm_dis

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

/* EDAD */
do $codigo/do_edad_gr.do

*Guardado de la base de datos unida (base general)

******DEFINICIÓN DE VARIABLES ADICIONALES
*Identificador para expansión poblacional y tamaño de muestra
gen poblacion_t=1

*DESAGREGACIÓN DE FUMADORES DIARIOS Y OCASIONALES //Hecho a partir de la definición
*previamente definida de la variable "smoking" en la bd de adolescentes y adultos

*Fumador diario
g fumador_diario=smoking
replace fumador_diario=1 if smoking==1
replace fumador_diario=0 if smoking==2 
replace fumador_diario=0 if smoking==3
replace fumador_diario=0 if smoking==4
replace fumador_diario=0 if smoking==5
replace fumador_diario=0 if smoking==6
label def fumador_d      0 "No fumador diario" ///
                         1 "Fumador diario" 
label val fumador_diario fumador_d						 
						 				 
*Fumador ocasional
g fumador_ocasional=smoking
replace fumador_ocasional=0 if smoking==1
replace fumador_ocasional=1 if smoking==2 
replace fumador_ocasional=1 if smoking==3
replace fumador_ocasional=0 if smoking==4
replace fumador_ocasional=0 if smoking==5
replace fumador_ocasional=0 if smoking==6
label def fumador_o      0 "No fumador ocasional" ///
                         1 "Fumador ocasional" 
label val fumador_ocasional fumador_o	

*Ex fumador
g exfumador=smoking
replace exfumador=0 if smoking==1
replace exfumador=0 if smoking==2 
replace exfumador=0 if smoking==3
replace exfumador=1 if smoking==4
replace exfumador=1 if smoking==5
replace exfumador=0 if smoking==6
label def exfumad        0 "No exfumador" ///
                         1 "Exfumador" 
label val exfumador exfumad	

*No fumador
g nofumador=smoking
replace nofumador=0 if smoking==1
replace nofumador=0 if smoking==2 
replace nofumador=0 if smoking==3
replace nofumador=0 if smoking==4
replace nofumador=0 if smoking==5
replace nofumador=1 if smoking==6
label def nofumad        0 "Fumador" ///
                         1 "No fumador" 
label val nofumador	nofumad		

*Grupo de edad (14 a 65 años) 
gen edadnse=edad
replace edadnse=. if edad<=14
replace edadnse=. if edad>=65
tab  edadnse
label var edadnse "edad para NSE:de los 15 a los 64 años"

*GRUPOS DE EDAD / ADOLESCENTES Y ADULTOS (NACIONAL / 19 grupos de edad)
recode edad (10/14=1 "10-14 años")(15/19=2 "15-19 años") (20/24=3 "20-24 años") (25/29=4 "25-29 años") ///
(30/34=5 "30-34 años") (35/39=6 "35-39 años") (40/44=7 "40-44 años") (45/49=8 "45-49 años") ///
(50/54=9 "50-54 años") (55/59=10 "55-59 años") (60/64=11 "60-64 años") ///
(65/69=12 "65-69 años")(70/74=13 "70-74 años") (75/79=14 "75-79 años") ///
(80/84=15 "80-84 años")(85/89=16 "85-89 años") (90/94=17 "90-94 años") ///
(95/99=18 "95-99 años")(100/112=19 "100-112 años"), gen(grupedad_n)
label var grupedad_n "Grupos de edad, ECEA nal"
tab grupedad_n

*GRUPOS DE EDAD / ADOLESCENTES Y ADULTOS (NACIONAL / 16 grupos de edad)
recode edad (10/14=1 "10-14 años")(15/19=2 "15-19 años") (20/24=3 "20-24 años") (25/29=4 "25-29 años") ///
(30/34=5 "30-34 años") (35/39=6 "35-39 años") (40/44=7 "40-44 años") (45/49=8 "45-49 años") ///
(50/54=9 "50-54 años") (55/59=10 "55-59 años") (60/64=11 "60-64 años") ///
(65/69=12 "65-69 años")(70/74=13 "70-74 años") (75/79=14 "75-79 años") ///
(80/84=15 "80-84 años")(85/112=16 "85-112 años"), gen(grupedad85_n)
label var grupedad85_n "Grupos de edad, hasta los 85 años y más ECEA nal"
tab grupedad85_n									

*GRUPOS DE EDAD / ADOLESCENTES Y ADULTOS (REGIONAL / 6 grupos de edad)
*(para las estimaciones regionales se usan menos grupos de edad para que queden suficientes observ)
recode edad (10/14=1 "10-14 años")(15/24=2 "15-24 años") (25/44=3 "25-44 años") (45/64=4 "45-64 años") ///
(65/84=5 "65-84 años") (85/112=6 "85-112 años"), gen(grupedad_r)
label var grupedad_r "Grupos de edad, ECEA subnal"
tab grupedad_r

*ENTIDAD
*g entidad=ent
label define entidad 	1 "Aguascalientes" 2 "Baja California" 3 "Baja California Sur" 4 "Campeche" 5 "Coahuila de Zaragoza" 6 "Colima" ///
						7 "Chiapas" 8 "Chihuahua" 9 "Ciudad de México" 10 "Durango" 11 "Guanajuato" 12 "Guerrero" 13 "Hidalgo" 14 "Jalisco" ///
						15 "Estado de México" 16 "Michoacán de Ocampo" 17 "Morelos" 18 "Nayarit" 19 "Nuevo León" 20 "Oaxaca" 21 "Puebla" ///
						22 "Querétaro" 23 "Quintana Roo" 24 "San Luis Potosí" 25 "Sinaloa" 26 "Sonora" 27 "Tabasco" 28 "Tamaulipas" ///
						29 "Tlaxcala" 30 "Veracruz" 31 "Yucatán" 32 "Zacatecas"
label value entidad entidad

*ÁMBITO (URBANO / RURAL) // NOTA: PARA URBANO Y RURAL SE UTILIZÓ LA VARIABLE "población", TAMBIÉN SE UTILIZÓ LA VARIABLE DE "dominio".
g poblacion=dominio
label def pobl 1"Urbano" 2"Rural"
label val poblacion pobl
label var poblacion"Tipo de población"

*ÁMBITO (DUMMIE)
g poblacion2=dominio
recode poblacion2 (1=2) (2=1)
label def pobla 1"Rural" 2"Urbano"
label var poblacion2 pobla
label var poblacion2 "tipo de poblacion"



save "$datos/2020/tabla_adol_adul.dta", replace

*****************************************************UNIÓN DE BASES DE DATOS*************************
use "$datos/2018/tabla_adolescentes.dta", clear

*Se une con la base de datos de adultos (append)
append using "$datos/2018/tabla_adultos.dta"

do $codigo/do_edad_gr.do

merge 1:1 upm viv_sel hogar numren using $datos/2018/vars_educ.dta, gen(m_educ)

merge m:1 upm viv_sel hogar using $datos/2018/vars_ingr_gr.dta, gen(m_ingr) 

*Guardado de la base de datos unida (base general)

******DEFINICIÓN DE VARIABLES ADICIONALES
*Identificador para expansión poblacional y tamaño de muestra
gen poblacion_t=1

*DESAGREGACIÓN DE FUMADORES DIARIOS Y OCASIONALES //Hecho a partir de la definición
*previamente definida de la variable "smoking" en la bd de adolescentes y adultos

*Fumador diario
g fumador_diario=smoking
replace fumador_diario=1 if smoking==1
replace fumador_diario=0 if smoking==2 
replace fumador_diario=0 if smoking==3
replace fumador_diario=0 if smoking==4
replace fumador_diario=0 if smoking==5
replace fumador_diario=0 if smoking==6
label def fumador_d      0 "No fumador diario" ///
                         1 "Fumador diario" 
label val fumador_diario fumador_d						 
						 				 
*Fumador ocasional
g fumador_ocasional=smoking
replace fumador_ocasional=0 if smoking==1
replace fumador_ocasional=1 if smoking==2 
replace fumador_ocasional=1 if smoking==3
replace fumador_ocasional=0 if smoking==4
replace fumador_ocasional=0 if smoking==5
replace fumador_ocasional=0 if smoking==6
label def fumador_o      0 "No fumador ocasional" ///
                         1 "Fumador ocasional" 
label val fumador_ocasional fumador_o	

*Ex fumador
g exfumador=smoking
replace exfumador=0 if smoking==1
replace exfumador=0 if smoking==2 
replace exfumador=0 if smoking==3
replace exfumador=1 if smoking==4
replace exfumador=1 if smoking==5
replace exfumador=0 if smoking==6
label def exfumad        0 "No exfumador" ///
                         1 "Exfumador" 
label val exfumador exfumad	

*No fumador
g nofumador=smoking
replace nofumador=0 if smoking==1
replace nofumador=0 if smoking==2 
replace nofumador=0 if smoking==3
replace nofumador=0 if smoking==4
replace nofumador=0 if smoking==5
replace nofumador=1 if smoking==6
label def nofumad        0 "Fumador" ///
                         1 "No fumador" 
label val nofumador	nofumad		

*Grupo de edad (14 a 65 años) 
gen edadnse=edad
replace edadnse=. if edad<=14
replace edadnse=. if edad>=65
tab  edadnse
label var edadnse "edad para NSE:de los 15 a los 64 años"

*GRUPOS DE EDAD / ADOLESCENTES Y ADULTOS (NACIONAL / 19 grupos de edad)
recode edad (10/14=1 "10-14 años")(15/19=2 "15-19 años") (20/24=3 "20-24 años") (25/29=4 "25-29 años") ///
(30/34=5 "30-34 años") (35/39=6 "35-39 años") (40/44=7 "40-44 años") (45/49=8 "45-49 años") ///
(50/54=9 "50-54 años") (55/59=10 "55-59 años") (60/64=11 "60-64 años") ///
(65/69=12 "65-69 años")(70/74=13 "70-74 años") (75/79=14 "75-79 años") ///
(80/84=15 "80-84 años")(85/89=16 "85-89 años") (90/94=17 "90-94 años") ///
(95/99=18 "95-99 años")(100/112=19 "100-112 años"), gen(grupedad_n)
label var grupedad_n "Grupos de edad, ECEA nal"
tab grupedad_n

*GRUPOS DE EDAD / ADOLESCENTES Y ADULTOS (NACIONAL / 16 grupos de edad)
recode edad (10/14=1 "10-14 años")(15/19=2 "15-19 años") (20/24=3 "20-24 años") (25/29=4 "25-29 años") ///
(30/34=5 "30-34 años") (35/39=6 "35-39 años") (40/44=7 "40-44 años") (45/49=8 "45-49 años") ///
(50/54=9 "50-54 años") (55/59=10 "55-59 años") (60/64=11 "60-64 años") ///
(65/69=12 "65-69 años")(70/74=13 "70-74 años") (75/79=14 "75-79 años") ///
(80/84=15 "80-84 años")(85/112=16 "85-112 años"), gen(grupedad85_n)
label var grupedad85_n "Grupos de edad, hasta los 85 años y más ECEA nal"
tab grupedad85_n									

*GRUPOS DE EDAD / ADOLESCENTES Y ADULTOS (REGIONAL / 6 grupos de edad)
*(para las estimaciones regionales se usan menos grupos de edad para que queden suficientes observ)
recode edad (10/14=1 "10-14 años")(15/24=2 "15-24 años") (25/44=3 "25-44 años") (45/64=4 "45-64 años") ///
(65/84=5 "65-84 años") (85/112=6 "85-112 años"), gen(grupedad_r)
label var grupedad_r "Grupos de edad, ECEA subnal"
tab grupedad_r

*ENTIDAD
g entidad=ent
label define entidad 	1 "Aguascalientes" 2 "Baja California" 3 "Baja California Sur" 4 "Campeche" 5 "Coahuila de Zaragoza" 6 "Colima" ///
						7 "Chiapas" 8 "Chihuahua" 9 "Ciudad de México" 10 "Durango" 11 "Guanajuato" 12 "Guerrero" 13 "Hidalgo" 14 "Jalisco" ///
						15 "Estado de México" 16 "Michoacán de Ocampo" 17 "Morelos" 18 "Nayarit" 19 "Nuevo León" 20 "Oaxaca" 21 "Puebla" ///
						22 "Querétaro" 23 "Quintana Roo" 24 "San Luis Potosí" 25 "Sinaloa" 26 "Sonora" 27 "Tabasco" 28 "Tamaulipas" ///
						29 "Tlaxcala" 30 "Veracruz" 31 "Yucatán" 32 "Zacatecas"
label value entidad entidad

*ÁMBITO (URBANO / RURAL) // NOTA: PARA URBANO Y RURAL SE UTILIZÓ LA VARIABLE "población", TAMBIÉN SE UTILIZÓ LA VARIABLE DE "dominio".
g poblacion=dominio
label def pobl 1"Urbano" 2"Rural"
label val poblacion pobl
label var poblacion"Tipo de población"

*ÁMBITO (DUMMIE)
g poblacion2=dominio
recode poblacion2 (1=2) (2=1)
label def pobla 1"Rural" 2"Urbano"
label var poblacion2 pobla
label var poblacion2 "tipo de poblacion"

save "$datos/2018/tabla_adol_adul.dta", replace

log close
