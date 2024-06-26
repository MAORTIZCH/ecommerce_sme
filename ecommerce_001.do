*E-commerce of Peruvian SMEs: determinants of internet sales before and during Covid-19

*Miguel Angel Ortiz Chávez (maortiz@pucp.edu.pe)

*PARTE I - Creación de variables

global base "D:\MIGUEL\Proyectos\comercio electrónico\Base"
	global origin "$base\original"
	global final "$base\trabajado"

** ENE 2019 - creación de variables
*Base original obtenida del Ministerio de la Producción: https://ogeiee.produce.gob.pe/index.php/en/k2/censos/ene-2015

use "$origin\ENE2019", clear


**Variables dependientes 

*Ventas por internet
recode P424_1_1 (1=1 "Realiza ventas por internet") (2=0 "No realiza ventas por internet"), g(ecommerce)
label var ecommerce "Realiza ventas por internet 2019"

*Incremento de ventas por internet
recode P427_1_1 (1=1 "Se incrementaron") (2/4=0 "Otro"), g(y_ventas)
label var y_ventas "Percepción de ventas por internet 2020"


**Variables independientes

*Tamaño
clonevar tamano=COD_VENTAS
label var tamano "Tamaño de la empresa 2019"

*intensidad de ventas
clonevar p_ecommerce=P425_1_1
replace p_ecommerce=0.5 if P425_1_2==1
label var p_ecommerce "Porcentaje de ventas mediante ventas por internet 2019"

*alcance de ventas
recode P426_1_1 (1=1 "mercado local") (2/3=0 "Otros departamentos/paises"), g(alc_ecommerce)
label var alc_ecommerce "Mayor alcance de ventas por internet 2019"

*número de trabajadores
clonevar num_trab=C3P301_TOTAL113
label var num_trab "Número de trabajadores 2019" //Ojo: también hay datos de trabajadores 2020
replace num_trab=num_trab+1

gen num_trab20=C3P301_TOTAL213+1
label var num_trab20 "Número de trabajadores 2020" 

gen diftrab=num_trab20-num_trab
label var diftrab "Diferencia de trabajadores 2020-2019"

*región/ubicación geográfica
destring CCDD, g(depar)

label define departamento ///
1 "Amazonas" ///
2 "Áncash" ///
3 "Apurímac" ///
4 "Arequipa" ///
5 "Ayacucho" ///
6 "Cajamarca" ///
7 "Callao" ///
8 "Cusco" ///
9 "Huancavelica" ///
10 "Huánuco" ///
11 "Ica" ///
12 "Junín" ///
13 "La Libertad" ///
14 "Lambayeque" ///
15 "Lima" ///
16 "Loreto" ///
17 "Madre de Dios" ///
18 "Moquegua" ///
19 "Pasco" ///
20 "Piura" ///
21 "Puno" ///
22 "San Martín" ///
23 "Tacna" ///
24 "Tumbes" ///
25 "Ucayali"

label values depar departamento

gen lima=(depar==15)
label var lima "Empresas ubicadas en Lima"

gen x1=substr(CCDI,3,2)
gen capdepa=(x1=="01")
label var capdepa "Ubicado en una capital de departamento"
drop x1

recode depar (3 4 5 8 18 21 23=1 "Sur") (9 10 11 12 19=2 "Centro") (2 6 13 14 20 24=3 "Norte") (1 16 17 22 25=4 "Oriente") (7 15=5 "Lima"), g(macroregiones)

label var macroregiones "Macrorregión donde se ubica la empresa"

*actividad económica
gen ciiu=real(substr(CODCLASE,1,2))
replace ciiu=real(substr(CODCLASE_B,1,2)) if ACTIVIDAD_ECO_A==2
recode ciiu (1/9=1 "sector primario") (10/33=2 "Industria manufacturera") (45/47=3 "Comercio") (else=4 "servicios"), g(sector)

recode ciiu (1/9=1 "Sector primario") (10/33=2 "Industria manufacturera") (45/47=3 "Comercio") (55/56=4 "Restaurantes y hoteles") (41/43=5 "Construcción") (else=6 "Servicios"), g(sector2)

label var sector "Sector económico"

*actividades escenciales
gen ciiu4=real(CODCLASE)
recode ciiu4 (111/322 610 620 910 1010/1104 2825 2100 3510/3900 4772 4630 4661 4711 4721 4722 4730 4781 6010 6020 6110/6190 6444/6630 8411/8430 8610/8890 9603=1 "Esenciales") (else=0 "No esenciales"), g(esencial)

label var esencial "Actividades declaradas esenciales por el gobierno"

*grado de internacionalización
gen exporta=(P610_1_1==1)
label var exporta "Realizó exportaciones en 2019"

*antiguedad
gen antiguedad=2020-ANIO_INICIO
label var antiguedad "Años desde que inicio actividades"

*esperiencia del conductor
gen cond_exper=2020-CONDUCTOR_ANIO
replace cond_exper=antiguedad if cond_exper==.
label var cond_exper "Años de experiencia del conductor"

*educación
recode CONDUCTOR_NIVELED (1/6=0 "Básico") (7/11=1 "Superior"), g(cond_educ)
recode CONDUCTOR_NIVELED (1/7=0 "Básico") (8/11=1 "Superior"), g(cond_educ2)
label var cond_educ "Nivel educativo del conductor de la empresa"

