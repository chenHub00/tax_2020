clear
*version 15
*set mem 1000m
clear matrix
clear mata
*set maxvar 10000
set more off

//global pathin "/Users/Belen/Documents/Proyecto_IDRC_CancerUK_2018_2021/ECEAII_modelo_subnal/Elasticidad-precio/Datos"

//global pathout "/Users/Belen/Documents/Proyecto_IDRC_CancerUK_2018_2021/ECEAII_modelo_subnal/Resultados"


capture log close
*log using $pathout/Demand_clust_mun_2016-18.log, replace
log using $pathout/Demand_clust_mun_2016-20.log, replace

use $pathin/final_total_ecea2.dta

// SE MOVIÓ A LA SECCION DE VARIABLES
// *Generating additional variables for the model 

*Estimaciones solo para hogares con gasto mayor a cero en tabaco				//OJO con esto, ver pruebas adicionales abajo
keep if uvcig!=.

*Definición de cluster alternativa = municipality+anio instead of upm+anio
rename clust cluster
// rename clust clustor
rename clust2 clust

*Cross-sections considered:
// SOLO SE TIENE INFORMACION DEL 2016 Y 2018
//keep if anio>=2016 & anio<=2018

*keep if anio==2016 	//aunque elast precio puntual coherente, no sale sig y error estándar gigantesco
*keep if anio==2018

*Estimates by income group (terciles/quantiles):
xtile tictpcb = ictpcdef [w=factor],nq(3)
xtile tictpcc = ictpcdef,nq(3)
xtile qictpcc = ictpcdef,nq(5)
xtile texppcc = exptotalpc,nq(3)
xtile qexppcc = exptotalpc,nq(5)

*Checking outliers in uvicg
***por encima de 2 veces la sd de la media - 150 observ
su uvcig if uvcig>(54.5371+(2*45.48541)) | uvcig<(54.5371-(2*45.48541))
***por encima de 2.5 veces la sd de la media - 48 observ
su uvcig if uvcig>(54.5371+(2.5*45.48541)) | uvcig<(54.5371-(2.5*45.48541))
***por encima de 3 veces la sd de la media - 40 observ
su uvcig if uvcig>(54.5371+(3*45.48541)) | uvcig<(54.5371-(3*45.48541))
*Ejercicio sustituyendo 40 outlier por valor máximo según etsa def de outlier	//sale misma elast sin quitarlos usando keep if uvcig!=.
*su uvcig 
*replace uvcig = r(mean) if uvcig>(r(mean)+(3*r(sd))) & uvcig!=.		
*su uvcig
*replace uvcig = r(mean) if uvcig>(r(mean)+(2*r(sd))) & uvcig!=.	

*Testing for spatial variation in unit values
*(both commands give identical estimates)
anova luvcig clust
*regress luvcig i.clust

*Estimating within-cluster first stage regressions
*Here we run two equations
*Running unit value regression and storing the results
areg luvcig lexp lhsize i.educajefa ledadjefa maleratio adultratio mujerjefa, absorb(clust) 
scalar sigma11=$S_E_sse / $S_E_tdf
scalar b1=_coef[lexp] //*Expenditure elasticity of quality

predict ruvcig, resid // residuals from the unit value regression
*These residuals still have cluster effects in

*Purged y's for next stage
gen y1cig=luvcig-_coef[lexp]*lexp-_coef[lhsize]*lhsize ///
	-_coef[2.educajefa]*2.educajefa-_coef[3.educajefa]*3.educajefa-_coef[4.educajefa]*4.educajefa ///
	-_coef[5.educajefa]*5.educajefa-_coef[6.educajefa]*6.educajefa ///	
	-_coef[ledadjefa]*ledadjefa-_coef[maleratio]*maleratio-_coef[adultratio]*adultratio ///
	-_coef[mujerjefa]*mujerjefa  

*Repeat for budget shares
areg bscig lexp lhsize i.educajefa ledadjefa maleratio adultratio mujerjefa, absorb(clust) 
predict rbscig, resid // residuals from the budget share regression

