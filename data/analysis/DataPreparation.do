**********************************************
*****************MYSTERES 2013****************
**********************************************

**********import data from Excel files

cd "F:\Dropbox\Projects\MYSTERES\data"

clear
import excel using "dataMystères2013JeVe.xlsx",  firstrow
gen SchoolDays=1
save Mysteres2013JeVe.dta, replace

clear
import excel using "dataMystères2013SaDi.xls",  firstrow 
drop AY
tostring ecole, replace
gen SchoolDays=0
save Mysteres2013SaDi.dta, replace


use Mysteres2013JeVe.dta, clear
append using Mysteres2013SaDi.dta
replace ML=0 if SchoolDays==0
save Mysteres2013raw.dta, replace



***create Player 1 and Player 2 files
*-> create one row per player with the row containing also the data of the other player
*-> rename variables from the perspective of the focal player

*for "type 1" players (i.e. the players with the odd numbers)

use Mysteres2013raw.dta, clear

rename j1_no own_no 
rename j1_sexe own_sexe 
rename j1_age own_age 
rename j1_tr1 own_tr1 
rename j1_tr2 own_tr2 
rename j1_tr3 own_tr3 
rename j1_P_tr1 own_P_tr1 
rename j1_M_tr1 own_M_tr1 
rename j1_A_tr1 own_A_tr1 
rename j1_G_tr1 own_G_tr1 
rename j1_E_tr1 own_E_tr1 
rename j1_P_tr2 own_P_tr2 
rename j1_M_tr2 own_M_tr2 
rename j1_A_tr2 own_A_tr2 
rename j1_G_tr2 own_G_tr2 
rename j1_E_tr2 own_E_tr2 
rename j1_P_tr3 own_P_tr3 
rename j1_M_tr3 own_M_tr3 
rename j1_A_tr3 own_A_tr3 
rename j1_G_tr3 own_G_tr3 
rename j1_E_tr3 own_E_tr3

rename j2_no other_no 
rename j2_sexe other_sexe 
rename j2_age other_age 
rename j2_tr1 other_tr1 
rename j2_tr2 other_tr2 
rename j2_tr3 other_tr3 
rename j2_P_tr1 other_P_tr1 
rename j2_M_tr1 other_M_tr1 
rename j2_A_tr1 other_A_tr1 
rename j2_G_tr1 other_G_tr1 
rename j2_E_tr1 other_E_tr1 
rename j2_P_tr2 other_P_tr2 
rename j2_M_tr2 other_M_tr2 
rename j2_A_tr2 other_A_tr2 
rename j2_G_tr2 other_G_tr2 
rename j2_E_tr2 other_E_tr2 
rename j2_P_tr3 other_P_tr3 
rename j2_M_tr3 other_M_tr3 
rename j2_A_tr3 other_A_tr3 
rename j2_G_tr3 other_G_tr3 
rename j2_E_tr3 other_E_tr3 

gen type=1

save Mysteres2013Players1.dta, replace


*for "type 2" players (i.e. the players with the even numbers)

use Mysteres2013raw.dta, clear

rename j2_no own_no 
rename j2_sexe own_sexe 
rename j2_age own_age 
rename j2_tr1 own_tr1 
rename j2_tr2 own_tr2 
rename j2_tr3 own_tr3 
rename j2_P_tr1 own_P_tr1 
rename j2_M_tr1 own_M_tr1 
rename j2_A_tr1 own_A_tr1 
rename j2_G_tr1 own_G_tr1 
rename j2_E_tr1 own_E_tr1 
rename j2_P_tr2 own_P_tr2 
rename j2_M_tr2 own_M_tr2 
rename j2_A_tr2 own_A_tr2 
rename j2_G_tr2 own_G_tr2 
rename j2_E_tr2 own_E_tr2 
rename j2_P_tr3 own_P_tr3 
rename j2_M_tr3 own_M_tr3 
rename j2_A_tr3 own_A_tr3 
rename j2_G_tr3 own_G_tr3 
rename j2_E_tr3 own_E_tr3

rename j1_no other_no 
rename j1_sexe other_sexe 
rename j1_age other_age 
rename j1_tr1 other_tr1 
rename j1_tr2 other_tr2 
rename j1_tr3 other_tr3 
rename j1_P_tr1 other_P_tr1 
rename j1_M_tr1 other_M_tr1 
rename j1_A_tr1 other_A_tr1 
rename j1_G_tr1 other_G_tr1 
rename j1_E_tr1 other_E_tr1 
rename j1_P_tr2 other_P_tr2 
rename j1_M_tr2 other_M_tr2 
rename j1_A_tr2 other_A_tr2 
rename j1_G_tr2 other_G_tr2 
rename j1_E_tr2 other_E_tr2 
rename j1_P_tr3 other_P_tr3 
rename j1_M_tr3 other_M_tr3 
rename j1_A_tr3 other_A_tr3 
rename j1_G_tr3 other_G_tr3 
rename j1_E_tr3 other_E_tr3 

