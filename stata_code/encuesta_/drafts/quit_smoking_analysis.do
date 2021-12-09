* quit_smoking_analysis.do
* tomado de: Resumen_do_online_cohort_smokers_w1-w5.do
 
**use "$discount/91224059_w01_w04_appended_121219_CRUDA_LABEL_SEND"	//waves 1-4
* use "$discount/91224059_w01_w05_appended_vers_update_dup_06042020_LABEL SEND ULT"
* variables no incluidas:
* disc_rate
*****************************************
*Smoking status at time t
*****************************************
g smokstatus = q009
label variable smokstatus "Smoking status"
label define smokstatus 1 "Daily" 2 "Non-daily" 3 "Quitter" 4 "Never smoker"
label value smokstatus smokstatus
ta smokstatus
drop if smokstatus==4 //drop 44 observations of never smokers

g smokstatus2 = 1 if smokstatus==1 & q010>=5 & q010!=.
replace smokstatus2 = 2 if smokstatus==1 & q010>=1 & q010<5
replace smokstatus2 = 3 if smokstatus==2
replace smokstatus2 = 4 if smokstatus==3
label define smokstatus2 1 "Daily 5+cigs/day" 2 "Daily, less than 5cigs/day" 3 "Non-daily" 4 "Quitter"
label value smokstatus2 smokstatus2
ta smokstatus2
recode smokstatus2 (3=1) (1=3), g(smokstatus3)

*****************************************
*Identifying follow-up in 2 consecutive waves & time in the sample
*****************************************
sort id wave
qui by id: g islead = wave[_n+1]==wave+1
ta islead wave //2588 observations 
xtdes if islead==1, patterns (10) //1556 smokers with follow-up 
*Time in the sample
sort id wave
by id: g time_sample = _n 
ta time_sample wave if islead==1 	

	***IMPORTANT: drop smokers who identified themselves as quitters at their 1st survey
	drop if smokstatus==3 & time_sample==1 & islead==1 	//42 observations
	ta islead wave //2546 observations	
	xtdes if islead==1, patterns (10) //1528 smokers with follow-up
	
********************************************************************************
*****************************************
*Analytic sample
*****************************************
*keep only those with follow-up observation
	keep if islead==1
	xtdes, patterns (10) 
	
	*xtdes if disc_rate!=. & susqalead!=., patterns (10) //754 smokers with follow-up & complete info in main vars

	egen samplemiss = rowmiss(susqalead depen_psic disc_rate smokstigma dual_use sexo edad_cat4 educ_4cat family_income_2 wave time_sample smokstatus3 selfefquit)
	ta samplemiss //los . se deben a susqalead y dependence (samplemiss 0=1016)
	recode samplemiss (0=1) (1/3=0),g(sample)	
	
