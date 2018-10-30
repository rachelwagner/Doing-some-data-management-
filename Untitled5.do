/* Collapsing tot word count by usrid & date */
insheet using /mnt/commons/rachel/100kSamplOfAllSeed4694329905allBooksReadMin1revV1.csv, clear names
keep if rev~=""
keep if rev~="."
keep if rev~="..."
egen str_felt= nss(rev) , find("felt") insensitive //3,226
egen str_feel= nss(rev) , find("feel") insensitive //5,349
egen str_both= nss(rev) , find("both") insensitive //2,788	
egen str_und= nss(rev) , find("understand") insensitive //2,234
egen str_thi= nss(rev) , find("think") insensitive //7,412

egen str_rel= nss(rev) , find("relate") insensitive //962
egen str_mov= nss(rev) , find("moved") insensitive //645
egen str_real= nss(rev) , find("realize") insensitive //965
egen str_mind= nss(rev) , find("mind") insensitive //2,929
egen str_persp= nss(rev), find("perspective") insensitive //1,144
egen tot=rowtotal(str_*)

//generating 'date'
gen year=substr(datadd, -5,4) 
gen daymo=substr(datadd, 5,6) 
gen mo1=substr(daymo, 1,3)
gen day1=substr(daymo, -2,2)
l datadd year daymo mo1 day1 in 1/10
// Replacing month words with month numbers ("Jan" to "1") 
gen mo2=""
replace mo2="01" if mo1=="Jan"
replace mo2="02" if mo1=="Feb"
replace mo2="03" if mo1=="Mar"
replace mo2="04" if mo1=="Apr"
replace mo2="05" if mo1=="May"
replace mo2="06" if mo1=="Jun"
replace mo2="07" if mo1=="Jul"
replace mo2="08" if mo1=="Aug"
replace mo2="09" if mo1=="Sep"
replace mo2="10" if mo1=="Oct"
replace mo2="11" if mo1=="Nov"
replace mo2="12" if mo1=="Dec"
gen date=year+"-"+mo2+"-"+day1
ta date // it worked!
//saving data so that i can just load it with date and empathy words at once
save rachel1,replace
use rachel1, clear

collapse (sum) tot , by(usrid date)

gen counter=1
bys usrid: egen countSum=total(counter) //sumCount is...?
//'timer' is the number of reviews per day 
sort usrid date
bys usrid: gen timer=_n

line tot timer if  usrid==187043 //countSum>1000



