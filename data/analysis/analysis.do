global path "/Users/Marco/Google Drive/HEC/Paper/data"
use "$path/dataLong.dta", clear
cd  "$path"

**analysis

**general results by sex
use "$path/dataLong.dta", clear
*drop if comm == 0 // TEMP
tabstat gg rr rg, by(round)  stat("mean") format(%5.0g) // ex-ante results
tabstat gg rr rg if boys_group == 1, by(round)  stat("mean") format(%5.0g) 
tabstat gg rr rg if girls_group == 1, by(round)  stat("mean") format(%5.0g) 
tabstat gg rr rg if mixed_group == 1, by(round)  stat("mean") format(%5.0g)

**coop reaction
tabstat gg rr rg gr if pgg == 1, by(groupGender) statistics("mean n")
** uncoop reaction
tabstat gg rr rg gr if prr == 1, by(groupGender) statistics("mean n")
** gr reaction
tabstat gg rr rg gr if pgr == 1, by(groupGender) statistics("mean n")
** rg reaction
tabstat gg rr rg gr if prg == 1, by(groupGender) statistics("mean n")

tabstat own_tr if round == 1 , by(own_age) statistics("mean count")


table own_age own_sex , row col

** graphs

use "$path/dataLong.dta", clear
preserve
collapse (mean) group_coop if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(boys_group girls_group mixed_group round comm)
twoway ///
(line group_coop round if boys_group==1, sort lwidth(thick) lcolor(blue)) ///
(line group_coop round if girls_group==1, sort lwidth(thick) lcolor(red)) ///
(line group_coop round if mixed_group==1, sort lwidth(thick) lcolor(green)) ///
, by(comm, note("")) scheme(s2color)


use "$path/dataLong.dta", clear
preserve
collapse (mean) own_tr if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(own_sex round comm)
twoway ///
(line own_tr round if own_sex==0, sort lwidth(thick) lcolor(blue)) ///
(line own_tr round if own_sex==1, sort lwidth(thick) lcolor(red)) ///
, by(comm, note("")) scheme(s2color) legend(order(1 "boys" 2 "girls")) ///
xtitle("Round") ytitle("% Cooperation choices") xlabel(1 2 3)


use "$path/dataLong.dta", clear
preserve
	collapse (mean) own_tr if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. &SchoolDays==1, by(own_sex other_sex round comm)
	twoway ///
	(line own_tr round if own_sex==0 & other_sex==0, sort lwidth(thick) lcolor(blue)) ///
	(line own_tr round if own_sex==0 & other_sex==1, sort lwidth(thick) lpattern(dash) lcolor(blue)) ///
	(line own_tr round if own_sex==1 & other_sex == 1, sort lwidth(thick) lcolor(red)) ///
	(line own_tr round if own_sex==1 & other_sex == 0, sort lwidth(thick) lpattern(dash) lcolor(red)) ///
	, by(comm, note("")) scheme(s2color) legend(order(1 "boy with boy" 2 "boy with girl" 3 "girl with girl" 4 "girl with boy")) ///
	xtitle("Round") ytitle("% Cooperation choices") xlabel(1 2 3)
	graph export "round.eps"
restore


preserve
	global params "stack ytitle(p) nodraw bar(1, color(green)) bar(2, color(red)) bar(3, color(orange)) bar(4, color(blue*0.6)) legend(order(1 "GG" 2 "RR"  3 "RG" 4 "GR") )"
	graph bar gg rr rg gr, over(groupGender) saving(g0, replace)   $params title("All rounds")
	graph bar gg rr rg gr if round == 1, over(groupGender) saving(g1, replace)  $params title("Round 1")
	graph bar gg rr rg gr if round == 2, over(groupGender) saving(g2, replace)  $params title("Round 2")
	graph bar gg rr rg gr if round == 3, over(groupGender) saving(g3, replace)  $params title("Round 3")
	graph combine g0.gph g1.gph g2.gph g3.gph
	graph export "roundBar.eps"
restore

** age 
use "$path/dataLong.dta", clear
preserve
	global params "nodraw legend(order(1 "MM" 2 "FF"  3 "Mixed") )"
	collapse (mean) ownPayoff socialPayoff  if own_age<14 & own_age>8 & own_age!=. & other_age<14 & other_age>8 & other_age!=., by(boys_group girls_group mixed_group own_age)
	twoway ///
	(line ownPayoff own_age if boys_group==1, sort lwidth(thick) lcolor(blue)) ///
	(line ownPayoff own_age if girls_group==1, sort lwidth(thick) lcolor(red)) ///
	(line ownPayoff own_age if mixed_group==1, sort lwidth(thick) lcolor(green)) ///
	, scheme(s2color) $params saving(g0, replace) title("Personal Payoff")
	
		twoway ///
	(line socialPayoff own_age if boys_group==1, sort lwidth(thick) lcolor(blue)) ///
	(line socialPayoff own_age if girls_group==1, sort lwidth(thick) lcolor(red)) ///
	(line socialPayoff own_age if mixed_group==1, sort lwidth(thick) lcolor(green)) ///
	, scheme(s2color) $params saving(g1, replace) title("Group Payoff")
	
	graph combine g0.gph g1.gph
	graph export "age.eps", replace
