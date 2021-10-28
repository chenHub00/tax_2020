use "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\datos\panel_marca2_ciudad.dta" 
ta marca
xtset
su dppu
ta marca2
use "C:\Users\chen\OneDrive\Documentos\R\tax_ene2020\tax_2020\datos\panel_marca_ciudad.dta"
ta marca2
ta marca
d,s
xtset
gen dppu = d.ppu
help tsst
help tsset
keep if y ym
keep if ym <= ym(2020,1)
di ym(2020,1)
keep if ym >= ym(2019,12)
d,s
ta ym
keep if ym >= ym(2020,1)
