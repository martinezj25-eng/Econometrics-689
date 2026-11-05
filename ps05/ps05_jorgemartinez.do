clear all
set more off

global projects: env projects
global storage : env storage
global dataready "$storage/econ689_data/ps05/data"
global output    "$projects/econ689/ps05/output"

capture mkdir "$projects/econ689/ps05"
capture mkdir "$output"
capture log close
log using "$output/ps05_jorgemartinez_log.txt", replace text
use "$dataready/card.dta", clear
regress lwage educ exper expersq black south smsa smsa66 reg662-reg669
scalar ssr_u = e(rss)
scalar dfr_u = e(df_r)
gen byte insample = e(sample)
display "SSR_u = " ssr_u
display "N - K = " dfr_u
scalar J2 = 8
test reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669
scalar F_test = r(F)
scalar p_test = r(p)
display "J = " J2
display "F = " F_test
display "p = " p_test
regress lwage educ exper expersq black south smsa smsa66 if insample
scalar ssr_r = e(rss)
display "SSR_r = " ssr_r
scalar F_ssr = ((ssr_r - ssr_u)/J2) / (ssr_u/dfr_u)
scalar p_ssr = Ftail(J2, dfr_u, F_ssr)
display "F (SSR form) = " F_ssr
display "p-value      = " p_ssr
display "reldif       = " reldif(F_ssr, F_test)


if p_ssr < 0.05 {
    display "Reject H0 at the 5% level"
}
else {
    display "Fail to reject H0 at the 5% level"
}



clear
set seed 2026
set obs 500

gen x1 = rnormal(0,1)
gen v  = rnormal(0,1)
gen x2 = 0.5*x1 + v
gen x3 = rnormal(1,1)
gen u  = rnormal(0,2)
gen y  = 1 + 1*x1 + 0.5*x2 - 0.5*x3 + u

summarize y x1 x2 x3 v u
regress y x1 x2 x3

scalar J3 = 2
test (x1 = 1) (x2 + x3 = 0)
scalar F_test3 = r(F)
scalar p_test3 = r(p)

display "F = " F_test3
display "p = " p_test3

matrix b = e(b)
matrix V = e(V)

matrix R = (1, 0, 0, 0 \ 0, 1, 1, 0)
matrix r = (1 \ 0)

matrix d = R*b' - r
matrix W = d' * invsym(R*V*R') * d

scalar F_mat = W[1,1] / J3
scalar p_mat = Ftail(J3, e(df_r), F_mat)

display "F (matrix) = " F_mat
display "p-value    = " p_mat
display "reldif     = " reldif(F_mat, F_test3)


if p_mat < 0.05 {
    display "Reject H0 at the 5% level"
}
else {
    display "Fail to reject H0 at the 5% level"
}


log close