restore

***total utility
global params " ytitle(Number of candies)  legend(order(1 "Own Payoff" 2 "Group Payoff") )"
graph bar ownPayoff socialPayoff, over(groupGender) saving(g0, replace)   $params
graph export "totalPayoff.eps", replace


**** Behavior
** OLS

global mainParams "own_age own_sex comm"
global otherParams "age_diff"
reg own_tr $mainParams $otherParams, robust cluster(group_id)
outreg2 using behav_results, label replace dec(3) tex(frag pr)
global mainParams "own_age comm"
global otherParams "age_diff i.groupGender"
reg own_tr $mainParams $otherParams, robust cluster(group_id)
outreg2 using behav_results, label append dec(3) tex(frag pr)
logit own_tr $mainParams $otherParams, robust cluster(group_id)
margins, dydx(*) atmeans post
outreg2 using behav_results, label append dec(3) tex(frag pr)
global otherParams "age_diff ib1.groupGender"
logit own_tr $mainParams $otherParams, robust cluster(group_id)
margins, dydx(*) atmeans post
outreg2 using behav_results, label append dec(3) tex(frag pr)



** comm and round
global mainParams "own_age "
global otherParams "i.groupGender*i.round"
xi: logit own_tr $mainParams $otherParams, cluster(group_id)
margins, dydx(*) atmeans post
outreg2 using round_comm, label replace dec(3) tex(frag pr)
xi: logit own_tr $mainParams $otherParams if comm == 0, cluster(group_id)
margins, dydx(*) atmeans post
outreg2 using round_comm, label append dec(3) tex(frag pr)
xi: logit own_tr $mainParams $otherParams  if comm == 1, cluster(group_id)
margins, dydx(*) atmeans post
outreg2 using round_comm, label append dec(3) tex(frag pr)




**** Total utility (sum of the 3 rounds)
** personal payoff
global mainParams "age comm"
global otherParams "age_diff ib0.groupGender"
reg ownPayoff $mainParams $otherParams, robust cluster(group_id)
outreg2 using total_results, label replace dec(3) tex(frag pr)

global otherParams "age_diff ib1.groupGender"
reg ownPayoff $mainParams $otherParams, robust cluster(group_id)
outreg2 using total_results, label append dec(3) tex(frag pr)

**social payoff
global otherParams "age_diff ib0.groupGender"
reg socialPayoff $mainParams $otherParams, robust cluster(group_id)
outreg2 using total_results, label append dec(3) tex(frag pr)

global otherParams "age_diff ib1.groupGender"
reg socialPayoff $mainParams $otherParams, robust cluster(group_id)
outreg2 using total_results, label append dec(3) tex(frag pr)


**** COOPERATION
*** SINGLE RESPONSE

** a priori behavior

preserve
	//gen age_x_comm = age*comm
	global mainParams "age comm"
	global otherParams "age_diff i.groupGender"
	drop if pgg != . //select only first round
	reg gg $mainParams $otherParams, robust cluster(group_id)
	outreg2 using first_coop, label replace dec(3) tex(frag pr)
	logit gg $mainParams $otherParams, robust cluster(group_id)
	margins, dydx(*) atmeans post
	outreg2 using first_coop, label append dec(3) tex(frag pr)
		
	reg rr $mainParams $otherParams, robust cluster(group_id)
	outreg2 using first_coop, label append dec(3) tex(frag pr)
	logit rr $mainParams $otherParams, robust cluster(group_id)
	margins, dydx(*) atmeans post
	outreg2 using first_coop, label append dec(3) tex(frag pr)
	
	//logit rg $mainParams $otherParams, robust
	//logit gr $mainParams $otherParams, robust

restore

** regressions on reactions
use "$path/dataLong.dta", clear

gen gg_x_round3 = round == 3 & previousStrat == 1



global mainParams "i.previousStrat age comm"
global otherParams "i.round age_diff i.groupGender"

** gg
reg gg $mainParams $otherParams, robust cluster(group_id)
outreg2 using last_coop, label replace dec(3) tex(frag pr)
logit gg $mainParams $otherParams, robust cluster(group_id)
margins, dydx(*) atmeans post
outreg2 using last_coop, label append dec(3) tex(frag pr)

global mainParams "i.previousStrat age comm gg_x_round3 "
global otherParams "i.round age_diff i.groupGender"
logit gg $mainParams $otherParams, robust cluster(group_id)
margins, dydx(*) atmeans post
outreg2 using last_coop, label append dec(3) tex(frag pr)

global mainParams "i.previousStrat age comm"
global otherParams "i.round age_diff i.groupGender"
**rr
reg rr $mainParams $otherParams, robust cluster(group_id)
outreg2 using last_coop, label append dec(3) tex(frag pr)
logit rr $mainParams $otherParams, robust cluster(group_id)
margins, dydx(*) atmeans post
outreg2 using last_coop, label append dec(3) tex(frag pr)
//logit rg $mainParams $otherParams, robust cluster(own_id)
//logit gr $mainParams $otherParams, robust cluster(own_id)

**coop reaction
tabstat gg rr rg gr if pgg == 1, by(own_age) statistics("mean")
