* sin separar adultos de adolescentes
* con pruebas de medias:
* https://stats.idre.ucla.edu/stata/faq/how-can-i-do-a-t-test-with-survey-data/

do stata_code/ensanut/dirEnsanut.do

capture log close
log using $resultados/pruebas_t_adol.log, replace


************************************************************DESCRIPTIVOS********************************************************
set more off


/* 2018 -------------
use "$datos/2018/tabla_adol_adul.dta", clear*/
* 2018-2020
use "$datos/2020/adol_18_20.dta", clear

svyset [pweight=factor], psu(upm_dis) strata(est_sel) singleunit(certainty)

/* La muestra análitica: correctamente definida? */
gen insample = (grupedad_comp  <6 & gr_educ < 5)

/*------------------------------------------
sin distinguir adolescente / adulto
------------------------------------------*/
global var_desc "cant_cig"



foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"

	foreach vartab of varlist sexo grupedad_comp gr_educ nse5f poblacion  {
	    tabulate `vartab' periodo if insample == 1  &  `var_fum' == 1 [w=factor], sum(`var_fum') nost 
		su `vartab' if insample == 1 &  `var_fum' == 1
		local r_max = r(max)
		local r_min = r(min)
		foreach value of numlist `r_min'/`r_max' {
			di "tipo de fumador: `var_fum'"
			di "valor de `vartab': `value'"
			svy, subpop(if insample == 1 & `vartab' == `value' &  `var_fum' == 1): mean $var_desc, over(periodo) 
			svy, subpop(if insample == 1 & `vartab' == `value' &  `var_fum' == 1): mean $var_desc, over(periodo) coeflegend
			if (colsof(e(b)) == 2) {
				test  _b[c.$var_desc@2018bn.periodo] = _b[c.$var_desc@2020.periodo]
			} 
		}

	}	
}

log close

/*
collect: svy, subpop(if insample == 1 & gr_educ == 1 &  fumador_diario == 1): regress cant_cig i.periodo

collect: svy, subpop(if insample == 1 & gr_educ == 1 &  fumador_diario == 1): mean $var_desc, over(periodo)
collect dims
/*
. collect dims

Collection dimensions
Collection: Table
-----------------------------------------
                   Dimension   No. levels
-----------------------------------------
Layout, style, header, label
                      cmdset   6         
                       coleq   2         
                     colname   11        
                     command   1         
                     periodo   2         
               program_class   1         
                      result   59        
                 result_type   3         
                     rowname   6         
                     statcmd   1         
                         var   5         

Header, label
                     fumador
              fumador_diario
                     periodo

Style only
                border_block   4         
                   cell_type   4         
-----------------------------------------

*/
collect layout (colname#result[_r_b] result[N_strata N_psu]) (cmdset)

collect: svy, subpop(if insample == 1 & gr_educ == 2 &  fumador_diario == 1): mean $var_desc, over(periodo) 
collect: svy, subpop(if insample == 1 & gr_educ == 3 &  fumador_diario == 1): mean $var_desc, over(periodo) 

svy, subpop(if insample == 1 & gr_educ == 4 &  fumador_diario == 1): mean $var_desc, over(periodo) 


svy, subpop(if insample == 1 & gr_educ == 1 &  fumador_diario == 1): mean $var_desc, over(periodo) 
test  _b[c.$var_desc@2018bn.periodo] = _b[c.$var_desc@2020.periodo]



. return list

scalars:
               r(drop) =  0
               r(df_r) =  1070
                  r(F) =  8.022656030390332
                 r(df) =  1
                  r(p) =  .0047062463430849

putexcel set "C:\Users\USUARIO\OneDrive\Documentos\R\tax_ene2020\tax_2020\resultados\ensanut\tests_results.xlsx"
putexcel (a1) = rscalars

. ereturn list

scalars:
               e(df_r) =  1070
      e(N_strata_omit) =  295
          e(singleton) =  0
             e(census) =  0
           e(N_subpop) =  90055.2890625
              e(N_sub) =  41
              e(N_pop) =  7871883.558349609
              e(N_psu) =  1103
           e(N_strata) =  33
             e(N_over) =  2
                  e(N) =  3703
             e(stages) =  1
               e(k_eq) =  1
               e(rank) =  2

macros:
            e(cmdline) : "svy , subpop(if insample == 1 & gr_educ == 1 &  fumador_diario == 1): mean cant_ci.."
                e(cmd) : "mean"
             e(prefix) : "svy"
            e(cmdname) : "mean"
            e(command) : "mean cant_cig, over(periodo)"
              e(title) : "Survey: Mean estimation"
            e(vcetype) : "Linearized"
                e(vce) : "linearized"
          e(estat_cmd) : "svy_estat"
            e(varlist) : "cant_cig"
       e(marginsnotok) : "_ALL"
              e(wtype) : "pweight"
               e(wvar) : "factor"
               e(wexp) : "= factor"
         e(singleunit) : "certainty"
                e(su1) : "upm_dis"
            e(strata1) : "est_sel"
               e(over) : "periodo"
             e(subpop) : "if insample == 1 & gr_educ == 1 &  fumador_diario == 1"
         e(properties) : "b V"

matrices:
                  e(b) :  1 x 2
                  e(V) :  2 x 2
            e(_N_subp) :  1 x 2
           e(V_srssub) :  2 x 2
              e(V_srs) :  2 x 2
                 e(_N) :  1 x 2
              e(error) :  1 x 2
  e(_N_strata_certain) :  1 x 1
   e(_N_strata_single) :  1 x 1
          e(_N_strata) :  1 x 1

functions:
             e(sample)   


. putexcel (f2) = matrix( e(b) )
file C:\Users\USUARIO\OneDrive\Documentos\R\tax_ene2020\tax_2020\resultados\ensanut\tests_results.xlsx saved



				  
*use "$datos/2020/adol_18_20.dta", clear
/*
foreach var_fum of varlist fumador fumador_diario fumador_ocasional {
	di "tipo de fumador: `var_fum'"
	svy, subpop(if insample == 1 & `var_fum' == 1): mean $var_desc, over(periodo) 
	*svy: mean $var_desc if insample == 1 & `var_fum' == 1, over(periodo) // los errores estándar son diferentes
	svy, subpop(if insample == 1 & `var_fum' == 1): mean $var_desc, over(periodo) coeflegend
*		svy: mean $var_desc if  `var_fum' == 1, over(periodo)  coeflegend // los errores estándar son diferentes
*	svy: mean $var_desc if  `var_fum' == 1, over(periodo) coeflegend
	test _b[c.$var_desc@2018bn.periodo] = _b[c.$var_desc@2020.periodo]
}
