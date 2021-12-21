
*Generating additional variables for the model
gen uvcig=expcig/qcig
gen luvcig=ln(uvcig)
gen bscig=expcig/exptotal
replace bscig=0 if bscig==.
gen lhsize=ln(hsize)
gen lexp=ln(exptotal)
*tab sgroup, gen(sgp)
g ledadjefa=ln(edadjefa)
g adultratio = adultos/hsize
ta anio,g(anio)
 
