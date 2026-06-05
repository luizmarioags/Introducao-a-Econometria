import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.formula.api as smf
from common import TABLES, wooldridge_data, savefig

# Q4 - ceosal1
try:
    ceo = wooldridge_data('ceosal1')
    mod = smf.ols('np.log(salary) ~ np.log(sales) + roe + ros', data=ceo).fit()
    (TABLES / 'lista03_q04_ceosal1.txt').write_text(mod.summary().as_text(), encoding='utf-8')

    ros_grid = np.linspace(ceo['ros'].min(), ceo['ros'].max(), 100)
    base = ceo[['sales', 'roe']].mean()
    y_grid = (mod.params['Intercept'] + mod.params['np.log(sales)']*np.log(base['sales'])
              + mod.params['roe']*base['roe'] + mod.params['ros']*ros_grid)
    plt.figure(figsize=(7, 4))
    plt.scatter(ceo['ros'], np.log(ceo['salary']))
    plt.plot(ros_grid, y_grid)
    plt.xlabel('Retorno sobre vendas, ROS')
    plt.ylabel('log(salário)')
    plt.title('Lista 3 - Questão 4: ROS e salário dos CEOs')
    savefig(plt, 'lista03_q04_ceosal1_ros_lsalary')
except Exception as e:
    (TABLES / 'lista03_q04_ceosal1_erro.txt').write_text(str(e), encoding='utf-8')

# Q6 - return
try:
    ret = wooldridge_data('return').rename(columns={'return':'ret'})
    m1 = smf.ols('ret ~ dkr + eps + salary + netinc', data=ret).fit()
    (TABLES / 'lista03_q06_return_nivel.txt').write_text(m1.summary().as_text(), encoding='utf-8')
    ret = ret.assign(lnetinc=np.log(ret['netinc']), lsalary=np.log(ret['salary']))
    m2 = smf.ols('ret ~ dkr + eps + lsalary + lnetinc', data=ret).fit()
    (TABLES / 'lista03_q06_return_log.txt').write_text(m2.summary().as_text(), encoding='utf-8')

    plt.figure(figsize=(7, 4))
    plt.scatter(ret['ret'], m2.fittedvalues)
    lims = [min(ret['ret'].min(), m2.fittedvalues.min()), max(ret['ret'].max(), m2.fittedvalues.max())]
    plt.plot(lims, lims)
    plt.xlabel('Retorno observado')
    plt.ylabel('Retorno ajustado')
    plt.title('Lista 3 - Questão 6: observado versus ajustado')
    savefig(plt, 'lista03_q06_return_observado_ajustado')
except Exception as e:
    (TABLES / 'lista03_q06_return_erro.txt').write_text(str(e), encoding='utf-8')

print('Lista 3 concluída.')
