import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
from common import DATA, TABLES, add_const, savefig

# Q1
hab = pd.read_csv(DATA / 'lista01_q01_habitacao.csv')
desp = hab['despesas_habitacao'].to_numpy(dtype=float)
q1 = pd.DataFrame({
    'medida': ['media','mediana','media_centenas','mediana_centenas'],
    'valor': [desp.mean(), np.median(desp), desp.mean()/100, np.median(desp)/100]
})
desp_novo = desp.copy(); desp_novo[7] = 900
q1 = pd.concat([q1, pd.DataFrame({'medida':['nova_media','nova_mediana'], 'valor':[desp_novo.mean(), np.median(desp_novo)]})], ignore_index=True)
q1.to_csv(TABLES / 'lista01_q01.csv', index=False)

plt.figure(figsize=(7, 4))
plt.bar(hab['familia'], desp)
plt.axhline(desp.mean(), linestyle='--', label='Média')
plt.axhline(np.median(desp), linestyle=':', label='Mediana')
plt.xlabel('Família')
plt.ylabel('Despesas mensais com habitação, em US$')
plt.title('Lista 1 - Questão 1: despesas por família')
plt.legend()
savefig(plt, 'lista01_q01_despesas_habitacao')

plt.figure(figsize=(7, 4))
pos = np.arange(2)
plt.bar(pos - 0.18, [desp.mean(), np.median(desp)], width=0.36, label='Original')
plt.bar(pos + 0.18, [desp_novo.mean(), np.median(desp_novo)], width=0.36, label='Família 8 = 900')
plt.xticks(pos, ['Média', 'Mediana'])
plt.ylabel('US$ por mês')
plt.title('Lista 1 - Questão 1: média e mediana')
plt.legend()
savefig(plt, 'lista01_q01_media_mediana_comparacao')

# Q3
q3 = pd.DataFrame({'SAT':[800,1400,1100]})
q3['E_IRA'] = 0.70 + 0.002*q3['SAT']
q3.to_csv(TABLES / 'lista01_q03.csv', index=False)
sat_grid = np.linspace(400, 1600, 200)
plt.figure(figsize=(7, 4))
plt.plot(sat_grid, 0.70 + 0.002*sat_grid)
plt.scatter(q3['SAT'], q3['E_IRA'])
plt.xlabel('SAT')
plt.ylabel('E(IRA | SAT)')
plt.title('Lista 1 - Questão 3: esperança condicional')
savefig(plt, 'lista01_q03_esperanca_condicional_ira_sat')

# Q6
renda = np.linspace(2000, 32000, 200)
pmgc = np.repeat(0.853, len(renda))
pmec = -124.84/renda + 0.853
pd.DataFrame({'renda': renda, 'PMgC': pmgc, 'PMeC': pmec}).to_csv(TABLES / 'lista01_q06_propensoes.csv', index=False)
plt.figure(figsize=(7, 4))
plt.plot(renda, pmgc, label='PMgC estimada')
plt.plot(renda, pmec, label='PMeC estimada')
plt.xlabel('Renda anual')
plt.ylabel('Propensão')
plt.title('Lista 1 - Questão 6: PMgC e PMeC')
plt.legend()
savefig(plt, 'lista01_q06_pmgc_pmec')

# Q7
gpa = pd.read_csv(DATA / 'lista01_q07_gpa_act.csv')
mod_gpa = sm.OLS(gpa['GPA'], add_const(gpa['ACT'])).fit()
(TABLES / 'lista01_q07_regressao.txt').write_text(mod_gpa.summary().as_text(), encoding='utf-8')
act_grid = np.linspace(gpa['ACT'].min()-1, gpa['ACT'].max()+1, 100)
y_grid = mod_gpa.params['const'] + mod_gpa.params['ACT']*act_grid
plt.figure(figsize=(7, 4))
plt.scatter(gpa['ACT'], gpa['GPA'], label='Observações')
plt.plot(act_grid, y_grid, label='Reta de MQO')
for x_i, y_i, yh_i in zip(gpa['ACT'], gpa['GPA'], mod_gpa.fittedvalues):
    plt.plot([x_i, x_i], [y_i, yh_i], linewidth=0.8)
plt.xlabel('ACT')
plt.ylabel('GPA')
plt.title('Lista 1 - Questão 7: GPA em função de ACT')
plt.legend()
savefig(plt, 'lista01_q07_gpa_act_mqo')

# Q11
cigs = np.linspace(0, 30, 100)
peso = 119.77 - 0.514*cigs
plt.figure(figsize=(7, 4))
plt.plot(cigs, peso)
plt.scatter([0, 20], [119.77, 119.77 - 0.514*20])
plt.xlabel('Cigarros por dia')
plt.ylabel('Peso previsto ao nascer, em onças')
plt.title('Lista 1 - Questão 11: peso ao nascer e cigarros')
savefig(plt, 'lista01_q11_peso_cigarros')

# Q15
xy = pd.read_csv(DATA / 'lista01_q15_xy.csv')
mod15 = sm.OLS(xy['y'], add_const(xy['x'])).fit()
(TABLES / 'lista01_q15_regressao.txt').write_text(mod15.summary().as_text(), encoding='utf-8')
plt.figure(figsize=(7, 4))
plt.scatter(xy['x'], xy['y'], label='Observado')
plt.plot(xy['x'], mod15.fittedvalues, marker='o', label='Ajustado')
plt.xlabel('x')
plt.ylabel('y')
plt.title('Lista 1 - Questão 15: observado e ajustado')
plt.legend()
savefig(plt, 'lista01_q15_observado_ajustado')

print('Lista 1 concluída.')
