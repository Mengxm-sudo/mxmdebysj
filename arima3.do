import delimited "D:\Prog\bysj\SONY_daily_data.csv", rowrange(9066) clear
gen date1 = date(date, "YMD")
preserve
gen cut1 = _n <= 1290
keep if cut1 == 1
tsset date1
gen d_close = D.close
dfuller close
dfuller d_close
wntestq d_close
reg d_close volume
arima d_close, arima(3,0,2)
predict pred_d_close, y
gen pred_close = .
replace pred_close = close in 1
replace pred_close = pred_close[_n-1] + pred_d_close in 2/l
tsline pred_close close
predict resid,residuals
wntestq resid
export excel using "cut1.xlsx", firstrow(variables) replace
restore
preserve
gen cut2 = inrange(_n, 1290, 1486)
keep if cut2 == 1
tsset date1
gen d_close = D.close
dfuller close
dfuller d_close
wntestq d_close
reg d_close volume
arimasel d_close
arima d_close, arima(1,0,2)
predict pred_d_close, y
gen pred_close = .
replace pred_close = close in 1
replace pred_close = pred_close[_n-1] + pred_d_close in 2/l
tsline pred_close close
predict resid,residuals
wntestq resid
export excel using "cut2.xlsx", firstrow(variables) replace
restore
preserve
gen cut3 = _n >= 1487
keep if cut3 == 1
tsset date1
gen d_close = D.close
dfuller close
wntestq close
ac close
dfuller d_close
wntestq d_close
reg close volume
reg d_close volume
arimasel d_close
arima d_close, arima(1,0,0)
predict pred_d_close, y
gen pred_close = .
replace pred_close = close in 1
replace pred_close = pred_close[_n-1] + pred_d_close in 2/l
tsline pred_close close
predict resid,residuals
wntestq resid
export excel using "cut3.xlsx", firstrow(variables) replace
