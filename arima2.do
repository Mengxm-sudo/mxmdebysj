import delimited "D:\Prog\bysj\SONY_daily_data.csv", rowrange(9066) clear
gen date1 = date(date, "YMD")
gen train = _n <= 1600
gen test  = _n >  1600
tsset date1
dfuller close
dfuller close if train == 1
gen d_close = D.close
wntestq close
dfuller d_close if train == 1
wntestq d_close if train == 1
dfuller volume if train == 1
reg d_close volume if train==1
arimasel d_close
arima d_close, arima(2,0,3)
predict pred_d_close, y
gen pred_close = .
replace pred_close = close in 1
replace pred_close = pred_close[_n-1] + pred_d_close in 2/l
tsline pred_close close
keep if _n > _N - 400
format close %9.4f
format pred_close %9.4f
export excel date1 close pred_close using "D:\Prog\bysj\ARIMA_result_400.xlsx", replace firstrow(variables)
