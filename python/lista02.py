import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.formula.api as smf
from common import DATA, TABLES, savefig

# Q1
def educ_hat(irms, educm, educp):
    return 10.36 - 0.094*irms + 0.131*educm + 0.210*educp

q1 = pd.DataFrame({'caso':['A_sem_irmaos_pais12','B_sem_irmaos_pais16'],
                   'educ_prevista':[educ_hat(0,12,12), educ_hat(0,16,16)]})
q1.loc[2] = ['diferenca_B_menos_A', q1.loc[1,'educ_prevista'] - q1.loc[0,'educ_prevista']]
q1.to_csv(TABLES / 'lista02_q01.csv', index=False)
plt.figure(figsize=(7, 4))
plt.bar(['A', 'B'], q1.loc[:1, 'educ_prevista'])
plt.ylabel('Educação prevista, em anos')
plt.title('Lista 2 - Questão 1: escolaridade prevista')
savefig(plt, 'lista02_q01_educacao_prevista')

# Q5 - replicação se a base da disciplina for fornecida.
cars_path = DATA / 'cars_lista02.csv'
if cars_path.exists():
    cars = pd.read_csv(cars_path)
    cars.describe().to_csv(TABLES / 'lista02_q05_descritivas.csv')
    mod_full = smf.ols('KPL ~ VM + HP + PV', data=cars).fit()
    (TABLES / 'lista02_q05_modelo_completo.txt').write_text(mod_full.summary().as_text(), encoding='utf-8')
    mod_vm = smf.ols('VM ~ HP + PV', data=cars).fit()
    cars['r_vm'] = mod_vm.resid
    mod_fwl = smf.ols('KPL ~ r_vm', data=cars).fit()
    (TABLES / 'lista02_q05_fwl.txt').write_text(mod_fwl.summary().as_text(), encoding='utf-8')

    plt.figure(figsize=(7, 4))
    plt.scatter(cars['VM'], cars['KPL'])
    plt.xlabel('Velocidade máxima')
    plt.ylabel('Quilômetros por litro')
    plt.title('Lista 2 - Questão 5: KPL e velocidade máxima')
    savefig(plt, 'lista02_q05_kpl_vm')

    plt.figure(figsize=(7, 4))
    plt.scatter(cars['r_vm'], cars['KPL'])
    order = np.argsort(cars['r_vm'])
    plt.plot(cars['r_vm'].iloc[order], mod_fwl.fittedvalues.iloc[order])
    plt.xlabel('Resíduo de VM após controlar HP e PV')
    plt.ylabel('KPL')
    plt.title('Lista 2 - Questão 5: teorema FWL')
    savefig(plt, 'lista02_q05_fwl')
else:
    (TABLES / 'lista02_q05_aviso.txt').write_text('Arquivo data/manual/cars_lista02.csv não encontrado; questão resolvida teoricamente no notebook.', encoding='utf-8')

print('Lista 2 concluída.')