scalar sigma22=$S_E_sse/$S_E_tdf // var-covar matrix of u0 (e0e0)
scalar b0=_coef[lexp] // Coefficients of lnexp in BS regression
*Purged y's for next stage
gen y0cig=bscig-_coef[lexp]*lexp-_coef[lhsize]*lhsize ///
	-_coef[2.educajefa]*2.educajefa-_coef[3.educajefa]*3.educajefa-_coef[4.educajefa]*4.educajefa ///
	-_coef[5.educajefa]*5.educajefa-_coef[6.educajefa]*6.educajefa ///	
	-_coef[ledadjefa]*ledadjefa-_coef[maleratio]*maleratio-_coef[adultratio]*adultratio ///
	-_coef[mujerjefa]*mujerjefa 

*This next regression is necessary to get covariance of residuals
qui areg ruvcig rbscig lexp lhsize i.educajefa ledadjefa maleratio adultratio mujerjefa, absorb(clust)
scalar sigma12=_coef[rbscig]*sigma22 // covar matrix of u1 (e1e0)

*expenditure elasticity of quantity
qui sum bscig
scalar Wbar=r(mean)
scalar Expel=1-b1+(b0/Wbar)
di Expel

/*To estimate the bootstrap standard errors for expenditure elasticity
cap program drop Expelast
program Expelast, rclass
tempname b1 b0 Wbar
qui areg luvcig lexp lhsize maleratio meanedu maxedu sgp1-sgp3, absorb(clust)
cap scalar b1=_coef[lexp]
qui areg bscig lexp lhsize maleratio meanedu maxedu sgp1-sgp3, absorb(clust)
cap scalar b0=_coef[lexp]
qui sum bscig
cap scalar Wbar=r(mean)
return scalar Expel=1-b1+(b0/wbar)
end
expelast
return list

bootstrap Expel=r(Expel), reps(1000) seed(1): Expelast
*/

*Next, equations (3.4) and (3.5) are derived via the following sets of commands:
sort clust
egen y0c= mean(y0cig), by(clust)
egen n0c=count(y0cig), by(clust)
egen y1c= mean(y1cig), by(clust)
egen n1c=count(y1cig), by(clust)
sort clust
*keeping one obs per cluster
qui by clust: keep if _n==1

*Deaton uses harmonic mean to estimate average cluster size
ameans n0c
scalar n0=r(mean_h)
ameans n1c
scalar n1=r(mean_h)
drop n0c n1c

cap program drop elast
program elast, rclass
	tempname S R num den phi theta psi
	qui corr y0c y1c, cov
	scalar S=r(Var_2) //Var of y1
	scalar R=r(cov_12) //Covariance y0c and y1c
	scalar num=scalar(R)-(sigma12/n0)
	scalar den=scalar(S)-(sigma11/n1)
	cap scalar phi=num/den
	cap scalar zeta= b1/((b0 + Wbar*(1-b1)))
	cap scalar theta=phi/(1+(Wbar-phi)*zeta)
	cap scalar psi=1-((b1*(Wbar-theta))/(b0+Wbar))
	return scalar EP=(theta/Wbar)-psi
end
elast
return list
bootstrap EP=r(EP), reps(1000) seed(1): elast
log close



*****OTRAS PRUEBAS:

***Sin restringir a uvcig!=.

*si uso cluster = upm+anio & no restrinjo a uvcig!=. sale elasticidad = -.0334 
*si uso cluster = upm+anio & no restrinjo a uvcig!=. & solo uso anio=2016 sale elasticidad = -.03565 
*si uso cluster = upm+anio & no restrinjo a uvcig!=. & solo uso anio=2018 sale elasticidad = -.03565 
*drop clust
*rename upm clust
*si uso cluster = upm & no restrinjo a uvcig!=. sale elasticidad = -.227
*si uso cluster = upm & no restrinjo a uvcig!=. sale & solo uso anio= 2016 sale elasticidad = -.03565
*si uso cluster = upm & no restrinjo a uvcig!=. sale & solo uso anio= 2018 sale elasticidad = -.1886


***Restringiendo a uvcig!=.

*Lo siguiente es usando cluster = upm:
*keep if uvcig!=.				// sale elasticidad = -.5774676
*keep if uvcig!=. & anio==2016	//para 2016 sale elasticidad = -.4311256
*keep if uvcig!=. & anio==2018	//para 2018 sale elasticidad = -.6849322
	***La definición de cluster como upm o como upm+anio no afecta cuando se restrinje muestra a hogares fumadores
