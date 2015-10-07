global path "/Users/Marco/Google Drive/HEC/Paper/data"
cd "$path"
cd ..

**cleaning
use "$path/Mysteres2013Pl1And2Long.dta", clear

drop if own_age == . | other_age == .
//gender group
rename own_sex own_sex
rename other_sex other_sex
label define sexL 0 "Male" 1 "Female"
label values own_sex sexL
label values other_sex sexL
gen groupGender = .
replace groupGender = 0 if (own_sex == 0 & other_sex == 0) 
replace groupGender = 1 if (own_sex == 1 & other_sex == 1) 
replace groupGender = 2 if (own_sex == 0 & other_sex == 1)
replace groupGender = 3 if (own_sex == 1 & other_sex == 0)
label define groupSexL 0 "MM" 1 "FF" 2 "MF" 3 "FM"
label values groupGender groupSexL
drop if SchoolDays == 0 //only keep the school values
drop if own_age > 18 | other_age > 18 //removes the games involving the profs
drop if own_tr == . | other_tr == .
gen gg = own_tr & other_tr
gen rr = !own_tr & !other_tr
gen rg = !own_tr & other_tr //best return
gen gr = own_tr & !other_tr //worst return
drop if gg==.
tsset own_id round
//old action
gen pgg = L.gg
gen prr = L.rr
gen prg = L.rg
gen pgr = L.gr
gen previousStrat = .
replace previousStrat = 1 if (pgg == 1) 
replace previousStrat = 2 if (prr == 1) 
replace previousStrat = 3 if (prg == 1) 
replace previousStrat = 4 if (pgr == 1) 
label define prevStratL 1 "Green Green" 2 "Red Red" 3 "Red Green" 4 "Green Red"
label values previousStrat prevStratL
gen payoff = 5*rg+3*gg+1*rr+0*gr
gen totalPayoff = 2*rr + 5*(rg|gr) + 6*gg
egen ownPayoff = sum(payoff), by(own_id)
egen socialPayoff = sum(totalPayoff), by(own_id)



//mean age
gen age = (own_age + other_age)/2


save data/dataLong.dta, replace
