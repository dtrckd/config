c = get_config()

c.InteractiveShellApp.exec_lines = [
    'import sys, os, re, json, pickle',
    'import numpy as np',
    'import scipy as sp',
    'from scipy.sparse import csr_matrix, csc_matrix, coo_matrix',
    'import pandas as pd',
    'import matplotlib.pyplot as plt',
]
