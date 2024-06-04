*E-commerce of Peruvian SMEs: determinants of internet sales before and during Covid-19
*Miguel Angel Ortiz Chávez (maortiz@pucp.edu.pe)

*PARTE III - Modelos econométricos

******************
*****Modelo 1*****
******************

global base "D:\MIGUEL\Proyectos\comercio electrónico\Base"
	global origin "$base\original"
	global final "$base\trabajado"
	global tablas "$base\tablas"
	
use "$final/ENE19", clear
*Base original obtenida del Ministerio de la producción de Perú: https://ogeiee.produce.gob.pe/index.php/en/k2/censos/ene-2015

*factorial de digitalización
global digit1 platformdig redessoc pweb promdig computadora smartph compras capa_dig ncap_dig servtec

factor $digit1 if sme==1, pcf
rotate
estat kmo

factortest $digit1 if sme==1

predict factor1 factor2 factor3

*Etapa 1
global control1 ltrab cond_exper exporta compf hhi mlocal
global sector1 sect21 sect23 sect24 sect25 sect26  

asdoc pwcorr $control1 $sector1 factor1 factor2 factor3 if sme==1 [iw=FACTOR], sig star(.05) replace

probit ecommerce $control1 $sector1 factor1 factor2 factor3 if sme==1 [iw=FACTOR], vce(robust)  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", excel replace
predict xb1, xb
g imills=normalden(xb)/normal(xb)

margins if e(sample), dydx(*) post  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", ctitle(margins) excel 

probit ecommerce $control1 factor1 factor2 factor3 if sme==1 [iw=FACTOR], vce(robust)  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", excel
margins if e(sample), dydx(*) post  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", ctitle(margins) excel 

*Etapa 2
*Factorial etapa 2
global digit2 digproc estrat bill tic_ventas tic_finanzas tic_logistica internet
global control2 ltrab cond_exper exporta sect23 sect24 sect25 sect26 compi transport delivery hhi mlocal

factor $digit1 $digit2 if sme==1 & ecommerce==1, pcf factor(4)
rotate
estat kmo

factortest $digit1 $digit2 if sme==1 & ecommerce==1

predict fac1 fac2 fac3 fac4

probit y_ventas $control2 fac1 fac2 fac3 fac4 imills if sme==1 [iw=FACTOR], vce(robust) cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod2_1", excel replace
margins if e(sample), dydx(*) post  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod2_1", ctitle(margins) excel 

logit y_ventas $control2 fac1 fac2 fac3 fac4 imills if sme==1 [iw=FACTOR], vce(robust) cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod2_1", excel
margins if e(sample), dydx(*) post  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod2_1", ctitle(margins) excel 

logit y_ventas $control2 fac1 fac2 fac3 fac4 imills if sme==1 [iw=FACTOR], vce(robust) or cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod2_1", eform ctitle(odds ratio) excel

asdoc pwcorr $control2 fac1 fac2 fac3 fac4 imills if sme==1 & ecommerce==1 [iw=FACTOR], sig star(.05) replace

save "$final/ENE19", replace

*Prueba F
svyset [pw=FACTOR], strata(estrato)
svy: logit y_ventas $control2 fac1 fac2 fac3 fac4 imills if sme==1, cformat(%6.3fc) sformat(%6.3fc)

postutil clear
postfile table2 str12 variable F p_F using "$final\table2.dta", replace

local x fac1 fac2 fac3 fac4

foreach var in  `x' {
	test `var'
	local F=r(F)	
	local p_F=r(p)	

	post table2 ("`var'") (`F') (`p_F')
}

test fac1 fac2 fac3 fac4
	local F=r(F)	
	local p_F=r(p)	
post table2 ("digitalización") (`F') (`p_F')

postclose table2

use "$final\table2.dta", clear 
format p_F %6.3f

*Estadísticas descriptivas
use "$final/ENE19", clear

postutil clear
postfile table3 str12 variable d_mean d_sd d_min d_max n using "$tablas\table3.dta", replace

local x ecommerce $control1 $sector1 $digit1

foreach var in  `x' {
	sum `var' if sme==1 [iw=FACTOR]
		local d_mean=r(mean)	
		local d_sd=r(sd)
		local d_min=r(min)
		local d_max=r(max)
		local n = r(N)

post table3 ("`var'") (`d_mean') (`d_sd') (`d_min') (`d_max') (`n') 
}

postclose table3

use "$tablas\table3.dta", clear 
format d_sd %6.3f

outsheet using "$tablas\table3.xls", replace

***estadisticas descriptivas
use "$final/ENE19", clear

postutil clear
postfile table4 str12 variable d_mean d_sd d_min d_max n using "$tablas\table4.dta", replace

local x y_ventas $control2 $digit2 $digit1

foreach var in  `x' {
	sum `var' if sme==1 & ecommerce==1 [iw=FACTOR]
		local d_mean=r(mean)	
		local d_sd=r(sd)
		local d_min=r(min)
		local d_max=r(max)
		local n = r(N)

post table4 ("`var'") (`d_mean') (`d_sd') (`d_min') (`d_max') (`n') 
}

postclose table4

use "$tablas\table4.dta", clear 
format d_sd %6.3f

outsheet using "$tablas\table4.xls", replace
