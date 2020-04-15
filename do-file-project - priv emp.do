* Variable will be loaded by using FRED use, so the most recent data can be captured

freduse FLNAN SMU12453000500000001 SMU12453000500000002 SMU12453000500000003 SMU12453000500000011 SMU12453000700000001 SMU12453006054000001 TAMP312BPPRIV TAMP312NAN TAMP312URN

*Datestring generation
rename date datestring
gen datec=date(datestring,"YMD")
gen date=mofd(datec)
format date %tm
tsset date

*Adjusting Observations
keep if tin(1990m1,)
tsappend, add(1)
tsset date

* Month indicators
generate month=month(datec)
replace month=month(dofm(date)) if month==.
gen m1=0
replace m1=1 if month==1
gen m2=0
replace m2=1 if month==2
gen m3=0
replace m3=1 if month==3
gen m4=0
replace m4=1 if month==4
gen m5=0
replace m5=1 if month==5
gen m6=0
replace m6=1 if month==6
gen m7=0
replace m7=1 if month==7
gen m8=0
replace m8=1 if month==8
gen m9=0
replace m9=1 if month==9
gen m10=0
replace m10=1 if month==10
gen m11=0
replace m11=1 if month==11
gen m12=0
replace m12=1 if month==12

* FLNAN = Florida Non Farm Employees
rename FLNAN fl_nonfarm
gen lnfl_nonfarm=ln(fl_nonfarm)

*SMU12453000500000001 = Total Private Employees in Tampa-St. Petersburg-Clearwater, FL (MSA)
rename SMU12453000500000001 tpa_priv
gen lntpa_priv=ln(tpa_priv)

*SMU12453000500000002 = Average Weekly Hours of All Employees: Total Private in Tampa-St.    Petersburg-Clearwater, FL (MSA) 
rename SMU12453000500000002 tpa_aveweek_hour
label variable tpa_aveweek_hour "Average Weekly Hours - Tampa MSA"
gen lntpa_aveweek_hour=ln(tpa_aveweek_hour)

*SMU12453000500000003 = Average Hourly Earnings of All Employees: Total Private in Tampa-St.  Petersburg-Clearwater, FL (MSA)
rename SMU12453000500000003 tpa_avehour_earn
label variable tpa_avehour_earn "Average Hourly Earnings - Tampa MSA"
gen lntpa_avehour_earn=ln(tpa_avehour_earn)

*SMU12453000500000011 = Average Weekly Earnings of All Employees: Total Private in Tampa-St.  Petersburg-Clearwater, FL (MSA) 
rename SMU12453000500000011 tpa_aveweek_earn
label variable tpa_aveweek_earn "Average Weekly Earnings - Tampa MSA"
gen lntpa_aveweek_earn=ln(tpa_aveweek_earn)

* SMU12453000700000001 = All Employees: Service-Providing in Tampa-St. Petersburg-Clearwater, FL (MSA)
rename SMU12453000700000001 tpa_serv
gen lntpa_serv=ln(tpa_serv)
label variable tpa_serv "Service-Providing Employees - Tampa MSA"

* SMU12453006054000001 = All Employees: Professional, Scientific, and Technical Services in    Tampa-St. Petersburg-Clearwater, FL (MSA)
rename SMU12453006054000001 tpa_tech
gen lntpa_tech=ln(tpa_tech)
label variable tpa_tech "Professional, Technical, and Scientific Employees - Tampa MSA"

* TAMP312BPPRIV = New Private Housing Units Authorized by Building Permits for Tampa-St. Petersburg-Clearwater, FL (MSA)
rename TAMP312BPPRIV tpa_bp
gen lntpa_bp=ln(tpa_bp)
label variable tpa_bp "New Private Housing Authorized by Building Permits - Tampa MSA" 

* TAMP312NAN  = All Employees: Total Nonfarm in Tampa-St. Petersburg-Clearwater, FL (MSA)
rename TAMP312NAN tpa_nonfarm
gen lntpa_nonfarm=ln(tpa_nonfarm)
label variable tpa_nonfarm "Total Nonfarm Employees in Tampa MSA"

* TAMP312URN = Unemployment Rate in Tampa-St. Petersburg-Clearwater, FL (MSA)
rename TAMP312URN tpa_unemp
gen lntpa_unemp=ln(tpa_unemp)
label variable tpa_unemp "Unemployment within Tampa MSA"

