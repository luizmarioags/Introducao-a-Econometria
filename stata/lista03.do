do stata/00_setup.do
capture log close _all
log using "$LOGS/stata_lista03.log", replace text

* Q4 - Wooldridge ceosal1
bcuse ceosal1, clear
reg lsalary lsales roe ros, cformat(%9.4f) pformat(%5.4f) sformat(%8.4f)
display "Efeito percentual aproximado de +50 em ros = " 100*(_b[ros]*50)
test ros
twoway (scatter lsalary ros) (lfit lsalary ros), xtitle("Retorno sobre vendas, ROS") ytitle("log(salário)") title("Lista 3 - Questão 4") name(g_l3q4, replace)
graph export "$FIGS_STATA/lista03_q04_ceosal1_ros_lsalary.png", replace width(1800)
graph export "$FIGS_STATA/lista03_q04_ceosal1_ros_lsalary.pdf", replace

* Q6 - Wooldridge return
bcuse return, clear
reg return dkr eps salary netinc, cformat(%9.3f) pformat(%5.3f) sformat(%8.3f)

* A base return pode já conter lsalary/lnetinc em algumas instalações.
* Por isso, removemos antes de recriar para tornar o script reexecutável.
capture drop lnetinc
capture drop lsalary
quietly gen lnetinc = ln(netinc) if netinc > 0
quietly gen lsalary = ln(salary) if salary > 0
reg return dkr eps lsalary lnetinc if !missing(lnetinc, lsalary), cformat(%9.3f) pformat(%5.3f) sformat(%8.3f)
predict return_hat, xb
twoway (scatter return_hat return) (function y=x, range(return)), xtitle("Retorno observado") ytitle("Retorno ajustado") title("Lista 3 - Questão 6") name(g_l3q6, replace)
graph export "$FIGS_STATA/lista03_q06_return_observado_ajustado.png", replace width(1800)
graph export "$FIGS_STATA/lista03_q06_return_observado_ajustado.pdf", replace

capture log close