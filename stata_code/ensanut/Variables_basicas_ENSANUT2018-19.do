*ENSANUT 2018
*Última actualización: 25/06/2020

clear
set more off

global bases "C:\Users\DELL\Desktop\Parámetros ENSANUT2018"
global tabulados "C:\Users\DELL\Desktop\Parámetros ENSANUT2018\Tabulados"

*******************************************DEFINICIÓN DE VARIABLES (BASES ADOLESCENTES/ADULTOS)*****************

*************************************************ADOLESCENTES****************
*Uso de la base de datos de adolescentes
use "$bases/ADOLESCENTES_VARS_EXTRA_16042020.dta", clear

*Factor de expansión 
g factor=F_10A19
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
g upm_dis=UPM_DIS
g est_dis=EST_DIS

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
g nse5F=SOCIO_nse5F

*Identificador de adolescente
g adolescente=1 if factor!=.

*Sexo
label def sex 1"hombre" 2"mujer"
label val sexo sex
label var sexo"Sexo"

*Definición de fumador (homologada a GATS y ENCODAT 2016):
g smoking=1 if ADOL_P1_2==1 
replace smoking=2 if ADOL_P1_2==2 & ADOL_P1_3==1 
replace smoking=3 if ADOL_P1_2==2 & ADOL_P1_3==2 
replace smoking=4 if ADOL_P1_2==3 & ADOL_P1_4==1 
replace smoking=5 if ADOL_P1_2==3 & ADOL_P1_4==2 
replace smoking=6 if ADOL_P1_2==3 & ADOL_P1_4==3 
label def smoking	1 "Fumador diario" ///
						2 "Fumador ocasional, antes fumador diario" ///
						3 "Fumador ocasional, nunca fumador diario" ///
						4 "Exfumador diario" ///
						5 "Exfumador ocasional" ///
						6 "Nunca fumador"
label val smoking smoking
ta smoking
g fumador=1 if smoking>=1 & smoking<=3
replace fumador=0 if smoking>=4 & smoking<=6
label var fumador "Fumador actual de tabaco segun GATS"
label val fumador fum
ta fumador

*Promedio de cigarros fumados al día //Se construye a partir de el reporte "por día" y "por semana"
	*Número de cigarros por día
	g cant_cig=ADOL_P1_6_1 if (ADOL_P1_6_1>0 & ADOL_P1_6_1<888) // se eliminan los valores 888
	*Número de cigarros por semana // se dividen entre 7 para obtener el diario
	replace cant_cig=ADOL_P1_6_2/7 if cant_cig==. & (ADOL_P1_6_2>0 & ADOL_P1_6_2<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día en Adolescentes"

*Guardado de la base de datos
save "$bases/ADOLESCENTES_PARA UNIR_20.04.2020.dta", replace

***************************************************ADULTOS**********************
*Uso de la base de datos de adultos
use "$bases/ADULTOS_VARS_EXTRA_16042020.dta", clear

*Factor de expansión 
g factor=F_20MAS
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
g upm_dis=UPM_DIS
g est_dis=EST_DIS

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
g nse5F=SOCIO_nse5F

*Identificador de adulto
g adulto=1 if factor!=.

*Definición de fumador (homologada a GATS y ENCODAT 2016):
g smoking=1 if ADULTOS_P13_2==1 
replace smoking=2 if ADULTOS_P13_2==2 & ADULTOS_P13_3==1 
replace smoking=3 if ADULTOS_P13_2==2 & ADULTOS_P13_3==2 
replace smoking=4 if ADULTOS_P13_2==3 & ADULTOS_P13_4==1 
replace smoking=5 if ADULTOS_P13_2==3 & ADULTOS_P13_4==2 
replace smoking=6 if ADULTOS_P13_2==3 & ADULTOS_P13_4==3 
label def smoking	1 "Fumador diario" ///
						2 "Fumador ocasional, antes fumador diario" ///
						3 "Fumador ocasional, nunca fumador diario" ///
						4 "Exfumador diario" ///
						5 "Exfumador ocasional" ///
						6 "Nunca fumador"
label val smoking smoking
ta smoking
g fumador=1 if smoking>=1 & smoking<=3
replace fumador=0 if smoking>=4 & smoking<=6
label var fumador "Fumador actual de tabaco segun GATS"
label def fum   0 "No fumador actual" 1 "Fumador actual"
label val fumador fum
ta fumador

*Promedio de cigarros fumados al día //Se construye a partir de el reporte "por día" y "por semana"
	*Número de cigarros por día
	g cant_cig=ADULTOS_P13_6 if (ADULTOS_P13_6>0 & ADULTOS_P13_6<888) 
	*Número de cigarros por semana // se dividen entre 7 para obtener el diario
	replace cant_cig=ADULTOS_P13_6_1/7 if cant_cig==. & (ADULTOS_P13_6_1>0 & ADULTOS_P13_6_1<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día. Adultos"

*Guardado de la base de datos
save "$bases/ADULTOS_PARA UNIR_20.04.2020.dta", replace

*****************************************************UNIÓN DE BASES DE DATOS*************************
use "$bases/ADOLESCENTES_PARA UNIR_20.04.2020.dta", clear

*Se une con la base de datos de adultos (append)
append using "$bases/ADULTOS_PARA UNIR_20.04.2020.dta"

*Guardado de la base de datos unida (base general)
save "$bases/Base_general_20.04.2020.dta", replace

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
                         1 "Fumador diario" ///					 
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
                         1 "Fumador ocasional" ///						 
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
                         1 "Exfumador" ///
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
                         1 "No fumador" ///						 
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

************************************************************DESCRIPTIVOS********************************************************
set more off

*Ponderación
svyset [pweight=factor], psu(upm_dis)strata (est_dis) singleunit(certainty)

*N EXPANDIDA EN POBLACIÓN NACIONAL POR SEXO Y REGIONES ECEA
*N EXPANDIDA EN POBLACIÓN NACIONAL (POR GRUPO DE EDAD REGIONAL) 
global vars "poblacion_t"
foreach v of global vars {
label def _var_`v' 0 "" 1 "`: var label `v''", replace
label val `v' _var_`v'
}
*Cuadro T1. En numero
tabout $vars grupedad_r using "$tabulados/`x'T1.txt", ///
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
tabout $vars using "$tabulados/`x'T1.txt", ///
	append f(1) c(freq) svy replace clab(n expandida) layout(col) cisep( , ) tot(Total Global) ///
	h1("Cuadro  expandida en las prevalencia . `: label (entidad) `x''")
svy: total poblacion_t
estat cv
