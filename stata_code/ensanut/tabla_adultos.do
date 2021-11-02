/*
Variables de tabla de adolescentes:
- factor, factor en miles, upm_dis, est_dis
- sexo
- fumador (smoking)
- cantidad de cigarros

*/
set more off 

capture log close
log using resultados/ensanut/tabla_adultos.log, replace

do stata_code/ensanut/dirEnsanut.do

/* ------------------------------ 2020-------------------------------- */

*Uso de la base de datos de adultos
use "$datos\2020\adultos_vac_tab_ensanut2020_w.dta", clear

*Factor de expansión 
g factor=ponde_g
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
*g upm_dis=UPM_DIS
*g est_dis=EST_DIS

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
*g nse5F=SOCIO_nse5F
// DISPONIBLE EN:?
rename H0302 sexo

*do "$codigo/vars_adoles_adult.do"

*Identificador de adulto
g adulto=1 if factor!=.

* 2.1 Actualmente, ¿fuma tabaco…
rename ADUL1A01 p13_2
recode p13_2 (9 = 8)

* 2.5 En el pasado ¿Has fumado productos del tabaco… AD1A04A
* 1= todos los dìas, 2 = algunos dìas, 3= nunca ha fumado, 4=No responde
gen p13_3 = 1 if ADUL1A04A == 1 
replace p13_3 = 2 if ADUL1A04A == 2 | ADUL1A04A == 3 
replace p13_3 = 8 if ADUL1A04A == 9
rename ADUL1A04A p13_4

/* smoking (fumador), p13_2, p13_3 y p13_4 de ensanut 2018*/
g smoking=1 if p13_2==1 
*Definición de fumador (homologada a GATS y ENCODAT 2016):
replace smoking=2 if p13_2==2 & p13_3==1 
replace smoking=3 if p13_2==2 & p13_3==2 
replace smoking=4 if p13_2==3 & p13_4==1 
replace smoking=5 if p13_2==3 & p13_4==2 
replace smoking=6 if p13_2==3 & p13_4==3 
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

* 2.3 En promedio, ¿cuántos cigarros fuma actualmente por día?
* al dia
rename ADUL1A02B p13_6
* semanales
rename ADUL1A03 p13_6_1

*Promedio de cigarros fumados al día //Se construye a partir de el reporte "por día" y "por semana"
	*Número de cigarros por día
	g cant_cig=p13_6 if (p13_6>0 & p13_6<888) 
	*Número de cigarros por semana // se dividen entre 7 para obtener el diario
	replace cant_cig=p13_6_1/7 if cant_cig==. & (p13_6_1>0 & p13_6_1<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día. Adultos"

*Guardado de la base de datos
save "$datos\2020\tabla_adultos.dta", replace

/* ------------------------------ 2018 -------------------------------- */

*Uso de la base de datos de adultos
use "$datos\2018\CS_ADULTOS.dta", clear

*Factor de expansión 
g factor=f_20mas
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
*g upm_dis=UPM_DIS
*g est_dis=EST_DIS

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
*g nse5F=SOCIO_nse5F
// DISPONIBLE EN:?

do "$codigo/vars_adoles_adult.do"

*Identificador de adulto
g adulto=1 if factor!=.

*Definición de fumador (homologada a GATS y ENCODAT 2016):
g smoking=1 if p13_2==1 
replace smoking=2 if p13_2==2 & p13_3==1 
replace smoking=3 if p13_2==2 & p13_3==2 
replace smoking=4 if p13_2==3 & p13_4==1 
replace smoking=5 if p13_2==3 & p13_4==2 
replace smoking=6 if p13_2==3 & p13_4==3 
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
	g cant_cig=p13_6 if (p13_6>0 & p13_6<888) 
	*Número de cigarros por semana // se dividen entre 7 para obtener el diario
	replace cant_cig=p13_6_1/7 if cant_cig==. & (p13_6_1>0 & p13_6_1<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día. Adultos"

*Guardado de la base de datos
save "$datos\2018\tabla_adultos.dta", replace

log close