 // marca.do
 

ta marca, sum(ppu)
// tipo_marca
// chesterfield + delicados?
// grupo 1
gen tipo = 1 if marca == 1 | marca == 2 | marca == 5
replace tipo = 2 if marca == 4 | marca == 7
replace tipo = 3 if marca == 3 | marca == 6

label define tipo 1 "premium" 2 "medio" 3 "bajo"
label values tipo tipo
