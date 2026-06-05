
import subprocess
import sys
from pathlib import Path

scripts = ['lista01.py', 'lista02.py', 'lista03.py', 'lista04.py', 'lista05.py']
base = Path(__file__).resolve().parent
for s in scripts:
    print(f'Executando {s}...')
    subprocess.run([sys.executable, str(base / s)], check=True, cwd=str(base))
print('Replicação Python concluída.')
