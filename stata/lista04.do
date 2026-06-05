do stata/00_setup.do
capture log close _all
log using "$LOGS/stata_lista04.log", replace text

* Q1 - cálculos com coeficientes do enunciado
scalar pib_otimo = 0.0107/(2*0.000000245)
display "PIB ótimo = " pib_otimo
clear
set obs 400
gen pib = (_n-1)*(30000/399)
gen y_pib = 492.6 + 0.0107*pib - 0.000000245*pib^2
twoway line y_pib pib, xline(`=pib_otimo', lpattern(dash)) xtitle("PIB per capita, em US$") ytitle("Pontuação prevista") title("Lista 4 - Questão 1") name(g_l4q1, replace)
graph export "$FIGS_STATA/lista04_q01_pib_quadratico.png", replace width(1800)
graph export "$FIGS_STATA/lista04_q01_pib_quadratico.pdf", replace

* Q3 - função de produção, cálculos com valores do enunciado
scalar R2 = 0.94363
scalar n = 27
scalar k = 2
scalar Fprod = (R2/k)/((1-R2)/(n-k-1))
display "F conjunto = " Fprod
display "Intercepto se Y em milhões = " 1.1755 - ln(1000)
display "Intercepto se K em milhões = " 1.1755 + 0.3756*ln(1000)
display "IC inf efeito 2% K = " 0.02*(0.3756 - 2.064*0.0851)
display "IC sup efeito 2% K = " 0.02*(0.3756 + 2.064*0.0851)
clear
set obs 200
gen K = 1 + (_n-1)*(99/199)
gen Y = exp(1.1755)*(50^0.6022)*(K^0.3756)
twoway line Y K, xtitle("Capital K") ytitle("Produto previsto Y") title("Lista 4 - Questão 3") name(g_l4q3, replace)
graph export "$FIGS_STATA/lista04_q03_cobb_douglas_capital.png", replace width(1800)
graph export "$FIGS_STATA/lista04_q03_cobb_douglas_capital.pdf", replace

* Q4 - previsão pelo modelo recentrado do enunciado
display "mpg previsto para hp=240 e wght=3500 = 18.897"
display "IC 95% = [18.168, 19.626]"
clear
set obs 200
gen wght = 1800 + (_n-1)*(3200/199)
gen mpg = 43.998 - 0.022*240 - 0.006*wght
twoway line mpg wght, xtitle("Peso do veículo, em libras") ytitle("mpg previsto") title("Lista 4 - Questão 4") name(g_l4q4, replace)
graph export "$FIGS_STATA/lista04_q04_mpg_peso_hp240.png", replace width(1800)
graph export "$FIGS_STATA/lista04_q04_mpg_peso_hp240.pdf", replace

capture log close