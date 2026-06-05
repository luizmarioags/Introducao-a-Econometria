from pathlib import Path
import numpy as np
import pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf
from statsmodels.stats.diagnostic import het_white, het_breuschpagan

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / 'data' / 'manual'
OUT = ROOT / 'outputs'
TABLES = OUT / 'tables'
FIGS = OUT / 'figures'
FIGS_PY = FIGS / 'python'
LOGS = ROOT / 'logs'
for p in [TABLES, FIGS, FIGS_PY, LOGS]:
    p.mkdir(parents=True, exist_ok=True)


def wooldridge_data(name):
    try:
        import wooldridge as woo
    except ImportError as exc:
        raise ImportError('Instale o pacote Python wooldridge: pip install wooldridge') from exc
    return woo.data(name)


def add_const(x):
    return sm.add_constant(x, has_constant='add')


def write_txt(name, text):
    path = TABLES / name
    path.write_text(text, encoding='utf-8')
    return path


def savefig(plt, name):
    plt.tight_layout()
    plt.savefig(FIGS_PY / f'{name}.png', dpi=300, bbox_inches='tight')
    plt.savefig(FIGS_PY / f'{name}.pdf', bbox_inches='tight')
    plt.close()