* Total Weekly earning
gen tpa_totalweek_earn = tpa_priv*tpa_aveweek_earn
label variable tpa_totalweek_earn "Total Weekly Earnings (thousands) - Tampa MSA"
gen lntpa_totalweek_earn = ln(tpa_totalweek_earn)
label variable lntpa_totalweek_earn "Log of Total Weekly Earnings - Tampa MSA"

* Summary of all variables
summarize *

* Variables description
describe *

* Tsline for predictors
twoway (tsline lntpa_aveweek_hour) if tin(2007m1,)
twoway (tsline lntpa_aveweek_earn) if tin(2007m1,)
twoway (tsline lntpa_avehour_earn) if tin(2007m1,)
twoway (tsline lntpa_totalweek_earn) if tin(2007m1,)
twoway (tsline lntpa_priv) if tin(1990m1,)
*Extra explanatory variables
twoway (tsline lntpa_tech) (tsline lntpa_priv) if tin(1997m1,)
twoway (tsline tpa_unemp) if tin(1990m1,)
twoway (tsline lntpa_bp) (tsline lntpa_priv) if tin(1990m1,)
twoway (tsline lntpa_serv) (tsline lntpa_priv) if tin(1990m1,)
twoway (tsline lntpa_nonfarm) (tsline lntpa_priv) if tin(1990m1,)
twoway (tsline fl_nonfarm) if tin(1990m1,)

*AC, PAC, and Dickey Fuller Unit Root Test
*Weekly hours
ac lntpa_aveweek_hour
pac lntpa_aveweek_hour
dfuller lntpa_aveweek_hour
*Not Highly-Persistent

*Weekly earns
ac lntpa_aveweek_earn, title("MSA Average Weekly Earn's AC") ytitle("lntpa_aveweek_earn") saving(ac5, replace)
pac lntpa_aveweek_earn, title("MSA Average Weekly Earn's PAC") ytitle("lntpa_aveweek_earn") saving(pac5, replace)
*rho approximately 1
dfuller lntpa_aveweek_earn
*retain null, rho = 1

ac lntpa_avehour_earn
pac lntpa_avehour_earn
*rho approximately 1
dfuller lntpa_avehour_earn
*retain null, rho = 1

ac lntpa_totalweek_earn, title("MSA Total Weekly Earn's AC") ytitle("lntpa_totalweek_earn")saving(ac6, replace)
pac lntpa_totalweek_earn, title("MSA Total Weekly Earn's PAC") ytitle("lntpa_totalweek_earn") saving(pac6, replace)
*rho approximately 1
dfuller lntpa_totalweek_earn
*retain null, rho = 1

pac lntpa_priv, title("MSA Private Workers' PAC") ytitle("lntpa_priv") saving(pac1, replace)
ac lntpa_priv, title("MSA Private Workers' AC") ytitle("lntpa_priv") saving(ac1, replace)
*rho approximately 1
dfuller lntpa_priv
*retain null, rho = 1

ac lntpa_tech, title("MSA Tech workers' AC") ytitle("lntpa_tech") saving(ac2, replace)
pac lntpa_tech, title("MSA Tech workers' PAC") ytitle("lntpa_tech") saving(pac2, replace)
*rho approximately 1
dfuller lntpa_tech
*retain null, rho = 1

ac lntpa_unemp, title("MSA Unemployment's AC") ytitle("lntpa_unemp") saving(ac3, replace)
pac lntpa_unemp, title("MSA Unemployment's PAC") ytitle("lntpa_unemp")  saving(pac3, replace)
*rho approximately 1
dfuller lntpa_unemp
*retain null, rho = 1

ac lntpa_bp
pac lntpa_bp
dfuller lntpa_bp
*Not Highly-Persistent

ac lntpa_serv, title("MSA Service Workers' AC") ytitle("lntpa_serv") saving(ac4, replace)
pac lntpa_serv, title("MSA Private Workers' PAC") ytitle("lntpa_serv") saving(pac4, replace)
*rho approximately 1
dfuller lntpa_serv
*retain null, rho = 1

ac lntpa_nonfarm
pac lntpa_nonfarm
*rho approximately 1
dfuller lntpa_nonfarm, lag (12)
*retain null, rho = 1

ac lnfl_nonfarm
pac lnfl_nonfarm
*rho approximately 1
dfuller lnfl_nonfarm, lag (12)
*retain null, rho = 1
*/

graph combine pac1.gph pac2.gph pac3.gph pac4.gph, ///
	saving(pacgen1, replace)
