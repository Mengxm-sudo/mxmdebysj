doedit "D:\Prog\新建文件夹\arima1.do" 
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
preserve
keep if train == 1
arimasel d_close
arima d_close, arima(2,0,3)
predict pred_d_close, y
gen pred_close = .
replace pred_close = close in 1
replace pred_close = pred_close[_n-1] + pred_d_close in 2/l
tsline pred_close close
tsline pred_close close, lcolor(blue red) lwidth(medium medium) title("实际收盘价与预测值对比") ytitle("收盘价") xtitle("时间") legend(label(1 "预测值") label(2 "实际值") pos(12) ring(0) bmargin(medium)) graphregion(fcolor(white)) plotregion(fcolor(white)) ylabel(5(5)30)
graph export "ARIMAin1.png", replace width(1200)
restore
preserve
arima d_close, arima(2,0,3)
arima d_close if _n<=1600, ar(1 2) ma(1 2 3)
predict pred_d_close, y
gen pred_close = .
replace pred_close = close in 1
replace pred_close = pred_close[_n-1] + pred_d_close in 2/l
tsline pred_close close
tsline close, lcolor(red) lwidth(medium) title("真实收盘价与预测值对比") ytitle("收盘价") || tsline pred_close if _n<=1600, lcolor(blue) || tsline pred_close if _n>1600, lcolor(green) legend(label(1 "真实值") label(2 "预测值(样本内)") label(3 "预测值(样本外)") pos(12) ring(0) bmargin(medium) region(fcolor(white))) graphregion(fcolor(white)) plotregion(fcolor(white))
graph export "ARIMAout1.png", replace width(1200)
predict resid, residuals
wntestq resid
restore
arima d_close if _n<=1600, ar(1 2) ma(1 2 3)
predict dyn_d_close, dynamic(1601)
gen dyn_close = .
replace dyn_close = close in 1
replace dyn_close = dyn_close[_n-1] + dyn_d_close in 2/l
tsline close, lcolor(red) lwidth(medium) title("真实收盘价与预测值对比") ytitle("收盘价") || tsline pred_close if _n<=1600, lcolor(blue) || tsline pred_close if _n>1600, lcolor(green) legend(label(1 "真实值") label(2 "预测值(样本内)") label(3 "预测值(样本外)") pos(12) ring(0) bmargin(medium) region(fcolor(white))) graphregion(fcolor(white)) plotregion(fcolor(white))
graph export "ARIMAout2.png", replace width(1200)