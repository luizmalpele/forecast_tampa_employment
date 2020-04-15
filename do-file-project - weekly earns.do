* Variable will be loaded by using FRED use, so the most recent data can be captured

freduse FLNAN SMU12453000500000001 SMU12453000500000002 SMU12453000500000003 SMU12453000500000011 SMU12453000700000001 SMU12453006054000001 TAMP312BPPRIV TAMP312NAN TAMP312URN

*Datestring generation
rename date datestring
gen datec=date(datestring,"YMD")
gen date=mofd(datec)
format date %tm
tsset date

*Adjusting Observations
keep if tin(2007m1,)
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
twoway (tsline lntpa_aveweek_earn) if tin(2007m1,), saving(var1, replace)
twoway (tsline tpa_avehour_earn) if tin(2007m1,)
twoway (tsline tpa_totalweek_earn) if tin(2007m1,) , saving(var4, replace)
twoway (tsline tpa_aveweek_earn) if tin(2007m1,)
twoway (tsline lntpa_priv) if tin(1990m1,)
*Extra explanatory variables
twoway (tsline lntpa_tech) if tin(1997m1,), saving(var2, replace)
twoway (tsline lntpa_unemp)  if tin(1990m1,), saving(var3, replace)
twoway (tsline lntpa_bp) if tin(1990m1,)
twoway (tsline lntpa_serv) if tin(1990m1,)
twoway (tsline lntpa_nonfarm) if tin(1990m1,)
twoway (tsline fl_nonfarm) if tin(1990m1,)

graph combine var1.gph var2.gph var3.gph var4.gph , ///
	saving(vars, replace)

*Predicting lntpa_aveweek_earn
set seed 22045
reg d.lntpa_aveweek_earn d.l(1/12,24,36)lntpa_aveweek_earn d.l(1,2,12)tpa_unemp d.l(1,2,12)lntpa_tech d.l(1,2,12)lntpa_totalweek_earn d.l(1,2,12)lntpa_priv m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
predict res1 if e(sample)==1, residual
pac res1
bgodfrey, lag(1/24)
drop res1

reg d.lntpa_aveweek_earn d.l(1/12,24,36)lntpa_aveweek_earn d.l(1,2,12)tpa_unemp d.l(1,2,12)lntpa_priv d.l(1,2,12)lntpa_totalweek_earn m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
predict res2 if e(sample)==1, residual
pac res2
bgodfrey, lag(1/12)
drop res2

*Generating dummy variables

gen dlntpa_avehour_earn = d.lntpa_totalweek_earn
gen l1dlntpa_avehour_earn = l1d.lntpa_totalweek_earn
gen l2dlntpa_avehour_earn = l2d.lntpa_totalweek_earn
gen l3dlntpa_avehour_earn = l3d.lntpa_totalweek_earn
gen l4dlntpa_avehour_earn = l4d.lntpa_totalweek_earn
gen l5dlntpa_avehour_earn = l5d.lntpa_totalweek_earn
gen l6dlntpa_avehour_earn = l6d.lntpa_totalweek_earn
gen l7dlntpa_avehour_earn = l7d.lntpa_totalweek_earn
gen l8dlntpa_avehour_earn = l8d.lntpa_totalweek_earn
gen l9dlntpa_avehour_earn = l9d.lntpa_totalweek_earn
gen l10dlntpa_avehour_earn = l10d.lntpa_totalweek_earn
gen l11dlntpa_avehour_earn = l11d.lntpa_totalweek_earn
gen l12dlntpa_avehour_earn = l12d.lntpa_totalweek_earn
gen l24dlntpa_avehour_earn = l24d.lntpa_totalweek_earn
gen l36dlntpa_avehour_earn = l36d.lntpa_totalweek_earn

gen l1dlntpa_totalweek_earn = l1d.lntpa_totalweek_earn
gen l2dlntpa_totalweek_earn = l2d.lntpa_totalweek_earn
gen l12dlntpa_totalweek_earn = l12d.lntpa_totalweek_earn

gen l1dlntpa_priv = l1d.lntpa_priv
gen l2dlntpa_priv = l2d.lntpa_priv
gen l12dlntpa_priv = l12d.lntpa_priv

