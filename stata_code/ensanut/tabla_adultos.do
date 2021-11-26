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

keep ADUL1A02B  ADUL1A03  ///
	ADUL1A04A ADUL1A01 ADUL1A05 ///
	ponde_g H0302 H0303 Upm est_sel ///
	ENTIDAD estrato FOLIO_I ID_INT

rename ADUL1A05 adul1a05
	
gen e_cig = adul1a05  == 1 | adul1a05 == 2
*NO: algun_e_cig 
	
*Factor de expansión 
g factor=ponde_g
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
g upm_dis=Upm
*g est_dis=est_sel

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
*g nse5F=SOCIO_nse5F
// DISPONIBLE EN:?
rename H0302 sexo

/* code to reuse the code for 2018 */
*do $codigo/rename_vars.do 
rename H0303 edad
rename ENTIDAD entidad
destring entidad, replace
gen dominio = estrato == 2 |  estrato == 3 
replace dominio = 2 if estrato == 1

*do "$codigo/vars_adoles_adult.do"

*Identificador de adulto
g adulto=1 if factor!=.

* 4/noviembre/2021
rename ADUL1A01 adul1a01
rename ADUL1A04A adul1a04a

g smoking=1 if adul1a01==1 
replace smoking=2 if adul1a01==2 
replace smoking=3 if adul1a04a==3 
replace smoking=4 if adul1a01==3 & adul1a04a==1 
replace smoking=5 if adul1a01==3 & adul1a04a==2 
replace smoking=6 if adul1a01==3 & adul1a04a==3 
label def smoking 1 "Fumador diario" 2 "Fumador ocasional, antes fumador diario" 3 "Fumador ocasional, nunca fumador diario" 4 "Exfumador diario" 5 "Exfumador ocasional" 6 "Nunca fumador"
label val smoking smoking
ta smoking

/** 2.1 Actualmente, ¿fuma tabaco…
rename ADUL1A01 p13_2
recode p13_2 (9 = 8)

* 2.5 En el pasado ¿Has fumado productos del tabaco… AD1A04A
* 1= todos los dìas, 2 = algunos dìas, 3= nunca ha fumado, 4=No responde

gen p13_3 = 1 if ADUL1A04A == 1 
replace p13_3 = 2 if ADUL1A04A == 2 | ADUL1A04A == 3 
replace p13_3 = 8 if ADUL1A04A == 9
rename ADUL1A04A p13_4

* smoking (fumador), p13_2, p13_3 y p13_4 de ensanut 2018
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
ta smoking*/
g fumador=1 if smoking>=1 & smoking<=3
replace fumador=0 if smoking>=4 & smoking<=6
label var fumador "Fumador actual de tabaco segun GATS"
label def fum   0 "No fumador actual" 1 "Fumador actual"
label val fumador fum
ta fumador

* 2.3 En promedio, ¿cuántos cigarros fuma actualmente por día?
* al dia
rename ADUL1A02B adul1a02b
* semanales
rename ADUL1A03 adul1a03

*Promedio de cigarros fumados al día (fum diarios) & a la semana (fum ocasionales)
	*Número de cigarros por día
	g cant_cig=adul1a02b if (adul1a02b>0 & adul1a02b<888) 
	*Número de cigarros por semana // se dividen entre 7 para obtener el diario
	replace cant_cig=adul1a03/7 if cant_cig==. & (adul1a03>0 & adul1a03<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día. Adultos"
	g cant_cig_diario=adul1a02b if (adul1a02b>0 & adul1a02b<888) 							
	g cant_cig_semanal=adul1a03 if (adul1a03>0 & adul1a03<888)					
 

/*rename ADUL1A02B p13_6
* semanales
rename ADUL1A03 p13_6_1

*Promedio de cigarros fumados al día //Se construye a partir de el reporte "por día" y "por semana"
	*Número de cigarros por día
g cant_cig=p13_6 if (p13_6>0 & p13_6<888) 
	*Número de cigarros por semana // se dividen entre 7 para obtener el diario
	replace cant_cig=p13_6_1/7 if cant_cig==. & (p13_6_1>0 & p13_6_1<888)
	*Etiquetado de la variable
	label var cant_cig "Número de cigarros fumados al día. Adultos"
*/
gen cons_dual = fumador == 1 & e_cig == 1

keep adul1a02b adul1a03 adul1a04a adul1a01 adul1a05 ///
	adulto factor factormiles sexo upm_ est_sel ///
	edad entidad dominio FOLIO_I ID_INT ///
	smoking fumador cant_cig e_cig cons_dual 
	
*keep upm est_sel factor factormiles sexo edad smoking* fumador* cant_cig* exfumador exfumtiempo entidad region_cv 
*FOLIO_I ID_INT
	
*Guardado de la base de datos
save "$datos\2020\tabla_adultos.dta", replace

/* ------------------------------ 2018 -------------------------------- */

*Uso de la base de datos de adultos
use "$datos\2018\CS_ADULTOS.dta", clear
*entidad 
keep p13_2 p13_3 p13_4 ///
	p13_6 p13_6_1 ///
	p13_9 p13_10  /// e_cig
	f_20mas sexo edad ent dominio upm est_dis ///
	upm_dis viv_sel hogar numren 
	
gen e_cig = p13_9  == 1 | p13_9 == 2
gen algun_e_cig = p13_10 == 1 | e_cig  == 1
		
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

	gen cons_dual = fumador == 1 & e_cig == 1
	
	keep p13_2 p13_3 p13_4 ///
	p13_6 p13_6_1 ///
	factor factormiles sexo edad dominio upm_dis est_dis ///
	ent viv_sel hogar numren ///
	cant_cig fumador smoking adulto cons_dual e_cig algun_e_cig 
	

*Guardado de la base de datos
save "$datos\2018\tabla_adultos.dta", replace

log close