graph combine pac5.gph pac6.gph ac5.gph ac6.gph, ///
	saving(pacgen2, replace)

*Predicting lntpa_priv
set seed 22045
reg d.lntpa_priv d.l(1/12,18,24)lntpa_priv d.l(1/12)lntpa_unemp d.l(1/12)lntpa_unemp d.l(1/12)lntpa_serv
predict res1 if e(sample)==1, residual
pac res1
bgodfrey, lag(1/12)
drop res1

reg d.lntpa_priv d.l(1/12,24)lntpa_priv d.l(1/12)lntpa_unemp d.l(1/12)lntpa_bp
predict res2 if e(sample)==1, residual
pac res2
bgodfrey, lag(1/12)
drop res2

reg d.lntpa_priv d.l(1/12,18,24)lntpa_priv d.l(1/12)lntpa_unemp d.l(1/12)lntpa_tech 
predict res3 if e(sample)==1, residual
pac res3
bgodfrey, lag(1/12)
drop res3

reg d.lntpa_priv d.l(1/8,11,12,18,24)lntpa_priv d.l(1,2,12)lntpa_unemp d.l(1,2,12)lntpa_tech 
predict res4 if e(sample)==1, residual
pac res4
bgodfrey, lag(1/12)
drop res4

*Generating dummy variables
gen dlntpa_priv = d.lntpa_priv
gen l1dlntpa_priv = l1d.lntpa_priv
gen l2dlntpa_priv = l2d.lntpa_priv
gen l3dlntpa_priv = l3d.lntpa_priv
gen l4dlntpa_priv = l4d.lntpa_priv
gen l5dlntpa_priv = l5d.lntpa_priv
gen l6dlntpa_priv = l6d.lntpa_priv
gen l7dlntpa_priv = l7d.lntpa_priv
gen l8dlntpa_priv = l8d.lntpa_priv
gen l9dlntpa_priv = l9d.lntpa_priv
gen l10dlntpa_priv = l10d.lntpa_priv
gen l11dlntpa_priv = l11d.lntpa_priv
gen l12dlntpa_priv = l12d.lntpa_priv
gen l18dlntpa_priv = l18d.lntpa_priv
gen l24dlntpa_priv = l24d.lntpa_priv

gen l1dlntpa_unemp = l1d.lntpa_unemp
gen l2dlntpa_unemp = l2d.lntpa_unemp
gen l12dlntpa_unemp = l12d.lntpa_unemp

gen l1dlntpa_tech = l1d.lntpa_tech
gen l2dlntpa_tech = l2d.lntpa_tech
gen l12dlntpa_tech = l12d.lntpa_tech

*GSREG
/*gsreg dlntpa_priv l1dlntpa_priv l2dlntpa_priv l3dlntpa_priv l4dlntpa_priv ///
	l5dlntpa_priv l6dlntpa_priv l11dlntpa_priv l12dlntpa_priv l24dlntpa_priv ///
	l1dlntpa_unemp l2dlntpa_unemp l12dlntpa_unemp l1dlntpa_tech ///
	l2dlntpa_tech l12dlntpa_tech if tin(1990m1, 2020m3), ///
	ncomb(1,8) aic outsample(24) fix(m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12) samesample ///
	nindex( -0.3 aic -0.3 bic -0.4 rmse_out) results(gsreg_dlntpa_priv2) replace
*/
*t-initial = 1997 due tpa_tech 
*Baseline Model  fro RW - w = 60
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv d.l(1/12)lntpa_priv d.l(1/12)lntpa_unemp d.l(1/12)lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Selected models for RW - w = 60
*1
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*2
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l12d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*3
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l12d.lntpa_priv l24d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*4
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_priv l12d.lntpa_unemp l12d.lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*5
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_priv l24d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*6
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*11
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l1d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12  if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*18
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l12d.lntpa_priv l12d.lntpa_unemp l1d.lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12  if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*25
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
    reg d.lntpa_priv l3d.lntpa_priv l12d.lntpa_priv l24d.lntpa_priv l12d.lntpa_unemp l1d.lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12  if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*63
