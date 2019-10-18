import scipy.io
import numpy as np
import pandas as pd

mat = scipy.io.loadmat("./dataANNcrd.mat")

vector = mat['vector']
result = np.where(vector.T==1) # numpy .T -> trasponer

columns = list(mat.keys())
columns.remove('__header__')
columns.remove('__globals__')
columns.remove('__version__')
columns.remove('x_opt_old1')
columns.remove('x_opt')
columns.remove('vector')

df = pd.DataFrame(np.concatenate([mat[c] for c in columns], axis=1), columns=columns)
df['state'] = list(result[1]+1)
df = df.sample(frac = 1)

