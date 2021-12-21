

*************************************************************
*Agrupación de las bases finales de cada año en la base final_total
*************************************************************
clear
set more off
foreach i of global anios {
//  	if `i'==2008 { 
//       	use "$path/ENIGH_`i'/Microdatos/final_ecea2.dta"
//       	g anio=`i'

		use "datos/prelim/de_enigh/2016/final_ecea2.dta", clear
       	g anio=2016
//	}
//  	if `i'==2010 |`i'==2012 | `i'==2014 | `i'==2016 | `i'==2018 {
//       	append using "$path/ENIGH_`i'/Microdatos/final_ecea2.dta"
		append using "datos/prelim/de_enigh/2018/final_ecea2.dta"
       	replace anio=`i' if anio==.
//	}
}

*OJO: hay 1445 observ que tienen el mismo identificador en ENIGH 2016 y ENIGH 2018
*Por lo tanto, el id único una vez que se unen las bd es:
duplicates report folioviv foliohog anio

*NO olvidar que hay 167 observ con info de cajetillas pero fumcigs==0 xq corresponden a autoconsumo o regalos
*i.e. gasto no mon, pero gascigs (q viene de gas_tri o monetario) = 0. NO voy a considerar su info de cajetillas:
*(al integrar enighs previas a 2016 son 214 observ)
*foreach var in gastocigshog gastocigspers cigsemkg cajetillas cajetillastri {
foreach var in gastocigs cigsemkg cajetillas cajetillastri {
	replace `var'=. if fumcigs==0
}
rename gastocigs expcig
*Hay 2 observ con gastocigspers=0 que son fumcigs=1 porque tienen info de gastocigshog 
*(recordar que gastocigspers=0 en todos los casos para clave de cigarros A239)	
g qcig = cajetillastri 
su

*Como puede haber upm con mismo identificador en 2016 y 2018, se crea clust específico por año:
*(se compararon bd de 2016 y 2018 y queda claro que los id de upm no se refieren a la misma zona geografica
*por ejemplo, en algunos casos misma upm entre rounds para entidades diferentes)
tostring anio, replace
g clust = upm + anio
destring anio, replace
destring clust, replace	
*Definicion alternativa de cluster con municipio + anio:
tostring municipio anio, replace
g mun = municipio + anio
destring municipio anio mun, replace
rename mun clust2

***			Consistencia info de gasto			***	
***Revisamos diferencia entre var de gasto trimestral en tabaco incluida en bd concentradohogar y var construida con info 
*de var gas_tri de variable gastoshogar
g difgastocigs = gastotabinegi - gastocigs_nodef
su difgastocigs, d //solo hay dif importante en 3 observ (1 de 2016 y 2 de 2018) y puede ser xq la var del concentrado incluye info de todo tabaco
***Revisamos consistencia de variable de gasto trimestral normalizada con var de gasto sin normalizar de bd gastoshogar 
*dado q la variable sin normalizar es semanal, al multiplicarla aproximadamente por 12 se debería obtener info trimestral
g prueba = gastocigs/gastosem
g prueba2 = gastotabinegi/gastosem
su prueba*	//alrededor de 12.9 en todos los casos 
drop prueba* difgasto* 


do "codigo/elasticidad/0_Variables_MODELO.do"

// save "$ecea2/final_total_ecea2.dta",replace	
	save "datos/prelim/de_enigh/final_total_ecea2.dta", replace
