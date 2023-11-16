*E-commerce of Peruvian SMEs: determinants of internet sales before and during Covid-19
*Miguel Angel Ortiz Chávez (maortiz@pucp.edu.pe)

*PARTE II - Datos de contexto

global base "D:\MIGUEL\Proyectos\comercio electrónico\Base"
	global origin "$base\original"
	global final "$base\trabajado"
	
*BASE ENCUESTA A EMPRESAS COVID 19

use "$origin\a2020_COVID19", clear

tab P_4_1 [iw= FACTOR]
tab P_4_2 if P_4_1!=3 [iw= FACTOR]

*Serie ENE (Se uniformiza a empresas con ventas mayores a 50 UIT en el año de referencia)
* micro<150 UIT; pequeña 150<x<1700; mediana 1700<x<2300

*ENE 2015 (Desde 20 UIT)
use "$origin\ENE2015", clear
egen ventas=rowtotal(M9P4_1 M9P4_4 M9P4_5)

recode ventas (0/190000=0 "Menos de 50 UIT") (190000.1/8740000=1 "más de 50 UIT a 2300 UIT") (8740000.1/max=2 "Más de 2300 UIT"), g(selec) //UIT 2014==3800

gen sme=(C20==1 | C20==2)
replace sme=0 if selec==0 & C20==1
replace sme=1 if selec==1 & sme==0 & C20==3
replace sme=0  if M3P1_6A>100

*compras por internet
svyset [pw=Factor_exp], strata(SELECC_MUESTRAL)

svy, subpop(if sme==1): tab M4P17, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion M4P17

*ventas por internet
svy, subpop(if sme==1): tab M4P53, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion M4P53

*tipos de ventas
forvalues i=1/5 {
	svy, subpop(if sme==1 & M4P53==1): proportion M4P55_`i'
}

*ENE 2016 (Desde 20 UIT)
use "$origin\ENE2016", clear
egen ventas=rowtotal(M9P004_1 M9P004_4 M9P004_5)
recode ventas (0/192500=0 "Menos de 50 UIT") (192500.1/max=1 "más de 50 UIT"), g(selec) //UIT 2015==3850

gen sme=(P15==1 | P15==2 | P15==3)
replace sme=0 if selec==0 & P15==1
replace sme=0  if M3P001A_T1>100

svyset [pw=FACTOR_EXPANS], strata(ESTRATO_FORZOSO)

*compras por internet
svy, subpop(if sme==1): tab M4P017, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion M4P017

*ventas por internet
svy, subpop(if sme==1): tab M4P056, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion M4P056

*tipos de ventas
forvalues i=1/5 {
	svy, subpop(if sme==1 & M4P056==1): proportion M4P058_`i'
}

*ENE 2017  (Desde 13 UIT)
use "$origin\ENE2017", clear

egen ventas=rowtotal(C9P904_1 C9P904_4 C9P904_5)
recode ventas (0/197500=0 "Menos de 50 UIT") (197500.1/max=1 "más de 50 UIT"), g(selec) //UIT 2016==3950

gen sme=(tamano_emp!=4)
replace sme=0 if selec==0 & tamano_emp==1
replace sme=0 if C3P301A_T1>100

svyset [pw=FACTOR_EXPANSION], strata(E_FORZOSO_CD)

*compras por internet
svy, subpop(if sme==1): tab C4P418, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion C4P418

*ventas por internet
svy, subpop(if sme==1): tab C4P456, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion C4P456

*tipos de ventas
forvalues i=1/5 {
	svy, subpop(if sme==1 & C4P456==1): proportion C4P458_`i'
}


*ENE 2018 (13 UIT)
use "$origin\ENE2018", clear

egen ventas=rowtotal(C9P912_1 C9P912_4 C9P912_5)
recode ventas (0/202500=0 "Menos de 50 UIT") (202500.1/max=1 "más de 50 UIT"), g(selec) //UIT 2017==4050
gen sme=(tamano_emp!=4)
replace sme=0 if selec==0 & tamano_emp==1
replace sme=0 if C3P301A_T1>100 & C3P301A_T1!=.

svyset [pw=FACTOR]
*compras por internet
svy, subpop(if sme==1): tab C4P418, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion C4P418

*ventas por internet
svy, subpop(if sme==1): tab C4P456, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion C4P456

*tipos de ventas
forvalues i=1/5 {
	svy, subpop(if sme==1 & C4P456==1): proportion C4P458_`i'
}


*ENE 2019
use "$final\ENE19", clear
recode COD_VENTAS (1/3=1 "Mipyme") (4=0 "No Mipyme"), g(sme)
replace sme=0 if sme==1 & C3P301_TOTAL113>100

svyset [pw=FACTOR], strata(estrato)

*compras por internet
svy, subpop(if sme==1): tab P405_1_1, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion P405_1_1

*ventas por internet
svy, subpop(if sme==1): tab P424_1_1, cv percent format (%2.1f) col
svy, subpop(if sme==1): proportion P424_1_1

*tipos de ventas
forvalues i=1/6 {
	svy, subpop(if sme==1 & P424_1_1==1): proportion P428_1_`i'
}

***Incremento del comercio electrónico
tab P502_1_1 [iw=FACTOR] if sme==1

**Compras
svy, subpop (if sme==1): tab P408_1_1, cv percent  format (%2.1f)
tab P408_1_1 [iw=FACTOR] if sme==1

gen p_compras=P406_1_1
replace p_compras=0.5 if P406_1_2==1
table sme [iw=FACTOR], c(mean p_compras) row
tab p_compras [iw=FACTOR] if sme==1
tab P407_1_1 [iw=FACTOR] if sme==1

tab P405_1_1 sector [iw=FACTOR] if sme==1, nofreq col

tab P409_1_3 [iw=FACTOR] if sme==1
tab P410_1_1 [iw=FACTOR] if sme==1

forvalues i=1/4 {
tab P411_1_`i' [iw=FACTOR] if sme==1
}

**ventas
tab P424_1_1 sector [iw=FACTOR] if sme==1, nofreq col

table sme [iw=FACTOR], c(mean p_ecommerce) row
tab p_ecommerce [iw=FACTOR] if sme==1

tab P426_1_1 [iw=FACTOR] if sme==1

tab P427_1_1 [iw=FACTOR] if sme==1

forvalues i=1/3 {
tab P429_1_`i' [iw=FACTOR] if sme==1
}

tab P431_1_1 [iw=FACTOR] if sme==1

forvalues i=1/4 {
tab P432_1_`i' [iw=FACTOR] if sme==1
}

*digitalización
tab P420_1_12 [iw=FACTOR] if sme==1
tab P420_1_13 [iw=FACTOR] if sme==1

tab P110_1_1 [iw=FACTOR] if sme==1
tab P110_1_2 [iw=FACTOR] if sme==1 

**********************************************