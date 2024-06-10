*E-commerce of Peruvian SMEs: determinants of internet sales before and during Covid-19
*Miguel Angel Ortiz Chávez (maortiz@pucp.edu.pe)

*PARTE III - Modelos econométricos
global base "D:\MIGUEL\ZMAOC\05 Proyectos\e-commerce"
	global origin "$base\original"
	global final "$base\trabajado"
	global tablas "$base\tablas"
	
*use "$final/ENE19", clear
use "D:\MIGUEL\ZMAOC\05 Proyectos\e-commerce\ENE19.dta", clear
drop CCDD CCPP-AE_LIT SECTOR_ECO-C8P805_MONTO27 ingneto-lvt
compress

*factorial de digitalización
global digit1 platformdig redessoc pweb promdig computadora smartph compras capa_dig ncap_dig servtec 

factor $digit1 if sme==1, pcf
rotate
estat kmo

factortest $digit1 if sme==1

predict factor1 factor2 factor3

*Etapa 1
global control1 ltrab cond_exper exporta compf hhi mlocal
global sector1 sect21 sect23 sect24 sect25 

asdoc pwcorr $control1 $sector1 factor1 factor2 factor3 if sme==1 [iw=FACTOR], sig star(.05) replace

probit ecommerce $control1 $sector1 factor1 factor2 factor3 if sme==1 [iw=FACTOR], vce(robust)  cformat(%6.3fc) sformat(%6.3fc) const
outreg2 using "$tablas\mod1_1", excel replace
predict xb1, xb
g imills=normalden(xb)/normal(xb)
vif, uncentered

margins if e(sample), dydx(*) post  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", ctitle(margins) excel 

probit ecommerce $control1 factor1 factor2 factor3 if sme==1 [iw=FACTOR], vce(robust)  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", excel
vif, uncentered

margins if e(sample), dydx(*) post  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", ctitle(margins) excel 

*Etapa 2
*Factorial etapa 2
global digit2 digproc estrat bill tic_ventas tic_finanzas tic_logistica internet

global control2 cond_exper exporta transport delivery hhi mlocal compi
global sector2 sect24 sect25 

factor $digit1 $digit2 if sme==1 & ecommerce==1, pcf factor(4)
rotate
estat kmo

factortest $digit1 $digit2 if sme==1 & ecommerce==1

predict fac1 fac2 fac3 fac4

probit y_ventas $control2 $sector2 fac2 fac3 fac4 imills if sme==1 [iw=FACTOR], vce(robust) cformat(%6.3fc) sformat(%6.3fc) const
outreg2 using "$tablas\mod1_1", excel
vif, uncentered

margins if e(sample), dydx(*) post  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", ctitle(margins) excel 

probit y_ventas $control2 fac2 fac3 fac4 imills if sme==1 [iw=FACTOR], vce(robust) cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", excel
vif, uncentered

margins if e(sample), dydx(*) post  cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod1_1", ctitle(margins) excel 

*Prueba F - digitalización
preserve
svyset [pw=FACTOR], strata(estrato)
svy: probit y_ventas $control2 fac2 fac3 fac4 imills if sme==1, cformat(%6.3fc) sformat(%6.3fc)

postutil clear
postfile table2 str12 variable F p_F using "$final\table2.dta", replace

local x fac2 fac3 fac4

foreach var in  `x' {
	test `var'
	local F=r(F)	
	local p_F=r(p)	

	post table2 ("`var'") (`F') (`p_F')
}

test fac2 fac3 fac4
	local F=r(F)	
	local p_F=r(p)	
post table2 ("digitalización") (`F') (`p_F')

postclose table2

use "$final\table2.dta", clear 
format p_F %6.3f
restore

*Prueba F - logistica/trust
preserve
svyset [pw=FACTOR], strata(estrato)

svy: probit y_ventas $control2 fac2 fac3 fac4 imills if sme==1, cformat(%6.3fc) sformat(%6.3fc)

postutil clear
postfile table3 str12 variable F p_F using "$final\table3.dta", replace

local x transport delivery

foreach var in  `x' {
	test `var'
	local F=r(F)	
	local p_F=r(p)	

	post table3 ("`var'") (`F') (`p_F')
}

test  transport delivery
	local F=r(F)	
	local p_F=r(p)	
post table3 ("logistica") (`F') (`p_F')

postclose table3

use "$final\table3.dta", clear 
format p_F %6.3f
restore

*Estadísticas descriptivas
use "$final/ENE19", clear

postutil clear
postfile table4 str12 variable d_mean d_sd d_min d_max n using "$tablas\table4.dta", replace

local x ecommerce $control1 $sector1 $digit1

foreach var in  `x' {
	sum `var' if sme==1 [iw=FACTOR]
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

***estadisticas descriptivas
use "$final/ENE19", clear

postutil clear
postfile table5 str12 variable d_mean d_sd d_min d_max n using "$tablas\table5.dta", replace

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

postclose table5

use "$tablas\table5.dta", clear 
format d_sd %6.3f

outsheet using "$tablas\table5.xls", replace


**Endogeneidad
keep if sme==1

*Probit simple
probit y_ventas $control2 $sector2 fac2 fac3 fac4 if sme==1 [iw=FACTOR], vce(robust) cformat(%6.3fc) sformat(%6.3fc) const
outreg2 using "$tablas\mod2_1", excel replace
vif, uncentered

*Heckman simultaneo
heckprobit  y_ventas $control2 $sector2 fac2 fac3 fac4 if sme==1 [iw=FACTOR], select(ecommerce = $control1 $sector1 factor1 factor2 factor3) vce(robust) cformat(%6.3fc) sformat(%6.3fc)
outreg2 using "$tablas\mod2_1", excel

*PSM
preserve
pscore transport $control1 $sector1 factor1 factor2 factor3 capdepa tic_ventas tic_finanzas tic_logistica financ, pscore(ps2) blockid(blockf1) comsup level(0.01)
psmatch2 transport if comsup==1, outcome(y_ventas) pscore(ps2) neighbor(1) noreplacement
restore

preserve
pscore delivery $control1 $sector1 factor1 factor2 factor3 capdepa tic_ventas tic_finanzas tic_logistica financ, pscore(ps2) blockid(blockf1) comsup level(0.01)
psmatch2 delivery if comsup==1, outcome(y_ventas) pscore(ps2) neighbor(1) noreplacement
restore
