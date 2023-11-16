c = get_config()

c.InteractiveShellApp.exec_lines = [
    'import sys, os, re, json',
    'from time import time',
    'import numpy as np',
    'import pandas as pd',
    'import matplotlib.pyplot as plt',
    #'from numpy import ma',
    #'import scipy as sp',
    #'import scipy.sparse as sparse',
    #'from scipy.sparse import csr_matrix, csc_matrix, coo_matrix',
    #'import sklearn',
    #'from sklearn.preprocessing import StandardScaler, Normalizer, Binarizer, LabelEncoder, OneHotEncoder, OrdinalEncoder, LabelBinarizer, PolynomialFeatures',
    #'from sklearn import metrics',
]

c.AliasManager.user_aliases = [
 ('la', 'ls -al')
]
