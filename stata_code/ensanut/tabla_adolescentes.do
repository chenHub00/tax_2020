/*
Variables de tabla de adolescentes:
- factor, factor en miles, upm_dis, est_dis
- sexo
- fumador (smoking)
- cantidad de cigarros

*/
/* ------------------------------ 2020 -------------------------------- */
set more off 

capture log close
log using resultados/ensanut/tabla_adolescentes.log, replace

do stata_code/ensanut/dirEnsanut.do

use "$datos\2020\adolescentes_vac_tab_ensanut2020_w.dta", clear

/*Identificar variables como en 2018 */


*Factor de expansión : 
* ? puede ser ponde_g20
g factor=ponde_g
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
g upm_dis=Upm
g est_dis=est_sel

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
*g nse5F=SOCIO_nse5F
*g nse5F=socio_nse5f
rename H0302 sexo

*do "$codigo/vars_adoles_adult.do"

*Identificador de adolescente
g adolescente=1 if factor!=.

*Definición de fumador (homologada a GATS y ENCODAT 2016):
* 2.1 Actualmente, ¿fuma tabaco…
rename AD1A01 p1_2
recode p1_2 (9 = 8)

* 2.5 En el pasado ¿Has fumado productos del tabaco… AD1A04A
* 1= todos los dìas, 2 = algunos dìas, 3= nunca ha fumado, 4=No responde
gen p1_3 = 1 if AD1A04A == 1 
replace p1_3 = 2 if AD1A04A  == 2 | AD1A04A  == 3 
replace p1_3 = 8 if AD1A04A  == 9
rename AD1A04A p1_4

/* smoking (fumador), p1_2, p1_3, p1_4 de ensanut 2018*/
g smoking=1 if p1_2==1 
replace smoking=2 if p1_2==2 & p1_3==1 
replace smoking=3 if p1_2==2 & p1_3==2 
replace smoking=4 if p1_2==3 & p1_4==1 
replace smoking=5 if p1_2==3 & p1_4==2 
replace smoking=6 if p1_2==3 & p1_4==3 
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

* 2.3 En promedio, ¿cuántos cigarros fuma actualmente por día?
rename AD1A02B p1_6_1 
rename AD1A03 p1_6_2

*Promedio de cigarros fumados al día //Se construye a partir de el reporte "por día" y "por semana"
	*Número de cigarros por día
	g cant_cig=p1_6_1 if (p1_6_1>0 & p1_6_1<888) // se eliminan los valores 888
	*Número de cigarros por semana // se dividen entre 7 para obtener el diario
	replace cant_cig=p1_6_2/7 if cant_cig==. & (p1_6_2>0 & p1_6_2<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día en Adolescentes"

save "$datos\2020\tabla_adolescentes.dta", replace


/* ------------------------------ 2018 -------------------------------- */
use "$datos\2018\CS_ADOLESCENTES.dta", clear

*Factor de expansión 
g factor=f_10a19
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
*g upm_dis=UPM_DIS
*g est_dis=EST_DIS

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
*g nse5F=SOCIO_nse5F
*g nse5F=socio_nse5f

do "$codigo/vars_adoles_adult.do"

*Identificador de adolescente
g adolescente=1 if factor!=.

*Definición de fumador (homologada a GATS y ENCODAT 2016):
g smoking=1 if p1_2==1 
replace smoking=2 if p1_2==2 & p1_3==1 
replace smoking=3 if p1_2==2 & p1_3==2 
replace smoking=4 if p1_2==3 & p1_4==1 
replace smoking=5 if p1_2==3 & p1_4==2 
replace smoking=6 if p1_2==3 & p1_4==3 
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
	g cant_cig=p1_6_1 if (p1_6_1>0 & p1_6_1<888) // se eliminan los valores 888
	*Número de cigarros por semana // se dividen entre 7 para obtener el diario
	replace cant_cig=p1_6_2/7 if cant_cig==. & (p1_6_2>0 & p1_6_2<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día en Adolescentes"

save "$datos\2018\tabla_adolescentes.dta", replace


log close
