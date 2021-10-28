 // Sólo se considera para otros BARONET con L&M, LM BARONET
 // recodificar variable (marca2)  
 // para mantener el mismo codigo
 // generar variables de 
 // replace marca2 = "xBOOTS" if marca2 == "BOOTS" 

ta marca2, sum(ppu)
// tipo_marca
gen tipo2 = .
replace tipo2 = 3 if marca2_str == "ALAS"
replace tipo2 = 4 if marca2_str == "BAHREIN"
replace tipo2 = 4 if marca2_str == "BARONET"
replace tipo2 = 4 if marca2_str == "BOHEMIOS"
replace tipo2 = 4 if marca2_str == "DALTON"
replace tipo2 = 4 if marca2_str == "DONTABAKO"
replace tipo2 = 1 if marca2_str == "DUNHILL BLONDE"
replace tipo2 = 2 if marca2_str == "FAROS"
replace tipo2 = 2 if marca2_str == "FIESTA"
replace tipo2 = 3 if marca2_str == "FORTUNA"
replace tipo2 = 4 if marca2_str == "GARAÑON"
replace tipo2 = 1 if marca2_str == "KENT"
replace tipo2 = 4 if marca2_str == "L&M"
replace tipo2 = 4 if marca2_str == "LAREDO"
replace tipo2 = 4 if marca2_str == "LM BARONET"
//replace tipo2 = 2 if marca2_str == "MURATTI"
// criterio promedio de la distancia absoluta:
replace tipo2 = 3 if marca2_str == "MURATTI"
replace tipo2 = 4 if marca2_str == "RGD"
replace tipo2 = 4 if marca2_str == "RODEO"
replace tipo2 = 4 if marca2_str == "ROMA"
replace tipo2 = 1 if marca2_str == "SALEM"
replace tipo2 = 4 if marca2_str == "SCENIC 101"
replace tipo2 = 4 if marca2_str == "SENECA"
replace tipo2 = 1 if marca2_str == "VICEROY"
replace tipo2 = 3 if marca2_str == "WINSTON"

ta tipo2, su(ppu)

