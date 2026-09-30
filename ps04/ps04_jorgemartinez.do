clear all
log using "ps04_jorgemartinez_log.txt", replace
set seed 2026
set obs 500

//Question 1:

gen x2 = rnormal(1,1)
gen v  = rnormal(0,1)
gen x1 = 0.7 * x2 + v
gen u  = rnormal(0,2)
gen y  = 5 + 3 * x1 - 2 * x2 + u
summarize y x1 x2
regress y x1 x2
scalar b1_full = _b[x1]
display "b1_full = " b1_full

//Question 2: Part 1

regress y x2
predict y_resid, residuals
summarize y_resid

//Question 2: Part 2

regress x1 x2
predict x1_resid, residuals
summarize x1_resid

//Question 2: Part 3

twoway (scatter y_resid x1_resid) (lfit y_resid x1_resid), title("Y Residuals on X1 Residuals") ytitle("y Residuals") xtitle("x1 Residuals") legend(off)

//Question 2: Part 4

regress y_resid x1_resid, noconstant
scalar b1_fwl = _b[x1_resid]
display "b1_fwl = " b1_fwl

//Question 2: part 5
scalar difference = b1_full - b1_fwl
display "b1_full = " b1_full
display "b1_fwl  = " b1_fwl
display "b1_full - b1_fwl = " difference
// the difference is zero

log close
