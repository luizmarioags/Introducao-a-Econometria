clear all
set more off

* Fecha logs eventualmente abertos de execuções anteriores.
* Isso torna os scripts reexecutáveis na mesma sessão do Stata.
capture log close _all

local cwd : pwd
global ROOT "`cwd'"
global DATA "$ROOT/data/manual"
global TABLES "$ROOT/outputs/tables"
global FIGS "$ROOT/outputs/figures"
global FIGS_STATA "$ROOT/outputs/figures/stata"
global LOGS "$ROOT/logs"

capture mkdir "$ROOT/outputs"
capture mkdir "$TABLES"
capture mkdir "$FIGS"
capture mkdir "$FIGS_STATA"
capture mkdir "$LOGS"

capture which bcuse
if _rc {
    ssc install bcuse, replace
}
