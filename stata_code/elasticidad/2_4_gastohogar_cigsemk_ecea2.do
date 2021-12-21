*************************************************
*Número de cajetillas consumidas x día y x trimestre por hogar  
*************************************************
*En los casos en los que la cantidad consumida por semana es mayor o igual a 1 kg, se imputa la media
*Aquí ya no se considera info de bd de gastospersona xq se tienen muy pocas observ y en todos los casos gasto_tri=0
clear
set more off	
foreach i of global anios {
	tempfile cajetillas`i'
	// use "$path/ENIGH_`i'/Microdatos/gastoshogar.dta"
	use "$path/ENIGH/`i'/gastoshogar.dta"

	keep if clave=="A239"
	su cantidad gasto 
	*La variable costo solo existe desde ENIGH 2012 pero no se usa, es solo para revisar consist de info como sigue:
	*su cantidad gasto costo 
	*En kg; todas las observaciones >0 y <1 pero al sumar x hog sí quedan 36 observ >=1
	*OJO: info de costo es para tipo_gasto 3 o 5 (autoconsumo o regalo) y se registra como gasto no mon
	*Los que tienen info de costo sí tienen info de cantidad, pero no de gasto por lo que no tendrán preciounit (o sería 0)
	*tampoco tienen gasto_tri (gasto monetario), por lo que estarán clasificados como no fumadores (fumcigs=0).
	*La variable gasto es por ocasion de compra, por eso se suma por hogar abajo, al igual que la cantidad:
	egen cigsemkg = total(cantidad), by(folioviv foliohog)
	egen gastosem = total(gasto), by(folioviv foliohog)
	collapse (mean) cigsemkg gastosem, by(folioviv foliohog)
	su cigsemkg
	su cigsemkg if cigsemkg>=1
    *En 6 observ en 2016 y otras 6 en 2018 cigsemkg>=1 (mas de 40 caj por semana)
	*en esos casos no se considera su info de precio 
	*replace preciounit = . if cigsemkg>=1
	*replace preciounitdef = . if cigsemkg>=1
	*su cigsemkg if cigsemkg<1
    *replace cigsemkg = r(mean) if cigsemkg>=1	
    *Se transforma la cantidad de kg a gr 
    *(suponemos que 1 kg es igual a 40 cajetillas)	
	g cajetillas = ((cigsemkg*1000)/7)*(1/25)
	g cajetillastri = ((cigsemkg*1000)*12)*(1/25)
	*su cigsemkg cajetillas preciounit
	su cigsemkg cajetillas cajetillastri gastosem	
	label var cigsemkg "Kg cigarros consumidos a la semana por hogar"
	label var cajetillas "Cajetillas consumidas al día por hogar"
	label var gastosem "Gasto semanal en cigs directo de base de gastoshogar"
	*label var preciounit "Precio (valor) unitario por cajetilla"
	*g lncajetillas = ln(cajetillas)
	save `cajetillas`i''	
	
//	use "$path/ENIGH_`i'/Microdatos/final_ecea2.dta", clear
	use "$path/ENIGH/`i'/final_ecea2.dta", clear

	joinby folioviv foliohog using `cajetillas`i'', unmatched(both)
	ta _merge
	drop _merge
	// save "$path/ENIGH_`i'/Microdatos/final_ecea2.dta", replace 
	save "$path/ENIGH/`i'/final_ecea2.dta", replace
	duplicates repor folioviv foliohog 
}	
