import math
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from common import TABLES, savefig

# Q1
pib_otimo = 0.0107/(2*0.000000245)
q1 = pd.DataFrame({'indicador':['PIB_otimo'], 'valor':[pib_otimo]})
q1.to_csv(TABLES / 'lista04_q01.csv', index=False)
pib_grid = np.linspace(0, 30000, 400)
y_pib = 492.6 + 0.0107*pib_grid - 0.000000245*pib_grid**2
plt.figure(figsize=(7, 4))
plt.plot(pib_grid, y_pib)
plt.axvline(pib_otimo, linestyle='--', label=f'PIB ótimo ≈ {pib_otimo:.0f}')
plt.xlabel('PIB per capita, em US$')
plt.ylabel('Pontuação prevista')
plt.title('Lista 4 - Questão 1: termo quadrático do PIB')
plt.legend()
savefig(plt, 'lista04_q01_pib_quadratico')

# Q3
R2, n, k = 0.94363, 27, 2
F = (R2/k)/((1-R2)/(n-k-1))
intercept_y_milhoes = 1.1755 - math.log(1000)
intercept_k_milhoes = 1.1755 + 0.3756*math.log(1000)
ici = 0.02*(0.3756 - 2.064*0.0851)
ics = 0.02*(0.3756 + 2.064*0.0851)
pd.DataFrame({'indicador':['F_conjunto','intercepto_Y_milhoes','intercepto_K_milhoes','IC_inf_2pct_K','IC_sup_2pct_K'],
              'valor':[F,intercept_y_milhoes,intercept_k_milhoes,ici,ics]}).to_csv(TABLES / 'lista04_q03.csv', index=False)
K_grid = np.linspace(1, 100, 200)
L_fix = 50
Y_grid = math.exp(1.1755) * (L_fix**0.6022) * (K_grid**0.3756)
plt.figure(figsize=(7, 4))
plt.plot(K_grid, Y_grid)
plt.xlabel('Capital K')
plt.ylabel('Produto previsto Y')
plt.title('Lista 4 - Questão 3: Cobb-Douglas com L fixo')
savefig(plt, 'lista04_q03_cobb_douglas_capital')

# Q4
pred = 18.897
pd.DataFrame({'indicador':['mpg_previsto','IC95_inf','IC95_sup'], 'valor':[pred,18.168,19.626]}).to_csv(TABLES / 'lista04_q04.csv', index=False)
w_grid = np.linspace(1800, 5000, 200)
mpg_pred = 43.998 - 0.022*240 - 0.006*w_grid
plt.figure(figsize=(7, 4))
plt.plot(w_grid, mpg_pred)
plt.scatter([3500], [18.897])
plt.xlabel('Peso do veículo, em libras')
plt.ylabel('mpg previsto')
plt.title('Lista 4 - Questão 4: previsão para hp fixo em 240')
savefig(plt, 'lista04_q04_mpg_peso_hp240')

print('Lista 4 concluída.')
