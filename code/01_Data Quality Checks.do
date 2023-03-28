//March 16th 
//Checking Mayor Study Data/Respondent quality

//for checking response non-differentiation (straightlining)
 ssc install respdiff


//Duration Check. 60 seconds is 1 minute. 600 seconds is 10 minutes.
sum durationinseconds, d 
* mean 494 seconds, 7 minutes
* median 385.5, 6.4 minutes
* speeders = 128.5, Round to 130.
sum durationinseconds if durationinseconds<=130
* 28 super low obs.
sum durationinseconds if durationinseconds<=193
* 138. Lots of people took less than half of median. These are prime suspects.
hist durationinseconds 


//Attention Check
tab1 wcbm_att wcwm_att bcbm_att bcwm_att control_att
* 65 attention check failures. Look into these fools.

//Straight Liner check
*Tons of Straighliners.


//Number of misisng responses
misstable summarize wcbm_att wcwm_att bcbm_att bcwm_att control_att if dq==0
misstable summarize dv1 dv2
misstable summarize rr1 rr2 rr3 rr4
misstable summarize laws_1 laws_2 laws_3 laws_4 laws_5 election20_1  election20_2 election20_3 election20_4 election22_1 election22_2 election22_3 election22_4 election22_5

//Open ender gibberish/long crazy response checks


//Gonna take this in sets of 100


//in depth
sort durationinseconds

//Data Quality Assurance Process
// Collection of data was completed late Wednesday Match 15th. 
// I downloaded 1274 responses from Qualtrics.
// Before looking at the data, I removed the dependent variable collumns from the .csv in the numbers application.
// This was DV1 and DV2 in the data. Voter Fraud and Vote Counting variables.
// I did this so that it would be less likely that I would flad inattentive respondents based on relevant outcomes.
// I then imported the data into stata and sorted by Duration (in seconds).
// I took mean response time and divided it by 2. 
// Then i looked more closely at all responses that fell under 193 seconds.


//Criteria for flagging observations
* Time = Median / 2
* Incorrect Attention Check
* Incorrect Manipulation Checks 
* Gibberish, broken english sentences in Open response. Foreign symbols.
* Things like DK and NA were taken into account if other red flags occured.
* Inconsistency in Answers (Examples Below)
// A 20 year old making more than 120 thousand.
// A Strong Republican/Strong Liberal (not sufficient, but a consideration)
// Saying Fraud will be high in Lancaster in 2022 in the control condition.
// Racial Resentment extreme inconsistency HIGH LOW LOW HIGH. 
// Davis Wilson resentment as a secondary check if above failed.
// Straight Lining For Multiple Pages/grids
// Patterned responses for multiple pages/grids
//Taking Multiple Minutes on the experimental vignette.

//On Friday March 17th I had completed looking at participants with less than 193 seconds. 
// Data quality was not improving substantiollu. 
// Decided to expand search until 10 respondents ina row were at least boarderline/Probably real
// My definition of boarderline (no extreme violations)




/// Getting a sense of the raw and DQ'd data
tab1 dq //25% currently dropped for severe inattention/speedster/straightling, nonsense demographics.
mean durationinseconds
mean durationinseconds if dq==0 //about 1 minute more

//Condition Frequencies. Pre/post proportion of sample.
tab1 wcwm wcbm bcbm bcwm control 			// 	19.9 		19.3 	20 		20.2 	20.4
tab1 wcwm wcbm bcbm bcwm control if dq==0  // 	19.1		19.6 	20.9  	20		20.2

//Manipulation Frequencies. Pre/post proportion of sample.
tab1 control bm bc wm wc 			//20.4	39.3	40.3	40.2	39.2
tab1 control bm bc wm wc if dq==0  //20.2	40.59	41		39.2	38.79 //prob need to add white or remove black more stricctly.

tab1 gun_own
tab1 gun_own if dq==0 //wend down a bit. Seems correct.

//Davis and Wilson Scale. This probably benefited from rampant straightlining.
tab1 dw1 dw2 dw3 dw4
alpha dw1 dw2 dw3 dw4
alpha dw1 dw2 dw3 dw4 if dq==0

pwcorr pid ideo,obs sig //.59
pwcorr pid ideo if dq==0,obs sig //.7

////////////Some DESCRIPTIVES

///On Manipution checks.
 //Race of city: 
 tab1 wcbm1 wcwm1 bcbm1 bcwm1 			//58 75 61 54
 tab1 wcbm1 wcwm1 bcbm1 bcwm1 if dq==0  //63 76 69 67 //some interesting increases. Why didnt wcwm improve as much?
* +5, +1, +8, +13

//Race of City officials
 tab1 wcbm2 wcwm2 bcbm2 bcwm2 			//80 85 86 81 (rounded up)
 tab1 wcbm2 wcwm2 bcbm2 bcwm2 if dq==0  //89 87 93 86