gen type=2

save Mysteres2013Players2.dta, replace


*****append Player1 and Player2 file

use Mysteres2013Players1, clear
append using Mysteres2013Players2.dta
save Mysteres2013Pl1And2Wide.dta, replace

drop if classe==.				
*deletes an empty row



**generates ID variables
use Mysteres2013Pl1And2Wide.dta, clear

replace classe = 590 if classe == 59 & SchoolDays==1

gen group_id = classe*100+sequence*10+poste
gen own_id = group_id*10+type
gen other_id = group_id*10+1 if type==2
replace other_id = group_id*10+2 if type==1


***gen some additional variables

gen boys_group=0
replace boys_group=1 if own_sexe==0 & other_sexe==0

gen girls_group=0
replace girls_group=1 if own_sexe==1 & other_sexe==1

gen mixed_group=0
replace mixed_group=1 if boys_group==0 & girls_group==0

replace frangins = 0 if SchoolDays==1
replace frangins = 0 if SchoolDays==0 & frangins ==.

gen age_diff = abs(own_age-other_age) 


***label variables
label define comm 0 "no communication" 1 "communication"
label values comm comm

label define frangins 0 "no siblings" 1 "siblings"
label values frangins frangins

save Mysteres2013Pl1And2Wide.dta, replace



*******generate Long File
use Mysteres2013Pl1And2Wide.dta, clear
reshape long own_tr other_tr own_P_tr own_M_tr own_A_tr own_G_tr own_E_tr other_P_tr other_M_tr other_A_tr other_G_tr other_E_tr, i(own_id) j(round)
save Mysteres2013Pl1And2Long.dta, replace


***gen some additional variables
gen group_coop=0
replace group_coop=1 if own_tr==1 & other_tr==1

save Mysteres2013Pl1And2Long.dta, replace


******************First Analysis MG

*****sample description

table own_age own_sexe SchoolDays , row col


*****some graphs
preserve
collapse (mean) own_tr1 if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. &SchoolDays==1 , by(comm own_age own_sexe)
twoway ///
(line own_tr1 own_age if comm==0 & own_sexe ==0, sort color(blue)) ///
(line own_tr1 own_age if comm==1 & own_sexe ==0, sort color(blue) lpattern(dash)) ///
(line own_tr1 own_age if comm==0 & own_sexe ==1, sort color(red)) ///
(line own_tr1 own_age if comm==1 & own_sexe ==1, sort color(red) lpattern(dash)) ///
, scheme(s2color)




***development of group coop by gender composition
use Mysteres2013Pl1And2Long.dta, clear
preserve
collapse (mean) group_coop if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(boys_group girls_group mixed_group round SchoolDays comm)
twoway ///
(line group_coop round if boys_group==1, sort lwidth(thick) lcolor(blue)) ///
(line group_coop round if girls_group==1, sort lwidth(thick) lcolor(red)) ///
(line group_coop round if mixed_group==1, sort lwidth(thick) lcolor(green)) ///
, by(SchoolDays comm, note("")) scheme(s2color)

use Mysteres2013Pl1And2Long.dta, clear
preserve
collapse (mean) group_coop if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(boys_group girls_group mixed_group round comm)
twoway ///
(line group_coop round if boys_group==1, sort lwidth(thick) lcolor(blue)) ///
(line group_coop round if girls_group==1, sort lwidth(thick) lcolor(red)) ///
(line group_coop round if mixed_group==1, sort lwidth(thick) lcolor(green)) ///
, by(comm, note("")) scheme(s2color)


use Mysteres2013Pl1And2Long.dta, clear
preserve
collapse (mean) own_tr if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=., by(own_sexe round comm)
twoway ///
(line own_tr round if own_sexe==0, sort lwidth(thick) lcolor(blue)) ///
(line own_tr round if own_sexe==1, sort lwidth(thick) lcolor(red)) ///
, by(comm, note("")) scheme(s2color) legend(order(1 "boys" 2 "girls")) ///
xtitle("Round") ytitle("% Cooperation choices") xlabel(1 2 3)

**--> interaction between gender and communication possibility: The gender difference only comes out if you allow for communication!

use Mysteres2013Pl1And2Long.dta, clear
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

 


***look at siblings effect
preserve
collapse (mean) group_coop if own_age<16 & own_age>3 & own_age!=. & other_age<16 & other_age>3 & other_age!=. & SchoolDays==0, by(boys_group girls_group mixed_group round frangins comm)
twoway ///
(line group_coop round if boys_group==1, sort lwidth(thick) lcolor(blue)) ///
(line group_coop round if girls_group==1, sort lwidth(thick) lcolor(red)) ///
(line group_coop round if mixed_group==1, sort lwidth(thick) lcolor(green)) ///
, by(frangins comm, note("")) scheme(s2color)



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
