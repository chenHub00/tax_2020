
//use datos/prelim/de_inpc/tpCiudad2.dta, clear 
// already has some price averages


use datos/prelim/de_inpc/table11_principales7.dta, clear
// 
rename marca marca_str
encode marca_str, gen(marca)

gen wave = 1 if year == 2018 & (month == 11 | month == 12)
replace wave = 2 if year == 2019 & (month == 3 | month == 4)
replace wave = 3 if year == 2019 & (month == 7 | month == 8)
replace wave = 4 if year == 2019 & (month == 11 | month == 12)
replace wave = 5 if year == 2020 & (month == 3)
replace wave = 6 if year == 2020 & (month == 6)
replace wave = 7 if year == 2020 & (month == 11)
replace wave = 8 if year == 2021 & (month == 3 | month == 4)

/*

                levantamiento |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
24 November–10 December, 2018 |      1,501       12.50       12.50
        16 March–8April, 2019 |      1,500       12.49       24.99
       17 July–9 August, 2019 |      1,501       12.50       37.49
November 20- December 5, 2019 |      1,504       12.52       50.02
            March 16-26, 2020 |      1,499       12.48       62.50
           July 16th-28, 2020 |      1,501       12.50       75.00
       November 17th-30, 2021 |      1,502       12.51       87.51
    March 16th- April 2, 2021 |      1,500       12.49      100.00

*/

/*
. table pzas if marca == 1 & wave == 1 , c(mean pp max pp min pp)

----------------------------------------------
     pzas |   mean(pp)     max(pp)     min(pp)
----------+-----------------------------------
       14 |         39          39          39
       20 |   53.15792        55.5          52
----------------------------------------------

mid between max(pp) in low and min(pp) on high => (52-39)/2 + 39 = 45.5

gen pzas0 = .
recode pzas0 . = 14 if q029 <= 100 & wave == 1 & marca == 1
recode pzas0 14 = 20 if q029 >=  45.5 & q029 <= 100  & wave == 1 & marca == 1

*/

tab wave

* actual
table pzas wave if marca == 1, statistic(min pp) statistic(max pp)

/*
foreach value of numlist 1/8 {
	version 14
	table pzas if marca == 1 & wave == `value', c(mean pp max pp min pp)
}*/
// falta "otras marcas"
foreach value of numlist 1/7 {	
	table pzas wave if marca == `value', statistic(min pp) statistic(max pp)
}