gen l1dlntpa_unemp = l1d.lntpa_unemp
gen l2dlntpa_unemp = l2d.lntpa_unemp
gen l12dlntpa_unemp = l12d.lntpa_unemp

gen l1dlntpa_tech = l1d.lntpa_tech
gen l2dlntpa_tech = l2d.lntpa_tech
gen l12dlntpa_tech = l12d.lntpa_tech

*GSREG
gsreg dlntpa_avehour_earn l1dlntpa_avehour_earn l2dlntpa_avehour_earn l3dlntpa_avehour_earn ///
	l4dlntpa_avehour_earn l6dlntpa_avehour_earn  ///
	l11dlntpa_avehour_earn l12dlntpa_avehour_earn l24dlntpa_avehour_earn /// 
	 l1dlntpa_totalweek_earn ///
	l12dlntpa_totalweek_earn l1dlntpa_priv l12dlntpa_priv ///
	l1dlntpa_unemp l2dlntpa_unemp l12dlntpa_unemp l1dlntpa_tech l2dlntpa_tech ///
	l12dlntpa_tech if tin(2007m1, 2020m3), ///
	ncomb(1,7) aic outsample(24) fix(m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12) samesample ///
	nindex( -0.3 aic -0.3 bic -0.4 rmse_out) results(gsreg_dlntpa_earn) replace

*Best models
*1 - M1
reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
*2 - M2
reg d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_totalweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
*4 - M3
reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
*5 - M4 
reg d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l1d.lntpa_totalweek_earn m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
*17 - M5
reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l3d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
*Good BIC and AIC
*24 - M6
reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp l2d.lntpa_tech l12.lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
*27 - M7
reg d.lntpa_aveweek_earn l1.lntpa_totalweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_tech l12.lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
*Good RMSE out
*35 - M8
reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l24d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
*36 -M9
reg d.lntpa_aveweek_earn l1d.lntpa_totalweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l24d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12
*337-M10
reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp l12d.lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12

*t-initial = 2007 due tpa_tech 
*Baseline Model for RW 
scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn d.l(1/12)lntpa_aveweek_earn d.l(1/12)tpa_unemp d.l(1/12)lntpa_priv d.l(1/12)lntpa_totalweek_earn m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Selected models for RW - w = 60(12)84
*Model 1
scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 2
scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_totalweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 3
scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 4
scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l1d.lntpa_totalweek_earn m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 5
scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l3d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
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
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp l2d.lntpa_tech l12.lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 7
scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1.lntpa_totalweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_tech l12.lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 8
scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l24d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 9
scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_totalweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l24d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 10