scalar drop _all
quietly forval w=60(12)120 { 
gen pred=.                  
gen nobs=. 	
	forval t=619/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
    reg d.lntpa_priv l1d.lntpa_priv l2d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

* Fixed W = 72

*1
scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=571/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*2
scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=571/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l12d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*6
scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=571/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*11

scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=571/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l1d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12  if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list


*Baseline w =72

scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=571/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv d.l(1/12)lntpa_priv d.l(1/12)lntpa_unemp d.l(1/12)lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 6
scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=571/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_priv l3d.lntpa_priv l6d.lntpa_priv l12d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_priv)^2
summ errsq
gen rwpred = pred 
scalar RWrmse`w'=r(mean)^.5 
summ nobs rwpred
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

scalar rwrmse1 = 0.00366889

*Constructing a empirical interval - w = 72
*reg dlnfl_nonfarm l1dlnfl_nonfarm l2dlnfl_nonfarm l3dlnfl_nonfarm l5dlnfl_nonfarm l6dlnfl_nonfarm l12dlnfl_nonfarm l2dlnfl_lf l2dlnus_epr m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if tin(2014m2,2020m2)

gen residual=(d.lntpa_priv-rwpred)
gen expres=exp(residual)
summ expres
scalar meanexpres=r(mean)
_pctile residual, percentiles(2.5,97.5)
gen pye=meanexpres*exp(l.lntpa_priv+rwpred)
gen ubye=meanexpres*exp(l.lntpa_priv+rwpred+r(r2))
gen lbye=meanexpres*exp(l.lntpa_priv+rwpred+r(r1))

twoway (tsline tpa_priv if tin(2019m1,2020m4)) ///
	(tsline pye ubye lbye if tin(2018m1,2020m4)), ///
	title("Actual and Empirical Forecast Florida for Private Workers for Tampa-St.Pt-Cl.") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m3yemp, replace)
	
twoway (tsline tpa_priv if tin(2019m1,2020m4)) ///
	(tsline pye ubye lbye if tin(2019m1,2020m4)), ///
	title("Empirical Forecast") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m3yemp, replace)

*Constructing a Gaussian intervar - w = 72

gen pyn=exp(l.lntpa_priv+rwpred+(rwrmse1^2)/2)
gen ubyn=exp(l.lntpa_priv+rwpred+1.96*rwrmse1+(rwrmse1^2)/2)
gen lbyn=exp(l.lntpa_priv+rwpred-1.96*rwrmse1+(rwrmse1^2)/2)
twoway (tsline tpa_priv if tin(2019m1,2020m2)) ///
	(tsline pyn ubyn lbyn if tin(2019m1,2020m3)), ///
	title("Actual and Approx. Normal Forecast Florida for Nonfarm-Workers") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m3ynorm, replace)

twoway (tsline tpa_priv if tin(2019m1,2020m2)) ///
	(tsline pyn ubyn lbyn if tin(2019m1,2020m3)), ///
	title("Approximately Normal Forecast") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m3ynorm, replace)
	
twoway (tsline tpa_priv if tin(2018m1,2020m2)) ///
	(tsline pyn ubyn lbyn if tin(2019m1,2020m3)), ///
	title("Approximately Normal Forecast") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m3ynorm2, replace)
	
graph combine m3ynorm.gph m3yemp.gph , ///
	saving(m3yen, replace)
	
*Chart one month ahead - Empirical
gen fub=ubye if tin(2020m3,)
gen flb=lbye if tin(2020m3,)
gen fcst=pye if tin(2020m3,)
replace fcst=tpa_priv if tin(2020m2,2020m2)
replace fub=tpa_priv if tin(2020m2,2020m2)
replace flb=tpa_priv if tin(2020m2,2020m2)

*Chart one month ahead - Normal
twoway(tsline tpa_priv if tin(2019m1,2020m2))(tsline fub flb fcst if tin(2020m2,2020m3) ), title("Empirical Forecast") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Upper Bound") ///
	label(3 "Lower Bound") label(4 "Forecast")) saving(fcste, replace)

replace fub=ubyn if tin(2020m3,)
replace flb=lbyn if tin(2020m3,)
replace fcst=pyn if tin(2020m3,)
replace fcst=tpa_priv if tin(2020m2,2020m2)
replace fub=tpa_priv if tin(2020m2,2020m2)
replace flb=tpa_priv if tin(2020m2,2020m2)

twoway(tsline tpa_priv if tin(2019m1,2020m2))(tsline fub flb fcst if tin(2020m2,2020m3) ), title("Approximately Normal Forecast") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Upper Bound") ///
	label(3 "Lower Bound") label(4 "Forecast")) saving(fcstn, replace)
	
graph combine fcstn.gph fcste.gph , ///
	saving(fcts, replace)