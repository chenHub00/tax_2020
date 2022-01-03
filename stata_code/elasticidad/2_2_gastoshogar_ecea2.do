************************************
*Hogares fumadores de cigarros y gasto trimestral (positivo) en cigs
************************************
clear 
set more off
foreach i of global anios {	
	tempfile fumador`i'
	//use "$path/ENIGH_`i'/Microdatos/gastoshogar.dta"
	di "`i'"
	use "$path/ENIGH/`i'/gastoshogar.dta"		

	keep if clave=="A239"
// 	if `i'==2008 | `i'==2010 {	
// 		rename gas_tri gasto_tri 
// 	}		
	collapse (sum) gasto_tri, by(folioviv foliohog)
	rename gasto_tri gastocigs
	su gastocigs 
	*rename gasto_tri gastocigshog
	*su gastocigshog 
	save `fumador`i''

*	tempfile fumadorpersona`i'
*	use "$path/ENIGH_`i'/Microdatos/gastospersona.dta"
*	use "$path/ENIGH/`i'/gastospersona.dta"
	*if `i'==2014 {						//ningun caso con clave A239
	*	g gastocigspers=0
	*	collapse (sum) gastocigspers, by(folioviv foliohog)
	*}
*	if `i'==2012 | `i'==2016 | `i'==2018 | `i'==2020 {
*		keep if clave=="A239" 
*		collapse (sum) gasto_tri, by(folioviv foliohog)
*		rename gasto_tri gastocigspers //solo 3 casos en total en ambas encuestas, todos = 0
*		su gastocigspers 
*	}	
*	save `fumadorpersona`i''
	
//	use "$path/ENIGH_`i'/Microdatos/final_ecea2.dta", clear
	use "$path/ENIGH/`i'/final_ecea2.dta", clear

	joinby folioviv foliohog using `fumador`i'', unmatched(both)
	ta _merge
	drop _merge
*	if `i'==2012 | `i'==2014 | `i'==2016 | `i'==2018 | `i'==2020 {
*		joinby folioviv foliohog using `fumadorpersona`i'', unmatched(both)
*		ta _merge
*		drop _merge		
*		su gastocigshog gastocigspers
*		egen gastocigs = rowtotal(gastocigshog gastocigspers), miss
*	}		
	su gastocigs	
	replace gastocigs = . if gastocigs==0
	g fumcigs = 1 if gastocigs>0 & gastocigs!=.
	replace fumcigs = 0 if gastocigs==.
	ta fumcigs
	su gastocigs
	rename gastocigs gastocigs_nodef
// 	if `i'==2008 {
// 		g gastocigs=gastocigs_nodef*1.49704292			
// 	}	
// 	if `i'==2010 {
// 		g gastocigs=gastocigs_nodef*1.37411803			
// 	}	
// 	if `i'==2012 {
// 		g gastocigs=gastocigs_nodef*1.27058705			
// 	}	
// 	if `i'==2014 {
// 		g gastocigs=gastocigs_nodef*1.17920676			
// 	}		
	if `i'==2016 {
	*	rename gastocigshog gastocigshog_nodef
	*	rename gastocigspers gastocigspers_nodef
	*	g gastocigshog=gastocigshog_nodef*1.11895244
	*	g gastocigspers=gastocigspers_nodef*1.11895244
		g gastocigs=gastocigs_nodef*1.11895244
	}
	if `i'==2018 {
	*	rename gastocigshog gastocigshog_nodef
	*	rename gastocigspers gastocigspers_nodef
	*	g gastocigshog=gastocigshog_nodef*1
	*	g gastocigspers=gastocigspers_nodef*1
		g gastocigs=gastocigs_nodef*1
	}
	
	if `i'==2020 {
	*	rename gastocigshog gastocigshog_nodef
	*	rename gastocigspers gastocigspers_nodef
	*	g gastocigshog=gastocigshog_nodef*1
	*	g gastocigspers=gastocigspers_nodef*1
		g gastocigs=gastocigs_nodef*0.929871367
	}
	
//	save "$path/ENIGH_`i'/Microdatos/final_ecea2.dta", replace
	save "$path/ENIGH/`i'/final_ecea2.dta", replace
	duplicates repor folioviv foliohog 
}

