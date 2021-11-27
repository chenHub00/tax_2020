
capture log close
log using resultados/logs/desc_passthrough100.log, replace

use "datos/finales/pass_through100_jan2020.dta", clear

ta marca, su(pobs_dic2019)
ta marca, su(pt100_jan2020)
ta marca, su(pobs_jan2020)

ta tipo, su(pobs_dic2019)
ta tipo, su(pt100_jan2020)
ta tipo, su(pobs_jan2020)


use "datos/finales/pass_through100_jan2021.dta", clear

ta marca, su(pobs_dic2020)
ta marca, su(pt100_jan2021)
ta marca, su(pobs_jan2021)

ta tipo, su(pobs_dic2020)
ta tipo, su(pt100_jan2021)
ta tipo, su(pobs_jan2021)


log close