* +9, +2, +7, +5
 
 
 //Attention Checks
tab1 wcbm_att wcwm_att bcbm_att bcwm_att control_att 			// 95 96 94 91 92
tab1 wcbm_att wcwm_att bcbm_att bcwm_att control_att if dq==0  // 98 97 99 99 99 
//These dont go to 100 because if it was their only infrindement, it was not sufficient.


//Demographics
mean age
mean age if dq==0 //sample hets older


mean edu
mean edu if dq==0 //samples gets less edu


mean inc
mean inc if dq==0 //samples gets richer


tab1 pid
mean pid
mean pid if dq==0 //sample gets more GOP

tab1 ideo
mean ideo
mean ideo if dq==0 //sample gets more conservative



//Variation on DV
tab1 dv1
tab1 dv1 dv2
hist dv1 if dq==0 //higher is LESS voter fraud currently
hist dv2  if dq==0 //higher is LESS ballot tampering/issues counting currently

tab1 culture


mean dv1
mean dv2
mean dv1 if dq==0 //got higher by .3
mean dv2 if dq==0 //got higher by .23 
//Probably because most all straighliners used "strongly agree" whch was coded as "1" out of 5 on scale.

//making conditions
gen wcwm=0
replace wcwm=1 if wcwm1==1
replace wcwm=1 if wcwm1==2
replace wcwm=1 if wcwm1==3
tab1 wcwm

gen wcbm=0
replace wcbm=1 if wcbm1==1
replace wcbm=1 if wcbm1==2
replace wcbm=1 if wcbm1==3
tab1 wcbm

gen bcbm=0
replace bcbm=1 if bcbm1==1
replace bcbm=1 if bcbm1==2
replace bcbm=1 if bcbm1==3
tab1 bcbm

gen bcwm=0
replace bcwm=1 if bcwm1==1
replace bcwm=1 if bcwm1==2
replace bcwm=1 if bcwm1==3
tab1 bcwm

gen control=0
replace control=1 if  control_att ==1
replace control=1 if  control_att ==0
tab control


mean age if bcbm==1 & dq==0
mean age if control==1 & dq==0
mean age if bcwm==1 & dq==0
mean age if wcbm==1 & dq==0
mean age if wcwm==1 & dq==0


mean pid if bcbm==1 & dq==0
mean pid if control==1 & dq==0
mean pid if bcwm==1 & dq==0
mean pid if wcbm==1 & dq==0
mean pid if wcwm==1 & dq==0


//For Raw Data, Higher Values == LESS electoral fraud. 
//I know its weird. Extremely is the first option in qualtrics.

mean dv1 if  control==1 & dq==0		//3.34
mean dv1 if  wcwm==1  & dq==0	//3.28
mean dv1 if  bcbm==1  & dq==0	//2.77
mean dv1 if  bcwm==1  & dq==0	//3.20
mean dv1 if  wcbm==1  & dq==0	//3.06


mean dv2 if  control==1 & dq==0		//3.45
mean dv2 if  wcwm==1  & dq==0	//3.28
mean dv2 if  bcbm==1  & dq==0	//2.93
mean dv2 if  bcwm==1  & dq==0	//3.04
mean dv2 if  wcbm==1  & dq==0	//3

oneway dv2 con  ,tabulate
oneway dv2 con if dq==0  ,tabulate

 
oneway dv1 con  ,tabulate
oneway dv1 con if dq==0, tabulate //interactive effect seems real.


//ttests
ttest dv1 if dq==0, by(bcbm)
ttest dv2 if dq==0, by(bcbm)
ttest dv1, by(bcbm) //this one is sig even with all the noise.
ttest dv2, by(bcbm)
* Seems promizing, but this is a pretty easy test and the N is still a bit low.
* Value of bcbm decreases when DQs removed. I would think that they should INCRESE since there were alot of 
*  low value straightliners. Doublw chwck this. If everything is correct, this is good for H1.

//Making BCBM Vs.CONTROL indicator
gen bcbm_control=.
replace bcbm_control=1 if bcbm==1
replace bcbm_control=0 if control==1
tab1 bcbm_control


ttest dv1, by(bcbm_control) //sig
ttest dv2, by(bcbm_control) // sig
ttest dv1 if dq==0, by(bcbm_control) //sig
ttest dv2 if dq==0, by(bcbm_control) //sig



//

ttest dv1, by(wcwm)
ttest dv2, by(wcwm)
ttest dv1 if dq==0, by(wcwm)
ttest dv2 if dq==0, by(wcwm) //I assume that it will be a LOWER relative value when just compared to control

//Making WCWM Vs.CONTROL indicator
gen wcwm_control=.
replace wcwm_control=1 if wcwm==1
replace wcwm_control=0 if control==1

