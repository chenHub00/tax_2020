sysuse auto.dta, clear
*ssc install outreg2
gen  wtsq  = weight^2
foreach s in price headroom trunk{ 
    xi: reg `s' weight wtsq, vce(robust)
    outreg2 weight wtsq using tab_base_`s'_j, keep(weight wtsq) bdec(3) nocons  tex(fragment) replace
    xi: reg `s' weight wtsq foreign, vce(robust)
    outreg2 weight wtsq foreign using tab_base_`s'_j, keep(weight wtsq foreign) bdec(3) nocons  tex(fragment) append
    xi: reg `s' weight wtsq foreign length, vce(robust)
    outreg2 weight wtsq foreign length using tab_base_`s'_j, keep(weight wtsq foreign length) bdec(3) nocons  tex(fragment) append
} 
