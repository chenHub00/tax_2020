
use datos\ensanut\CS_ADOLESCENTES.dta, clear

*Factor de expansión 
g factor=f_10a19
g factormiles=factor/1000

*Se homologa el nombre de las variables (adultos y adolescentes)
*g upm_dis=UPM_DIS
*g est_dis=EST_DIS

*Se homologa el nombre de la variable de nivel socioeconómico (quintiles)
*g nse5F=SOCIO_nse5F
*g nse5F=socio_nse5f

do "$codigo/vars_adolec_adult.do"

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

save "$datos/vars_adolecentes.dta", replace
