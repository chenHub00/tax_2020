
/* Adolescentes */
use "$datos\2018\CS_ADOLESCENTES.dta", clear

keep upm viv_sel hogar numren est_dis ///
	p1_8 p1_8_1 /// con capsula
	p1_10 p1_9 // cigarro electronico
	
	gen e_cig = p1_9  == 1 | p1_9 == 2

save  "$datos\2018\consumo_dual_adoles.dta", replace

svyset [pweight=factor], psu(upm_dis)strata (est_dis) singleunit(certainty)

/* adolescente */
svy: mean e_cig if adol == 1
svy: total e_cig if adol == 1

svy: mean e_cig if adol == 1 & sexo == 1
svy: total e_cig if adol == 1 & sexo == 1

svy: mean e_cig if adol == 1 & sexo == 2
svy: total e_cig if adol == 1 & sexo == 2

tabulate sex if adol==1 [w=factor], sum(e_cig) nost 
/*
Informe final 2018
p. 133 
Considerado que los nuevos productos de tabaco (productos vaporizados o
calentados) se encuentran prohibidos en México, la prevalencia de consumo
de cigarros electrónicos en México es de 1.2% (1 023 000 usuarios), de 1.9%
(711 100 usuarios) en los hombres y de 0.7% (311 900 usuarias) en las mujeres
(cuadro 5.4.2).

*/
/**adultos */
*2018
p13_8 p13_8_1 p13_9 p13_10 

/*2020*/
/* Adolescentes
Considerando que los nuevos productos de tabaco (productos vaporizados
o calentados) se encuentran prohibidos en México y que la venta de todos los
productos de tabaco está prohibida a los menores de edad, la prevalencia de uso
de cigarros electrónicos es de 1.2% (268 131); 1.5% (161 356) en los adolescentes
hombres y de 1% (106 775) en las adolescentes mujeres.
*/
svyset [pweight=factor], psu(upm_dis)strata (est_sel) singleunit(certainty)

tabulate sex if adulto==1 [w=factor], sum(e_cig) nost 

svy: mean e_cig if adulto == 1
svy: total e_cig if adulto == 1

svy: total e_cig if adulto == 1 & sexo==1
svy: total e_cig if adulto == 1 & sexo==2

/* Adultos 
Considerado que los nuevos productos de tabaco (productos vaporizados o
calentados) se encuentran prohibidos en México, la prevalencia de consumo de
cigarros electrónicos a nivel nacional es de 1.2% (1 010 651): 1.8% (709 816)
en los hombres y de 0.7% (300 834) en las mujeres.
*/

/* LOS TOTALES NO COINCIDEN, AUNQUE ESTAN CERCANOS


. svy: total e_cig if adulto == 1
(running total on estimation sample)

Survey: Total estimation

Number of strata =  91            Number of obs   =      8,595
Number of PSUs   = 427            Population size = 84,421,225
                                  Design df       =        336

--------------------------------------------------------------
             |             Linearized
             |      Total   std. err.     [95% conf. interval]
-------------+------------------------------------------------
       e_cig |    1049973   141007.3      772604.3     1327341
--------------------------------------------------------------
Note: Strata with single sampling unit treated as certainty
      units.

. svy: total e_cig if adulto == 1 & sexo==1
(running total on estimation sample)

Survey: Total estimation

Number of strata =  91            Number of obs   =      3,511
Number of PSUs   = 426            Population size = 40,491,717
                                  Design df       =        335

--------------------------------------------------------------
             |             Linearized
             |      Total   std. err.     [95% conf. interval]
-------------+------------------------------------------------
       e_cig |     750795   126423.2      502111.7    999478.3
--------------------------------------------------------------
Note: Strata with single sampling unit treated as certainty
      units.

. 
end of do-file


. svy: total e_cig if adulto == 1 & sexo==2
(running total on estimation sample)

Survey: Total estimation

Number of strata =  91            Number of obs   =      5,084
Number of PSUs   = 427            Population size = 43,929,508
                                  Design df       =        336

--------------------------------------------------------------
             |             Linearized
             |      Total   std. err.     [95% conf. interval]
-------------+------------------------------------------------
       e_cig |   299177.6   60449.16      180271.1    418084.1
--------------------------------------------------------------
Note: Strata with single sampling unit treated as certainty
      units.
