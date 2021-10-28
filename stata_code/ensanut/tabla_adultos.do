*Uso de la base de datos de adultos
use "$datos/CS_ADULTOS.dta", clear

*Factor de expansión 
g factor=f_20mas
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
*g upm_dis=UPM_DIS
*g est_dis=EST_DIS

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
*g nse5F=SOCIO_nse5F
// DISPONIBLE EN:?

do "$codigo/vars_adolec_adult.do"

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
save "$datos/vars_adultos.dta", replace
