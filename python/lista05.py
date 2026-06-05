import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
import statsmodels.formula.api as smf
from statsmodels.stats.diagnostic import het_white
from common import DATA, TABLES, add_const, savefig

# Q2 - base municipal, se fornecida
mun_path = DATA / 'municipios_lista05.csv'
if mun_path.exists():
    mun = pd.read_csv(mun_path)
    formula = 'pobreza ~ no + ne + su + co + pibpc + escol + escol:no + escol:ne + escol:su + escol:co'
    mod = smf.ols(formula, data=mun).fit()
    (TABLES / 'lista05_q02_ols.txt').write_text(mod.summary().as_text(), encoding='utf-8')
    rob = mod.get_robustcov_results(cov_type='HC1')
    (TABLES / 'lista05_q02_robusto.txt').write_text(rob.summary().as_text(), encoding='utf-8')

    mun['ajustado'] = mod.fittedvalues
    plt.figure(figsize=(7, 4))
    plt.scatter(mun['pobreza'], mun['ajustado'])
    lims = [min(mun['pobreza'].min(), mun['ajustado'].min()), max(mun['pobreza'].max(), mun['ajustado'].max())]
    plt.plot(lims, lims)
    plt.xlabel('Pobreza observada')
    plt.ylabel('Pobreza ajustada')
    plt.title('Lista 5 - Questão 2: observado versus ajustado')
    savefig(plt, 'lista05_q02_pobreza_observado_ajustado')
else:
    (TABLES / 'lista05_q02_aviso.txt').write_text('Arquivo data/manual/municipios_lista05.csv não encontrado; questão resolvida simbolicamente no notebook.', encoding='utf-8')

# Q3 - heterocedasticidade com tabela do enunciado
het = pd.read_csv(DATA / 'lista05_q03_hetero.csv')
ols = sm.OLS(het['y'], add_const(het['x'])).fit()
(TABLES / 'lista05_q03_ols.txt').write_text(ols.summary().as_text(), encoding='utf-8')
lm, lm_p, fstat, f_p = het_white(ols.resid, add_const(het['x']))
pd.DataFrame({'estatistica':['LM_White','p_LM','F_White','p_F'], 'valor':[lm,lm_p,fstat,f_p]}).to_csv(TABLES / 'lista05_q03_white.csv', index=False)
rob = ols.get_robustcov_results(cov_type='HC1')
(TABLES / 'lista05_q03_robusto.txt').write_text(rob.summary().as_text(), encoding='utf-8')
wls = sm.WLS(het['y'], add_const(het['x']), weights=1/(het['x']**2)).fit()
(TABLES / 'lista05_q03_wls.txt').write_text(wls.summary().as_text(), encoding='utf-8')

x_grid = np.linspace(het['x'].min(), het['x'].max(), 200)
y_grid = ols.params['const'] + ols.params['x']*x_grid
plt.figure(figsize=(7, 4))
plt.scatter(het['x'], het['y'], label='Observações')
plt.plot(x_grid, y_grid, label='Reta MQO')
plt.xlabel('Número médio de empregados')
plt.ylabel('Salário médio por trabalhador')
plt.title('Lista 5 - Questão 3: MQO')
plt.legend()
savefig(plt, 'lista05_q03_hetero_scatter_mqo')

plt.figure(figsize=(7, 4))
plt.scatter(het['x'], ols.resid**2)
plt.xlabel('Número médio de empregados')
plt.ylabel('Resíduo ao quadrado')
plt.title('Lista 5 - Questão 3: resíduos ao quadrado')
savefig(plt, 'lista05_q03_residuos_quadrados')

# Q5
X = np.ones((5,1))
y = np.array([0,7,5,0,0]).reshape(-1,1)
beta = np.linalg.inv(X.T @ X) @ X.T @ y
pd.DataFrame({'parametro':['beta_hat'], 'valor':[float(beta[0,0])]}).to_csv(TABLES / 'lista05_q05.csv', index=False)
variancias = np.array([1,3,4,6,8])
plt.figure(figsize=(7, 4))
plt.bar(np.arange(1,6), variancias)
plt.xlabel('Observação')
plt.ylabel('Var(u_i | X)')
plt.title('Lista 5 - Questão 5: variância condicional do erro')
savefig(plt, 'lista05_q05_variancias_condicionais')

print('Lista 5 concluída.')
