clear all
set more off

global projects: env projects
global storage : env storage
global dataready "$storage/econ689_data/ps01/data"
global output    "$projects/econ689/ps06/output"
capture mkdir "$projects/econ689/ps06"
capture mkdir "$output"
capture log close
log using "$output/ps06_jorgemartinez_log.txt", replace text
use "$dataready/card.dta", clear

regress lwage educ exper expersq
scalar ssr_r = e(rss)
scalar N     = e(N)

regress lwage educ exper expersq if south==0
scalar ssr_1 = e(rss)

regress lwage educ exper expersq if south==1
scalar ssr_2 = e(rss)

scalar ssr_u = ssr_1 + ssr_2
scalar dfr_u = N - 8
scalar J     = 4

scalar F_ssr = ((ssr_r - ssr_u)/J) / (ssr_u/dfr_u)
scalar p_ssr = Ftail(J, dfr_u, F_ssr)

display "SSR_r=" ssr_r "  SSR_1=" ssr_1 "  SSR_2=" ssr_2
display "N-2K=" dfr_u "  F=" F_ssr "  p=" p_ssr

gen south_educ    = south*educ
gen south_exper   = south*exper
gen south_expersq = south*expersq

regress lwage educ exper expersq south south_educ south_exper south_expersq
scalar ssr_int = e(rss)

display "SSR interacted = " ssr_int
display "SSR_1 + SSR_2  = " ssr_u
display "reldif         = " reldif(ssr_int, ssr_u)

test south south_educ south_exper south_expersq
display "F from test    = " r(F)
display "F from SSR form = " F_ssr
display "reldif          = " reldif(r(F), F_ssr)

if p_ssr < 0.05 {
    display "Reject H0 at the 5% level"
}
else {
    display "Fail to reject H0 at the 5% level"
}

log close
