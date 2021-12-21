
*******************************
*Adultos en el hogar
*******************************
*miembros del hogar se identifican con parentesco= 1,2,3,5 o 6
clear
set more off
foreach i of global anios {	
	tempfile adultos`i'
	// use "$path/ENIGH_`i'/Microdatos/poblacion.dta"
	use "datos/enigh/`i'/poblacion.dta"

	if `i'==2008 {	
		rename parentesco parentor
		g parentesco = parentor
		tostring parentesco, replace
	}
	gen adultos = 1 if (edad>17 & edad!=.) & ((real(substr(parentesco,1,1))>=1 & real(substr(parentesco,1,1))<=3)| ///
		(real(substr(parentesco,1,1))>=5 & real(substr(parentesco,1,1))<=6))
	ta parentesco if adultos!=. 
	ta adultos
	collapse (sum) adultos, by(folioviv foliohog)
	gen adultos2 =adultos*adultos
	keep folioviv foliohog adultos adultos2
	save `adultos`i''
	
//	use "$path/ENIGH_`i'/Microdatos/final_ecea2.dta", clear
	use "datos/prelim/de_enigh/`i'/final_ecea2.dta", clear

	joinby folioviv foliohog using `adultos`i'', unmatched(both)
	ta _merge
	drop _merge
//	save "$path/ENIGH_`i'/Microdatos/final_ecea2.dta", replace 
	save "datos/prelim/de_enigh/`i'/final_ecea2.dta", replace

	duplicates repor folioviv foliohog 	
}

