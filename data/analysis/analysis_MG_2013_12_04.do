*set path

global path "/Users/Marco/Google Drive/HEC/Paper/data"

*set to writing path:
cd "$path/analysis/GraphsTables"


******************First Analysis MG

use "$path/Mysteres2013Pl1And2Long.dta"

*****sample description

table own_age own_sexe SchoolDays , row col


*****some graphs


*****cooperation by gender and communication condition as a fct of age
preserve
collapse (mean) own_tr if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. , by(comm own_age own_sexe)
twoway ///
(line own_tr own_age if comm==0 & own_sexe ==0, sort color(blue)) ///
(line own_tr own_age if comm==1 & own_sexe ==0, sort color(blue) lpattern(dash)) ///
(line own_tr own_age if comm==0 & own_sexe ==1, sort color(red)) ///
(line own_tr own_age if comm==1 & own_sexe ==1, sort color(red) lpattern(dash)) ///
, scheme(s2color)




*****cooperation by gender and communication condition as a fct of age ***only school days:
preserve
collapse (mean) own_tr if own_age<15 & own_age>7 & own_age!=. & SchoolDays==1, by(comm own_age own_sexe)
twoway ///
(line own_tr own_age if comm==0 & own_sexe ==0, sort color(blue)) ///
(line own_tr own_age if comm==1 & own_sexe ==0, sort color(blue) lpattern(dash)) ///
(line own_tr own_age if comm==0 & own_sexe ==1, sort color(red)) ///
(line own_tr own_age if comm==1 & own_sexe ==1, sort color(red) lpattern(dash)) ///
, scheme(s2color)






***development of group coop by gender composition
use "$path/Mysteres2013Pl1And2Long.dta", clear
preserve
collapse (mean) group_coop if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(boys_group girls_group mixed_group round SchoolDays comm)
twoway ///
(line group_coop round if boys_group==1, sort lwidth(thick) lcolor(blue)) ///
(line group_coop round if girls_group==1, sort lwidth(thick) lcolor(red)) ///
(line group_coop round if mixed_group==1, sort lwidth(thick) lcolor(green)) ///
, by(SchoolDays comm, note("")) scheme(s2color)

use "$path/Mysteres2013Pl1And2Long.dta", clear
preserve
collapse (mean) group_coop if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(boys_group girls_group mixed_group round comm)
twoway ///
(line group_coop round if boys_group==1, sort lwidth(thick) lcolor(blue)) ///
(line group_coop round if girls_group==1, sort lwidth(thick) lcolor(red)) ///
(line group_coop round if mixed_group==1, sort lwidth(thick) lcolor(green)) ///
, by(comm, note("")) scheme(s2color)


use "$path/Mysteres2013Pl1And2Long.dta", clear
preserve
collapse (mean) own_tr if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(own_sexe round comm)
twoway ///
(line own_tr round if own_sexe==0, sort lwidth(thick) lcolor(blue)) ///
(line own_tr round if own_sexe==1, sort lwidth(thick) lcolor(red)) ///
, by(comm, note("")) scheme(s2color) legend(order(1 "boys" 2 "girls")) ///
xtitle("Round") ytitle("% Cooperation choices") xlabel(1 2 3)

**--> interaction between gender and communication possibility: The gender difference only comes out if you allow for communication.


use "$path/Mysteres2013Pl1And2Long.dta", clear
preserve
collapse (mean) own_tr if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. &SchoolDays==1, by(own_sexe round comm)
twoway ///
(line own_tr round if own_sexe==0, sort lwidth(thick) lcolor(blue)) ///
(line own_tr round if own_sexe==1, sort lwidth(thick) lcolor(red)) ///
, by(comm, note("")) scheme(s2color) legend(order(1 "boys" 2 "girls")) ///
xtitle("Round") ytitle("% Cooperation choices") xlabel(1 2 3)


use "$path/Mysteres2013Pl1And2Long.dta", clear
preserve
collapse (mean) own_tr if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. &SchoolDays==1, by(own_sexe other_sexe round comm)
twoway ///
(line own_tr round if own_sexe==0 & other_sexe==0, sort lwidth(thick) lcolor(blue)) ///
(line own_tr round if own_sexe==0 & other_sexe==1, sort lwidth(thick) lpattern(dash) lcolor(blue)) ///
(line own_tr round if own_sexe==1 & other_sexe == 1, sort lwidth(thick) lcolor(red)) ///
(line own_tr round if own_sexe==1 & other_sexe == 0, sort lwidth(thick) lpattern(dash) lcolor(red)) ///
, by(comm, note("")) scheme(s2color) legend(order(1 "boy with boy" 2 "boy with girl" 3 "girl with girl" 4 "girl with boy")) ///
xtitle("Round") ytitle("% Cooperation choices") xlabel(1 2 3)


*The interaction only comes from the Thu Fri data with the schools...
reg own_tr own_sexe##comm i.ML own_age round if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. & SchoolDays==1, cl(group_id)
reg own_tr own_sexe##comm i.ML own_age round if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. & SchoolDays==0, cl(group_id)

*look only at dyads with similar player age


reg own_tr own_sexe##comm i.ML own_age round if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. & SchoolDays==0 & age_diff<=1, cl(group_id)


***look at siblings effect
preserve
collapse (mean) group_coop if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. & SchoolDays==0, by(boys_group girls_group mixed_group round frangins comm)
twoway ///
(line group_coop round if boys_group==1, sort lwidth(thick) lcolor(blue)) ///
(line group_coop round if girls_group==1, sort lwidth(thick) lcolor(red)) ///
(line group_coop round if mixed_group==1, sort lwidth(thick) lcolor(green)) ///
, by(frangins comm, note("")) scheme(s2color)


***effects of communication content:
reg own_tr own_P_tr



***interaction of age and promises in comm condition?
preserve
collapse (mean) own_tr if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(own_age own_P_tr)
twoway ///
(line own_tr own_age if own_P_tr==0) ///
(line own_tr own_age if own_P_tr==1) ///
, scheme(s2color)
*not really

*effect of age on promise-making?
preserve
collapse (mean) own_P_tr if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(own_age own_sexe SchoolDays)
twoway ///
(line own_P_tr own_age if own_sexe==0, sort color(blue)) ///
(line own_P_tr own_age if own_sexe==1, sort color (red)) ///
, by(SchoolDays, note("")) scheme(s2color) xlabel(4(1)15)
*the effect comes from the very young kids...

