
/*
Table 1. Sample size of the online survey among Mexican smokers and e-cigarettes users, throughout wave 1 to wave 8. 
Date 	Fresh sample	Re-contacted
24 November–10 December, 2018	n=1,501	
16 March–8April, 2019	n=1,035	n=465
17 July–9 August, 2019	n=799	n=702
November 20- December 5, 2019	n=703	n=801
March 16-26, 2020	n=631	n=868
July 16th-28, 2020	n=667	n=834
November 17th-30, 2021	n=684	n=818
March 16th- April 2, 2021	n=814	n=686
*/
label variable wave "levantamiento"

#delimit ;
label define wave 1 "24 November–10 December, 2018"	
	2 "16 March–8April, 2019"
3 "17 July–9 August, 2019"
4 "November 20- December 5, 2019"
5 "March 16-26, 2020"
6 "July 16th-28, 2020"
7 "November 17th-30, 2021"
8 "March 16th- April 2, 2021"
; 
#delimit cr
label values wave wave

// categorias de edad
label variable edad_cat4 "grupos de edad (4)"

// 
label define h_educ 1 "less than high school " 2 "high school or technical studies" ///
	3 "some college and more"
	
/*
0= less than high school
1= high school graduate or technical studies
2= some college 
3= college degree or postgraduate studies

*/
