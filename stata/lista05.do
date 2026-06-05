do stata/00_setup.do
capture log close _all
log using "$LOGS/stata_lista05.log", replace text

* Q2 - se a base municipal tiver sido fornecida
capture confirm file "$DATA/municipios_lista05.csv"
if !_rc {
    import delimited "$DATA/municipios_lista05.csv", clear
    regress pobreza no ne su co pibpc escol c.escol#c.no c.escol#c.ne c.escol#c.su c.escol#c.co
    predict pobreza_hat, xb
    twoway (scatter pobreza_hat pobreza) (function y=x, range(pobreza)), xtitle("Pobreza observada") ytitle("Pobreza ajustada") title("Lista 5 - Questão 2") name(g_l5q2, replace)
    graph export "$FIGS_STATA/lista05_q02_pobreza_observado_ajustado.png", replace width(1800)
    graph export "$FIGS_STATA/lista05_q02_pobreza_observado_ajustado.pdf", replace
    regress pobreza no ne su co pibpc escol c.escol#c.no c.escol#c.ne c.escol#c.su c.escol#c.co, vce(robust)
    estat imtest, white
}
else {
    display "Arquivo municipios_lista05.csv não encontrado; ver solução simbólica no notebook."
}

* Q3 - dados digitados do enunciado
import delimited "$DATA/lista05_q03_hetero.csv", clear
reg y x
predict yhat, xb
predict resid, resid
estat imtest, white
reg y x, vce(robust)
gen w = 1/(x^2)
reg y x [aw=w]
twoway (scatter y x) (line yhat x, sort), xtitle("Número médio de empregados") ytitle("Salário médio por trabalhador") title("Lista 5 - Questão 3") name(g_l5q3a, replace)
graph export "$FIGS_STATA/lista05_q03_hetero_scatter_mqo.png", replace width(1800)
graph export "$FIGS_STATA/lista05_q03_hetero_scatter_mqo.pdf", replace
gen resid2 = resid^2
twoway scatter resid2 x, xtitle("Número médio de empregados") ytitle("Resíduo ao quadrado") title("Lista 5 - Questão 3") name(g_l5q3b, replace)
graph export "$FIGS_STATA/lista05_q03_residuos_quadrados.png", replace width(1800)
graph export "$FIGS_STATA/lista05_q03_residuos_quadrados.pdf", replace

* Q5
clear
input obs var_u
1 1
2 3
3 4
4 6
5 8
end
display "beta_hat = (0+7+5+0+0)/5 = " (0+7+5+0+0)/5
graph bar var_u, over(obs) ytitle("Var(u_i | X)") title("Lista 5 - Questão 5") name(g_l5q5, replace)
graph export "$FIGS_STATA/lista05_q05_variancias_condicionais.png", replace width(1800)
graph export "$FIGS_STATA/lista05_q05_variancias_condicionais.pdf", replace

capture log close