ttest dv1, by(wcwm_control) //not sig
ttest dv2, by(wcwm_control)  //not sig
ttest dv1 if dq==0, by(wcwm_control)  //not sig
ttest dv2 if dq==0, by(wcwm_control)  //not sig

//Making General Condition Variable
gen con=.
replace con =1 if control==1
replace con =2 if bcbm == 1
replace con =3 if bcwm ==1
replace con =4 if wcbm ==1
replace con =5 if wcwm ==1
tab1 con
tab con if dq==0 //good same proportions. Seems DQ was fairly even across conditions.

tab2 con dv2


gen bm=0
replace bm=1 if con==2
replace bm=1 if con==4
tab1 bm

gen bc=0
replace bc=1 if con==2
replace bc=1 if con==3
tab1 bc

gen wm=0
replace wm=1 if con==3
replace wm=1 if con==5
tab1 wm

gen wc=0
replace wc=1 if con==4
replace wc=1 if con==5
tab1 wc

mean dv1
mean dv1 if control==1 & dq==0
mean dv1 if wc==1 & dq==0
mean dv1 if wm==1 & dq==0
mean dv1 if bm==1 & dq==0
mean dv1 if bc==1 & dq==0

//making BC vs. Control
gen bm_control=.
replace bm_control=1 if bm==1
replace bm_control=0 if control==1
tab1 bm_control

gen bc_control=.
replace bc_control=1 if bc==1
replace bc_control=0 if control==1
tab1 bc_control

//BC vs. Control
ttest dv1, by(bc_control) //not sig
ttest dv2, by(bc_control) //sig
ttest dv1 if dq==0, by(bc_control) //sig
ttest dv2 if dq==0, by(bc_control) // sig


//BM vs. Control
ttest dv1, by(bm_control) //sig
ttest dv2, by(bm_control) //sig
ttest dv1 if dq==0, by (bm_control) //sig
ttest dv2 if dq==0, by(bm_control) //sig


//Making WC vs Control and WM vs Control indicators.
gen wm_control=.
replace wm_control=1 if wm==1
replace wm_control=0 if control==1
tab1 wm_control

gen wc_control=.
replace wc_control=1 if wc==1
replace wc_control=0 if control==1
tab1 wc_control


//WC vs. Control
ttest dv1, by (wc_control) //not sig
ttest dv2, by (wc_control) //sig
ttest dv1 if dq==0, by (wc_control) //not sig
ttest dv2 if dq==0, by (wc_control) //sig

//WM vs. Control
ttest dv1, by (wm_control) //not sig
ttest dv2, by (wm_control) //sig
ttest dv1 if dq==0, by (wm_control) //not sig
ttest dv2 if dq==0, by(wm_control) //sig



//Making WM Vs.BM indicator
gen bm_wm=.
replace bm_wm=1 if bm==1
replace bm_wm=0 if wm==1
tab1 bm_wm

//WM vs BM
ttest dv1, by (bm_wm) //sig
ttest dv2, by(bm_wm) //not sig
ttest dv1 if dq==0, by (bm_wm) //sig
ttest dv2 if dq==0, by(bm_wm) //barely sig

//Making WC Vs.BC indicator
gen bc_wc=.
replace bc_wc=1 if bc==1
replace bc_wc=0 if wc==1
tab1 bc_wc

//WC vs BC
ttest dv1, by (bc_wc) //not sig
ttest dv2, by (bc_wc) //not sig
ttest dv1 if dq==0, by (bc_wc) //marginally sig
ttest dv2 if dq==0, by (bc_wc) //not sig

//Both
ttest dv1, by (bcbm_wcwm) //marginally sig
ttest dv2, by (bcbm_wcwm) //not sig
ttest dv1 if dq==0, by (bcbm_wcwm) //sig
ttest dv2 if dq==0, by (bcbm_wcwm) //sig



gen bcbm_wcwm=.
replace bcbm_wcwm=1 if bcbm==1
replace bcbm_wcwm=0 if wcwm==1
tab1 bcbm_wcwm


// control vs WM vs. BM
gen control_wm_bm=.
replace control_wm_bm=1 if control==1
replace control_wm_bm=2 if wm==1
replace control_wm_bm=3 if bm==1
tab1 control_wm_bm

// control vs WC vs. BC
gen control_wc_bc=.
replace control_wc_bc=1 if control==1
replace control_wc_bc=2 if wc==1
replace control_wc_bc=3 if bc==1
tab1 control_wc_bc


// control vs WCWM vs. BCBM
gen control_wcwm_bcbm=.
replace control_wcwm_bcbm=1 if control==1
replace control_wcwm_bcbm=2 if wcwm==1
replace control_wcwm_bcbm=3 if bcbm==1
tab1 control_wcwm_bcbm





//Thoughts about Testing

//Equal variances assumption seems to hold,
//Group size about the same.



//Labeling Variables/Values

