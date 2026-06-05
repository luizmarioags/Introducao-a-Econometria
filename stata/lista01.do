do stata/00_setup.do
capture log close _all
log using "$LOGS/stata_lista01.log", replace text

* Q1
clear
input familia despesas_habitacao
1 300
2 440
3 350
4 1100
5 640
6 480
7 450
8 700
9 670
10 530
end
summ despesas_habitacao, detail
graph bar despesas_habitacao, over(familia) ytitle("Despesas mensais com habitação, em US$") title("Lista 1 - Questão 1") name(g_l1q1, replace)
graph export "$FIGS_STATA/lista01_q01_despesas_habitacao.png", replace width(1800)
graph export "$FIGS_STATA/lista01_q01_despesas_habitacao.pdf", replace

gen despesas_centenas = despesas_habitacao/100
summ despesas_centenas, detail
replace despesas_habitacao = 900 if familia == 8
summ despesas_habitacao, detail

* Q3
clear
set obs 200
gen SAT = 400 + (_n-1)*(1200/199)
gen E_IRA = 0.70 + 0.002*SAT
twoway line E_IRA SAT, xtitle("SAT") ytitle("E(IRA | SAT)") title("Lista 1 - Questão 3") name(g_l1q3, replace)
graph export "$FIGS_STATA/lista01_q03_esperanca_condicional_ira_sat.png", replace width(1800)
graph export "$FIGS_STATA/lista01_q03_esperanca_condicional_ira_sat.pdf", replace

* Q7
clear
input estudante GPA ACT
1 2.8 21
2 3.4 24
3 3.0 26
4 3.5 27
5 3.6 29
6 3.0 25
7 2.7 25
8 3.7 30
end
reg GPA ACT
predict resid_gpa, resid
predict gpa_hat, xb
summ resid_gpa
display "Previsao ACT=20 = " _b[_cons] + 20*_b[ACT]
twoway (scatter GPA ACT) (lfit GPA ACT), xtitle("ACT") ytitle("GPA") title("Lista 1 - Questão 7") name(g_l1q7, replace)
graph export "$FIGS_STATA/lista01_q07_gpa_act_mqo.png", replace width(1800)
graph export "$FIGS_STATA/lista01_q07_gpa_act_mqo.pdf", replace

* Q11
clear
set obs 100
gen cigs = (_n-1)*(30/99)
gen peso = 119.77 - 0.514*cigs
twoway line peso cigs, xtitle("Cigarros por dia") ytitle("Peso previsto, em onças") title("Lista 1 - Questão 11") name(g_l1q11, replace)
graph export "$FIGS_STATA/lista01_q11_peso_cigarros.png", replace width(1800)
graph export "$FIGS_STATA/lista01_q11_peso_cigarros.pdf", replace

* Q15
clear
input obs x y
1 1 3
2 2 5
3 3 6
end
reg y x
predict yhat, xb
corr y yhat
display "R2 por correlacao^2 = " r(rho)^2
twoway (scatter y x) (line yhat x, sort), xtitle("x") ytitle("y") title("Lista 1 - Questão 15") name(g_l1q15, replace)
graph export "$FIGS_STATA/lista01_q15_observado_ajustado.png", replace width(1800)
graph export "$FIGS_STATA/lista01_q15_observado_ajustado.pdf", replace

capture log close