scalar drop _all
quietly forval w=60(12)84 { 
gen pred=.                  
gen nobs=. 	
	forval t=648/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp l12d.lntpa_tech m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

* Fixed W = 72

*Baseline Model for RW 
scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=636/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn d.l(1/12)lntpa_aveweek_earn d.l(1/12)tpa_unemp d.l(1/12)lntpa_priv d.l(1/12)lntpa_totalweek_earn m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=636/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 2
scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=636/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_totalweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 3
scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=636/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 4
scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=636/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l1d.lntpa_totalweek_earn m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 5
scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=636/722 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l3d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Fixed W =60


*Baseline Model for RW 
scalar drop _all
quietly forval w=60(12)60 { 
gen pred=.                  
gen nobs=. 	
	forval t=624/722 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn d.l(1/12)lntpa_aveweek_earn d.l(1/12)tpa_unemp d.l(1/12)lntpa_priv d.l(1/12)lntpa_totalweek_earn m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

scalar drop _all
quietly forval w=60(12)60 { 
gen pred=.                  
gen nobs=. 	
	forval t=624/722 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 2
scalar drop _all
quietly forval w=60(12)60 { 
gen pred=.                  
gen nobs=. 	
	forval t=624/722 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_totalweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 3
scalar drop _all
quietly forval w=60(12)60 { 
gen pred=.                  
gen nobs=. 	
	forval t=624/722 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 4
scalar drop _all
quietly forval w=60(12)60 { 
gen pred=.                  
gen nobs=. 	
	forval t=624/722 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l1d.lntpa_totalweek_earn m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

*Model 5
scalar drop _all
quietly forval w=60(12)60 { 
gen pred=.                  
gen nobs=. 	
	forval t=624/722 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l3d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv l2d.lntpa_unemp m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5 
summ nobs
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list


*SELECTED ONE

*Model 3

scalar drop _all
quietly forval w=72(12)72 { 
gen pred=.                  
gen nobs=. 	
	forval t=636/722 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lntpa_aveweek_earn l1d.lntpa_aveweek_earn l2d.lntpa_aveweek_earn l6d.lntpa_aveweek_earn l1d.lntpa_priv m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if date>=wstart & date<=wend 
	replace nobs=e(N) if date==`t' 
	predict ptemp 
	replace pred=ptemp if date==`t' 
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lntpa_aveweek_earn)^2
summ errsq
gen rwpred = pred 
scalar RWrmse`w'=r(mean)^.5 
summ nobs rwpred
scalar RWminobs`w'=r(min) 
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

scalar rwrmse2 = 0.01479594

*Constructing a empirical interval - w = 72

gen residual=(d.lntpa_aveweek_earn-rwpred)
gen expres=exp(residual)
summ expres
scalar meanexpres=r(mean)
_pctile residual, percentiles(2.5,97.5)
gen pye=meanexpres*exp(l.lntpa_aveweek_earn+rwpred)
gen ubye=meanexpres*exp(l.lntpa_aveweek_earn+rwpred+r(r2))
gen lbye=meanexpres*exp(l.lntpa_aveweek_earn+rwpred+r(r1))

twoway (tsline tpa_aveweek_earn if tin(2018m1,2020m4)) ///
	(tsline pye ubye lbye if tin(2019m1,2020m4)), ///
	title("Actual and Empirical Forecast Florida for MSA's Average Weekly Earnings") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m4yemp, replace)
	
twoway (tsline tpa_aveweek_earn if tin(2019m1,2020m4)) ///
	(tsline pye ubye lbye if tin(2019m1,2020m4)), ///
	title("Empirical Forecast") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m4yemp, replace)

*Constructing a Gaussian intervar - w = 72

gen pyn=exp(l.lntpa_aveweek_earn+rwpred+(rwrmse2^2)/2)
gen ubyn=exp(l.lntpa_aveweek_earn+rwpred+1.96*rwrmse2+(rwrmse2^2)/2)
gen lbyn=exp(l.lntpa_aveweek_earn+rwpred-1.96*rwrmse2+(rwrmse2^2)/2)
twoway (tsline tpa_aveweek_earn if tin(2019m1,2020m2)) ///
	(tsline pyn ubyn lbyn if tin(2019m1,2020m3)), ///
	title("Actual and Approx. Normal Forecast for MSA's Average Weekly Earnings") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m4ynorm, replace)

twoway (tsline tpa_aveweek_earn if tin(2019m1,2020m2)) ///
	(tsline pyn ubyn lbyn if tin(2019m1,2020m3)), ///
	title("Approximately Normal Forecast") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m4ynorm, replace)
	
twoway (tsline tpa_aveweek_earn if tin(2018m1,2020m2)) ///
	(tsline pyn ubyn lbyn if tin(2019m1,2020m3)), ///
	title("Actual and Gaussian Forecast Florida for MSA's Average Weekly Earnings") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Upper Bound") label(4 "Lower Bound")) saving(m4ynorm2, replace)
	
graph combine m4ynorm.gph m4yemp.gph , ///
	saving(m4yen, replace)
	
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

twoway(tsline tpa_priv if tin(2019m1,2020m2))(tsline fub flb fcst if tin(2020m2,2020m3) ), title("Aproximately Normal Forecast") ytitle("") xtitle("") legend(label(1 "Actual") label(2 "Upper Bound") ///
	label(3 "Lower Bound") label(4 "Forecast")) saving(fcstn, replace)

graph combine fcstn.gph fcste.gph , ///
	saving(fcts, replace)