label define control_wcwm_bcbm 1 "Control" 2 "White City/White Official" 3 "Black City/Black Official"



label define control_wcwm_bcbml 1 "Control" 2 "White City/White Official" 3 "Black City/Black Official"

label values control_wcwm_bcbm control_wcwm_bcbml
tab control_wcwm_bcbm
label var control_wcwm_bcbm "Comparing Across Conditions"



//generate recodes of main DVs. Currently higher values are LESS percieved electoal fraud
gen dv1_flipped=.
replace dv1_flipped=1 if dv1==5
replace dv1_flipped=2 if dv1==4
replace dv1_flipped=3 if dv1==3
replace dv1_flipped=4 if dv1==2
replace dv1_flipped=5 if dv1==1
tab1 dv1_flipped

gen dv2_flipped=.
replace dv2_flipped=1 if dv2==5
replace dv2_flipped=2 if dv2==4
replace dv2_flipped=3 if dv2==3
replace dv2_flipped=4 if dv2==2
replace dv2_flipped=5 if dv2==1
tab1 dv2_flipped

//this seems high. what about with DQ?
tab1 dv1_flipped if dq==0
tab1 dv2_flipped  if dq==0


 reg dv1_flipped bcbm if dq==0
 
  reg dv2_flipped bcbm if dq==0




//control vs story
gen control_treat=.
replace control_treat=0 if con ==1
replace control_treat=1 if con ==2
replace control_treat=1 if con ==3
replace control_treat=1 if con ==4
replace control_treat=1 if con ==5
tab1 control_treat

//Mere information effects
ttest dv1, by(control_treat) //not sig
ttest dv2, by(control_treat) //sig
ttest dv1 if dq==0, by(control_treat) //sig
ttest dv2 if dq==0, by(control_treat) //sig

//Mayor effects
ttest dv1, by(bm_wm) //sig
ttest dv2, by(bm_wm) //not sig
ttest dv1 if dq==0, by(bm_wm) //sig
ttest dv2 if dq==0, by(bm_wm) //sig

//city effects
ttest dv1, by(bc_wc) // not sig
ttest dv2, by(bc_wc) //not sig
ttest dv1 if dq==0, by(bc_wc) // marginal sig
ttest dv2 if dq==0, by(bc_wc) // not sig

ttest dv1, by(control_wc_bc) // not sig
ttest dv2, by(control_wc_bc) //not sig
ttest dv1 if dq==0, by(control_wc_bc) // marginal sig
ttest dv2 if dq==0, by(control_wc_bc) // not sig

//one way ANOVA, control, pooled WC and pooled BC
 oneway dv1 control_wc_bc, bonferroni
 oneway dv2 control_wc_bc, bonferroni
 oneway dv1 control_wc_bc if dq==0, tabulate
 oneway dv2 control_wc_bc if dq==0, tabulate
 
 
 //one way ANOVA, control, pooled WM and pooled BM
 oneway dv1 control_wm_bm, bonferroni tabulate
 oneway dv2 control_wm_bm, bonferroni tabulate
 oneway dv1 control_wm_bm if dq==0, bonferroni tabulate
 oneway dv2 control_wm_bm if dq==0, bonferroni tabulate
 
  //one way ANOVA, control, WCWM and BCBM
 oneway dv1 control_wcwm_bcbm, bonferroni tabulate
  oneway dv1 control_wcwm_bcbm if dq==0, bonferroni tabulate
 oneway dv2 control_wcwm_bcbm, bonferroni tabulate
  oneway dv2 control_wcwm_bcbm if dq==0, bonferroni tabulate







//ttests
ttest dv1 if dq==0, by(bcbm)
ttest dv2 if dq==0, by(bcbm)
ttest dv1, by(bcbm) //this one is sig even with all the noise.
ttest dv2, by(bcbm)




gen city=.
replace city=0 if wcwm ==1
replace city=0 if wcbm ==1
replace city=1 if bcbm==1
replace city=1 if bcwm==1
tab city

gen mayor=.
replace mayor=0 if wcwm ==1
replace mayor=0 if bcwm ==1
replace mayor=1 if bcbm ==1
replace mayor=1 if wcbm ==1
tab mayor


anova dv1 city##mayor
anova dv1 city##mayor if dq==0

anova dv2 city##mayor
anova dv2 city##mayor if dq==0


sdtest interest , by(type)

*Normal Distribution of DV
histogram dv1_flipped if dq==0, normal
histogram dv2_flipped if dq==0, normal

qnorm dv1_flipped
qnorm dv2_flipped


sfrancia interest
sktest interest //cannot reject null of normality



histogram dv1_flipped if con==1, normal

histogram dv1_flipped if con==2, normal

histogram dv1_flipped if con==3, normal

histogram dv1_flipped if con==4, normal

histogram dv1_flipped if con==5, normal



