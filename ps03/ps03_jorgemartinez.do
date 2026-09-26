clear all
log using "ps03_jorgemartinez_log.txt", replace text
set seed 2026
set obs 500
gen x1 = rnormal(2,1)
gen v  = rnormal(0,1)
gen u  = rnormal(0,2)
gen x2 = 0.5*x1 + v
gen y  = 3 + 2*x1 - x2 + u
summarize y x1 x2
twoway (scatter y x1) (lfit y x1), title("Y on X1") xtitle("X1") ytitle("Y") legend(off) 
graph export "y1onx1.png", replace
twoway (scatter y x2) (lfit y x2), title("Y on X2") xtitle("X2") ytitle("Y") legend(off) 
graph export "y2onx2.png", replace
regress y x1 x2
predict yhat, xb
predict ehat, residual
gen x1_ehat = x1*ehat
gen x2_ehat = x2*ehat
summarize x1_ehat
display r(sum)
summarize x2_ehat
display r(sum)
twoway (scatter ehat x1) (lfit ehat x1) (function y=0,range (x1)), title("residuals on x1") ytitle("residual") legend(off)
graph export "ehatonx1.png" , replace
twoway (scatter ehat x2) (lfit ehat x2) (function y=0,range (x2)), title("residuals on x2") ytitle("residual") legend(off)
graph export "ehatonx2.png" , replace
summarize ehat
display r(sum)
display r(mean) 
summarize yhat
local ybar_hat = r(mean)
summarize y
local ybar = r(mean) 
display `ybar_hat'
display `ybar'
histogram ehat, xline(0) fcolor(%40) title("Residual Distribution") xtitle("residuals") ytitle("density")
graph export "ehathistogram.png" , replace
summarize x1
local x1bar = r(mean)
summarize x2
local x2bar = r(mean)
summarize y
local ybar  = r(mean)
local yhat_atmean = _b[_cons] + _b[x1]*`x1bar' + _b[x2]*`x2bar'
display `yhat_atmean'
display `ybar'
log close
