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

keep ponde_g20 Upm H0302 H0303 ENTIDAD estrato AD1A01 AD1A04A AD1A02B AD1A03 ///
	FOLIO_I ID_INT est_sel AD1A05
/*Identificar variables como en 2018 */
rename AD1A05 ad1a05

gen e_cig = ad1a05 == 1 | ad1a05 == 2
* NO: gen algun_e_cig 

*Factor de expansión : 
* ? puede ser ponde_g20
g factor=ponde_g
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
g upm_dis=Upm
*g est_dis=est_sel

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
*g nse5F=SOCIO_nse5F
*g nse5F=socio_nse5f
rename H0302 sexo

*do "$codigo/vars_adoles_adult.do"
rename H0303 edad
rename ENTIDAD entidad
destring entidad, replace
gen dominio = estrato == 2 |  estrato == 3 
replace dominio = 2 if estrato == 1

*Identificador de adolescente
g adolescente=1 if factor!=.

*Definición de fumador (homologada a GATS y ENCODAT 2016):
* 2.1 Actualmente, ¿fuma tabaco…
rename AD1A01 ad1a01
rename AD1A04A ad1a04a

* 2.5 En el pasado ¿Has fumado productos del tabaco… AD1A04A
* 1= todos los dìas, 2 = algunos dìas, 3= nunca ha fumado, 4=No responde
/* smoking (fumador), p1_2, p1_3, p1_4 de ensanut 2018*/
*Definición internacional de fumador actual SIN filtro de 100 cigs en la vida:
g smoking=1 if ad1a01==1 
replace smoking=2 if ad1a01==2 
replace smoking=3 if ad1a04a==3
replace smoking=4 if ad1a01==3 & ad1a04a==1 
replace smoking=5 if ad1a01==3 & ad1a04a==2 
replace smoking=6 if ad1a01==3 & ad1a04a==3 
label def smoking 1 "Fumador diario" 2 "Fumador ocasional, antes fumador diario" 3 "Fumador ocasional, nunca fumador diario" 4 "Exfumador diario" 5 "Exfumador ocasional" 6 "Nunca fumador"
label val smoking smoking
ta smoking

/* smoking (fumador), p1_2, p1_3, p1_4 de ensanut 2018*
rename AD1A01 p1_2 
recode p1_2 (9 = 8)
gen p1_3 = 1 if AD1A04A == 1 
replace p1_3 = 2 if AD1A04A  == 2 | AD1A04A  == 3 
replace p1_3 = 8 if AD1A04A  == 9
rename AD1A04A p1_4

g smoking=1 if p1_2==1 replace smoking=2 if p1_2==2 & p1_3==1 
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
ta smoking*/
g fumador=1 if smoking>=1 & smoking<=3
replace fumador=0 if smoking>=4 & smoking<=6
label var fumador "Fumador actual de tabaco segun GATS"
label val fumador fum
ta fumador

rename AD1A02B ad1a02b 
rename AD1A03 ad1a03

*Promedio de cigarros fumados al día (fum diarios) & a la semana (fum ocasionales)
	*Número de cigarros por día
	g cant_cig=ad1a02b if (ad1a02b>0 & ad1a02b<888) 
	*Número de cigarros por semana, se dividen entre 7 para obtener el diario
	replace cant_cig=ad1a03/7 if cant_cig==. & (ad1a03>0 & ad1a03<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día en Adolescentes"
	g cant_cig_diario=ad1a02b if (ad1a02b>0 & ad1a02b<888) 
	g cant_cig_semanal=ad1a03 if (ad1a03>0 & ad1a03<888)							

/* 2.3 En promedio, ¿cuántos cigarros fuma actualmente por día?
rename AD1A02B p1_6_1 
rename AD1A03 p1_6_2

*Promedio de cigarros fumados al día //Se construye a partir de el reporte "por día" y "por semana"
	*Número de cigarros por día
	g cant_cig=p1_6_1 if (p1_6_1>0 & p1_6_1<888) // se eliminan los valores 888
	*Número de cigarros por semana // se dividen entre 7 para obtener el diario
	replace cant_cig=p1_6_2/7 if cant_cig==. & (p1_6_2>0 & p1_6_2<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día en Adolescentes"
*/

gen cons_dual = fumador == 1 & e_cig == 1
	
keep ad1a05 ad1a02b ad1a03 ad1a04a ad1a01 ///
	adole factor factormiles sexo upm_ est_sel ///
	edad entidad dominio FOLIO_I ID_INT ///
	smoking fumador cant_cig e_cig cons_dual 

save "$datos\2020\tabla_adolescentes.dta", replace


/* ------------------------------ 2018 -------------------------------- */
use "$datos\2018\CS_ADOLESCENTES.dta", clear

keep f_10a19 upm_dis viv_sel hogar numren est_dis ///
	sexo edad ent dominio p1_2 p1_3 p1_4 p1_6_1 p1_6_2 ///
	p1_10 p1_9 // cigarro electronico
	
	gen e_cig = p1_9  == 1 | p1_9 == 2
	gen algun_e_cig = p1_10 == 1 | e_cig  == 1
	
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

gen cons_dual = fumador == 1 & e_cig == 1
	
keep p1_2 p1_3 p1_4 p1_6_1 p1_6_2 p1_10 p1_9 ///
	adole factor factormiles sexo est_dis ///
	edad ent dominio upm_dis viv_sel hogar numren ///
	smoking fumador cant_cig e_cig cons_dual algun_e_cig 
	
save "$datos\2018\tabla_adolescentes.dta", replace

log close
