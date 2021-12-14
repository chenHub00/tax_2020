
import delimited datos/prelim/de_inpc/to_graph.csv, clear 

save datos/prelim/de_inpc/to_graph.dta, replace

use datos/prelim/de_inpc/to_graph.dta, clear

gen year= real(substr(fecha,1,4))
gen month= real(substr(fecha,6,2))

gen ym = ym(year,month)
format ym %tm

drop otros count

rename marca marca_str
encode marca_str, gen(marca)

ta marca
label list marca
/*
. label list marca
marca:
           1 Bahrein
           2 Baronet
           3 Benson & Hedges
           4 Bohemios
           5 Camel
           6 Chesterfield
           7 Dalton
           8 Dontabako
           9 Garañon
          10 Laredo
          11 Lucky Strike
          12 Marlboro
          13 Montana
          14 Pall Mall
          15 Rgd
          16 Rodeo
          17 Roma
          18 Scenic 101
          19 Seneca

*/
drop marca_str
reshape wide prom_ppu, i(ym) j(marca) 

rename prom_ppu1 Bahrein 	
rename prom_ppu2 Baronet
rename prom_ppu3 Benson
label variable Benson "Benson & Hedges"
rename prom_ppu4 Bohemios
rename	prom_ppu5	Camel
rename	prom_ppu6	Chesterfield
rename	prom_ppu7	Dalton
rename	prom_ppu8 Dontabako
rename	prom_ppu9	Garanon
label variable Garanon "Garañon"
rename	prom_ppu10	Laredo
rename	prom_ppu11	Lucky
label variable Lucky "Lucky Strike"
rename	prom_ppu12	Marlboro
rename	prom_ppu13	Montana
rename	prom_ppu14	PallMall
label variable PallMall "Pall Mall"
rename	prom_ppu15	Rgd
rename	prom_ppu16	Rodeo
rename	prom_ppu17	Roma
rename	prom_ppu18	Scenic101
label variable Scenic101 "Scenic 101"
rename	prom_ppu19	Seneca


save datos/prelim/de_inpc/to_graph_wide_renamed.dta, replace
export delimited using "datos\prelim\de_inpc\to_graph_wide_renamed.csv", replace

export excel using "datos\prelim\de_inpc\to_graph_wide_renamed.xlsx",  firstrow(variables) replace
