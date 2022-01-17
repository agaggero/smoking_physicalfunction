
clear
use full_data
 
*===============================================================================
* Outcome
*===============================================================================


* Mobility
sum mobil
lab var mobil "Mobility Index [0,10]"

 
 
sum adlcount
lab var adlcount "ADL Index[0,6]"




gen age2=age*age













 
*===============================================================================
* Main regressor
*===============================================================================
* Whether current Smoker
tab smoker
lab var smoker "Smoker [0,1]"

gen D=(smoker==1)

 tab ever_smoker
lab var ever_smoker "Ever Smoker [0,1]"



replace cigs=0 if cigs==.

gen reg_smoker =(cigs>=10)
lab var reg_smoker "Regular Smoker [0,1]"



 




*===============================================================================
* Instrumental Variable  - Polygenic Score
*===============================================================================


gen z_var = SMK_EVER
lab var z_var "Polygenic Score"

su z_var

  


egen mean_z	  =	mean(z_var)
egen sd_z	  =	sd(z_var)
gen z =	(z_var - mean_z)/sd_z
label var z "Smoking Polygenic Score"
drop mean_z sd_z



 
 

 


gen zsq=z*z
 
  
 
  
 
 
 
 
 
 
 
  
  
  
  
   
 
   
*-------------------------------------------------------------------------------
* Labels for LaTeX Tables
*-------------------------------------------------------------------------------
lab var age    "Years of Age"
lab var age2    "Years of Age Sq."
lab var female "Female [0,1]"
lab var married "Married [0,1]"
lab var famsize "Family  Size"
lab var lhhinc  "Log HH Income"
lab var employed "Employed [0,1]"
lab var smoker "Smoker [0,1]"
lab var drinker "Drinker"
lab var sedentary "Sedendary"

*foreach v of varlist * {
*	label variable `v' `"\hspace{0.2cm} `: variable label `v''"'
*	}

 
 
 
  
 
*===============================================================================
* Summary Statistics
*===============================================================================
global x   mobil adl   smoker ever reg_smoker cigs z age female married famsize  drinker sedentary hedu  lhhinc employed 







*===============================================================================
* TABLE 1
*===============================================================================
 
 
 
   
estpost su         $x        

  
  
  
 
 
*===============================================================================  
*                                        Regression Analysis
*===============================================================================
 keep if age!=. | female!=. |  married!=. |  famsize!=. | drinker !=. | sedentary !=. |  hedu !=. | lhhinc !=. | employed !=. 
 keep if pc1!=. | pc2!=. | pc3!=. | pc4!=. | pc5!=. | pc6!=. | pc7!=. | pc8!=. | pc9!=. | pc10!=. 

 
 
   
 
 
 
 
 
 
 
 
 
 
 
 
 
*===============================================================================
*                           TABLE 2
*===============================================================================

  
 
 
* Globals 

global t smoker
global z z
global keep age age2 female  married  famsize hedu lhhinc employed
global robust vce(robust)

global x1
global x2 $x1 age age2 female  married  famsize  drinker sedentary hedu  lhhinc employed 
global x3 $x2 i.t i.region 
global x4 $x3 pc1-pc10

 
ivregress 2sls mobil   ($t = $z) $x2 , $robust  

ivregress 2sls mobil   ($t = $z) $x4  , $robust  

ivregress 2sls adl     ($t = $z) $x2  , $robust  
 
ivregress 2sls adl     ($t = $z) $x4  , $robust  
  
  
 
 
 
  
 
 
 
 
 
   estat endog

 
   
 
  
 

  
 
 
 
*=============================================================================
*                          TABLE 3
*=============================================================================


 

* Other outcomes that are, potentially, correlated with (early) retirement. 

 
ivregress 2sls casp19      $z $x4   , $robust  
 
ivregress 2sls   totcesd     $z $x4   , $robust 
  
ivregress 2sls cfme   $z $x4   , $robust  
 
ivregress 2sls cfanig      $z $x4   , $robust  
 


global x1
global x2 $x1 age age2 female  married  famsize   hedu    lhhinc employed 
global x3 $x2 i.t i.region 
global x4 $x3 pc1-pc10

ivregress 2sls drinker     $z $x4   , $robust  
 
 
  

 
