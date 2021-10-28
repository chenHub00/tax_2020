/*
Table 1. Sample size of the online survey among Mexican smokers and e-cigarettes users, throughout wave 1 to wave 8. 
Wave  (sample size)	Date 	Fresh sample	Re-contacted
Wave 1 (n=1,501)	24 November–10 December, 2018	n=1,501	
Wave 2 (n=1,500)	16 March–8April, 2019	n=1,035	n=465
Wave 3 (n=1,501)	17 July–9 August, 2019	n=799	n=702
Wave 4 (n=1,504)	November 20- December 5, 2019	n=703	n=801
Wave 5 (n=1,499)	March 16-26, 2020	n=631	n=868
Wave 6 (n=1501)	July 16th-28, 2020	n=667	n=834
Wave 7 (n=1502)	November 17th-30, 2021	n=684	n=818
Wave 8 (n=1500)	March 16th- April 2, 2021	n=814	n=686

*/
// do "$codigo\descriptivos.do"

ta wave 
ta wave [aw=weight]

// edad, 
su q001
ta q001 edad_cat4
ta edad_cat4
ta edad_cat4 [aw = weight]


//ta wave, su(q001)

// 
//tab1 q002 q003
ta wave, su(sexo)
ta wave [aw = weight], su(sexo) 
ta sexo [aw = weight]

ta wave, su(q003)
ta wave [aw = weight], su(q003)

ta wave q003
ta wave educ_3catr
ta wave educ_3catr [aw = weight]
ta educ_3catr
ta educ_3catr [aw = weight]

su q010

*tab q012
*tab q012 wave
// Cigarette consumption at week
su q012 
ta wave, su(q012)
ta wave [aw = weight], su(q012)
su q012 [aw = weight], 

ta wave, su(consumo_semanal)
ta wave [aw = weight], su(consumo_semanal)

*- marca favorita > q019 (q018, tiene marca favorita)
*- 'ultima marca -> q026
*ta q019 wave
ta q019 wave if q018 == 1
ta q026 wave


