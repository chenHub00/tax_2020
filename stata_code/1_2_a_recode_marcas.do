 // 
 // recodificar variable (marca2)  
 // para mantener el mismo codigo
 // generar variables de 
 // 
replace marca2 = "xBOOTS" if marca2 == "BOOTS" 
replace marca2 = "yDELICADOS" if marca2 == "DELICADOS" 
replace marca2 = "wRALEIGH" if marca2 == "RALEIGH" 
replace marca2 = "zSHOTS" if marca2 == "SHOTS" 

 rename marca2 marca2_str
 encode marca2_str, gen(marca2)

ta marca2, sum(ppu)
// tipo_marca
// chesterfield + delicados?
// grupo 1
gen tipo2 = 1 if marca2 == 1 | marca2 == 2 | marca2 == 5 
replace tipo2 = 2 if marca2 == 4 | marca2 == 7 | marca2 == 8 | marca2 == 9
* 8: Raleigh, 9: Boots
replace tipo2 = 3 if marca2 == 3 | marca2 == 6 | marca2 == 10 | marca2 == 11
* 10: Delicados, 11: Shots 

label define tipo2 1 "premium" 2 "medio" 3 "bajo"
label values tipo2 tipo2

ta tipo2, su(ppu)