*sexo
gen cond_sex=(CONDUCTOR_SEXO==1)
label var cond_sex "Sexo del conductor de la empresa"

gen tej19=C3P301_TOTAL101+1
gen tej_fem19=C3P301_M101
replace tej_fem19=C3P301_M101+1 if cond_sex==0
gen pej_fem19=(tej_fem19/tej19)*100

label var pej_fem19 "Porcentaje de ejecutivos y conductores mujeres 2019"

*Competitividad
gen compf=(P108_1_1==1)
label var compf "Incremento de la competencia formal 2019"
gen compi=(P109_1_1==1)
label var compi "Incremento de la competencia informal 2020"

*Digitalizacion
gen digproc=(P110_1_1==1)
label var digproc "Digitalización de los procesos productivos 2020"
gen estrat=(P110_1_2==1)
label var estrat "Estrategia de herramientas digitales 2020"
gen capa_dig=(C3P305_3==1)
label var capa_dig "Personal capacitado en herramientas digitales 2019"
gen compras=(P405_1_1==1)
label var compras "Realizó compras por internet 2019"
gen promdig=(P420_1_10==1 | P420_1_11==1 | P420_1_12==1 | P420_1_13==1) 
label var promdig "Uso de medios digitales para promoción de productos 2019"
gen bill=(P428_1_3==1)
label var bill "Uso de billetera electrónica 2020"
gen servtec=(P439_1_1==1) 
label var servtec "Uso de servicios tecnológicos 2019"

*Capacitación y AT
gen at_cym=(P308_1_9==1)
label var at_cym "AT en comercialización y marketing 2019"

gen ncap_dig=(P309_1_5==1 | P309_1_6)
label var ncap_dig "Necesidades de capacitación en herramientas digitales e e-commerce"

*ubicación de local 
gen vivienda=(P201_1_3==1) 
label var vivienda "local ubicado en vivienda 2019"

*Uso de TIC
gen computadora=(C5P501_1==1 | C5P501_2==1 | C5P501_3==1) 
label var computadora "Uso de compuadora 2019"
gen tic_ventas=(P503_1_2==1) 
label var tic_ventas "Uso de sistemas informatizados para ventas 2020"
gen tic_finanzas=(P503_1_5==1) 
label var tic_finanzas "Uso de sistemas informatizados para finanzas 2020"
gen tic_logistica=(P503_1_6==1)
label var tic_logistica "Uso de sistemas informatizados para logistica 2020"

recode C5P501_7 (1=1 "Sí") (2=0 "No"), g(smartph)
label var smartph "Teléfono móvil con acceso a internet (Smart phone)?"

gen internet=(P502_1_1!=4)
label var internet "Acceso a internet"

gen platformdig=(P504_1_1==1)
label var platformdig "Plataforma digital para concretar ventas 2020"
gen redessoc=(P505_1_6==1)
label var redessoc "Redes sociales para venta 2020"

gen pweb=(PAGINAWEB_SN==1)
label var pweb "Tiene página web"

gen email=(EMAIL_SN==1)
label var email "Tiene e-mail"

*Transporte
gen transport=(P604_1_1==1) 
label var transport "Cuenta con vehiculo propio 2020"

gen delivery=(P110_1_5==1)
label var delivery "Estrategia de delivery 2020"

*Financiemiento
gen financ=(C7P701_D01==1 | C7P701_D02==1) 
label var financ "Financiamiento 2019"

*ingresos-egresos
gen ingneto=C8P804_MONTO07-C8P805_MONTO27
gen lingneto=ln(ingneto)
replace lingneto=0 if lingneto==.

gen lingtot=ln(C8P804_MONTO07)

*Alternativo: productividad laboral
egen ventas=rowtotal(C8P804_MONTO01 C8P804_MONTO04 C8P804_MONTO05)
egen consint=rowtotal(C8P805_MONTO01 C8P805_MONTO09)
replace ventas=1 if ventas==0

gen ventrab=ventas/num_trab

gen valagr=ventas-consint
replace valagr=1 if valagr<1
gen prodlab=valagr/num_trab

gen lventas=ln(ventas)
gen lva=ln(valagr)
gen lpl=ln(prodlab)
gen lvt=ln(ventrab)
gen ltrab=ln(num_trab)
replace lpl=0 if lpl==.

gen estrato=(FACTOR==1)

tab sector2, gen(sect2) 
tab tamano, g(tam)

recode COD_VENTAS (1/3=1 "SME") (4=0 "No SME"), g(sme)
replace sme=0 if sme==1 & num_trab>100

*Participación de mercado
bysort macroregiones ciiu: egen ventas_sector=total(ventas)
label var ventas_sector "Ventas del sector por departamento (CIIU 2 digitos) 2019"
g cuota=(ventas/ventas_sector)
label var cuota "Cuota de mercado 2019"

*Concentración-HHI
bysort macroregiones ciiu: egen hhi=total(cuota^2)
lab var hhi "Índice de Herfindhal Hirschman HHI"

recode hhi (0/0.0999=1 "Industria diversificada") (0.1/0.18=2 "Concentración moderada") (0.1801/1=3 "Industria concentrada"), gen(concent)
label var concent "Concentración de la industria"

*Solo mercado local
gen mlocal=(P106_1_3==1 & P106_1_1==2 & P106_1_2==2)
label var mlocal "Solo vende al mercado local"

drop ciiu ciiu4 tej19 tej_fem19
compress

save "$final/ENE19", replace
*****************************************************
