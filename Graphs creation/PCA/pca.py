import numpy as np
import pandas as pd
import scipy.io
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

mat = scipy.io.loadmat("./dataANNcrd.mat")
valmat = scipy.io.loadmat("./Validationdata.mat")   

vector = mat['vector']
valvector = valmat['vector']

result = np.where(vector.T==1) 
valresult = np.where(valvector.T==1)

columns = list(mat.keys())      
columns.remove('__header__')
columns.remove('__globals__')
columns.remove('__version__')
columns.remove('x_opt')
columns.remove('vector')

train = pd.DataFrame(np.concatenate([mat[c] for c in columns], axis=1), columns=columns)   
val = pd.DataFrame(np.concatenate([valmat[c] for c in columns], axis=1), columns=columns)

train['labels'] = result[1]
val['labels'] = valresult[1]

x = val.loc[:,columns].values
x = StandardScaler().fit_transform(x)
normalisedval = pd.DataFrame(x, columns = columns)

#%% PCA
PCA_val = PCA(n_components = 2)
PCA_val_fit = PCA_val.fit_transform(x)
PCA_val_df = pd.DataFrame(data = PCA_val_fit, columns = range(2))

print('Explained variation per principal component: {}'.format(PCA_val.explained_variance_ratio_))
print(str(100-sum(PCA_val.explained_variance_ratio_*100)) + '% of the information was lost due to dimensionality reduction.')

plt.figure()
plt.figure(figsize=(10,10))
plt.xticks(fontsize=12)
plt.yticks(fontsize=14)
plt.xlabel('Principal Component - 1',fontsize=20)
plt.ylabel('Principal Component - 2',fontsize=20)
plt.title("Principal Component Analysis of a set of Validation Data",fontsize=20)
targets = ['State 1', 'State 2', 'State 3', 'State 4', 'State 5', 'State 6', 'State 7']
colors = ['tab:blue', 'tab:orange', 'tab:green', 'tab:red', 'tab:purple', 'tab:brown', 'tab:pink']

for target, color in zip([1,2,3,4,5,6,7],colors):
    indicesToKeep = val['labels'] == target
    plt.scatter(PCA_val_df[1:1000].loc[indicesToKeep, 0]
               , PCA_val_df[1:1000].loc[indicesToKeep, 1], c = color, s = 50)

plt.legend(targets,prop={'size': 15})


#%% PCA with learnt features
learnt_val_features = scipy.io.loadmat("./learnt_features.mat")['output']
normalised_learnt = StandardScaler().fit_transform(learnt_val_features)

PCA_val_learnt = PCA(n_components = 2)
PCA_val_learnt_fit = PCA_val_learnt.fit_transform(normalised_learnt)
PCA_val_learnt_df = pd.DataFrame(data = PCA_val_learnt_fit, columns = range(2))

print('Explained variation per principal component: {}'.format(PCA_val_learnt.explained_variance_ratio_))
print(str(100-sum(PCA_val_learnt.explained_variance_ratio_*100)) + '% of the information was lost due to dimensionality reduction.')

plt.figure()
plt.figure(figsize=(10,10))
plt.xticks(fontsize=12)
plt.yticks(fontsize=14)
plt.xlabel('Principal Component - 1',fontsize=20)
plt.ylabel('Principal Component - 2',fontsize=20)
plt.title("Principal Component Analysis of a set of Validation Data",fontsize=20)
targets = ['State 1', 'State 2', 'State 3', 'State 4', 'State 5', 'State 6', 'State 7']
colors = ['tab:blue', 'tab:orange', 'tab:green', 'tab:red', 'tab:purple', 'tab:brown', 'tab:pink']

for target, color in zip([1,2,3,4,5,6,7],colors):
    indicesToKeep = val['labels'] == target
    plt.scatter(PCA_val_learnt_df[1:1000].loc[indicesToKeep, 0]
               , PCA_val_learnt_df[1:1000].loc[indicesToKeep, 1], c = color, s = 50)

plt.legend(targets,prop={'size': 15})


#%% PCA 3D
from mpl_toolkits.mplot3d import Axes3D

PCA_val_3D = PCA(n_components = 3)
PCA_val_fit_3D = PCA_val.fit_transform(x)
PCA_val_df_3D = pd.DataFrame(data = PCA_val_fit_3D, columns = range(2))

fig = plt.figure(1, figsize=(10, 8))
plt.clf()
ax = Axes3D(fig, rect=[0, 0, .95, 1], elev=48, azim=134)

plt.cla()
targets = ['State 1', 'State 2', 'State 3', 'State 4', 'State 5', 'State 6', 'State 7']
colors = ['tab:blue', 'tab:orange', 'tab:green', 'tab:red', 'tab:purple', 'tab:brown', 'tab:pink']

for target, color in zip([1,2,3,4,5,6,7],colors):
    indicesToKeep = val['labels'] == target
    plt.scatter(PCA_val_df_3D[1:1000].loc[indicesToKeep, 0]
               , PCA_val_df_3D[1:1000].loc[indicesToKeep, 1], c = color, s = 50)
    
    
#%% PCA 3D with learnt features

PCA_val_learnt_3D = PCA(n_components = 3)
PCA_val_fit_learnt_3D = PCA_val.fit_transform(normalised_learnt)
PCA_val_df_learnt_3D = pd.DataFrame(data = PCA_val_fit_learnt_3D, columns = range(2))

fig = plt.figure(1, figsize=(10, 8))
plt.clf()
ax = Axes3D(fig, rect=[0, 0, .95, 1], elev=48, azim=134)

plt.cla()
targets = ['State 1', 'State 2', 'State 3', 'State 4', 'State 5', 'State 6', 'State 7']
colors = ['tab:blue', 'tab:orange', 'tab:green', 'tab:red', 'tab:purple', 'tab:brown', 'tab:pink']

for target, color in zip([1,2,3,4,5,6,7],colors):
    indicesToKeep = val['labels'] == target
    plt.scatter(PCA_val_df_learnt_3D[1:1000].loc[indicesToKeep, 0]
               , PCA_val_df_learnt_3D[1:1000].loc[indicesToKeep, 1], c = color, s = 50)


#%% t-SNE
from sklearn.manifold import TSNE
import seaborn as sns
sns.set(rc={'figure.figsize':(11.7,8.27)})
palette = sns.color_palette("bright", 7)

indices = 100
tsne = TSNE(perplexity = 90, learning_rate = 2000, n_iter = 5000)
TSNE_val_fit = tsne.fit_transform(x[0:indices,:])
sns.scatterplot(TSNE_val_fit[:,0],TSNE_val_fit[:,1], hue = val['labels'][0:indices], legend = 'full', palette = palette)

#%% t-SNE with learnt features
indices = 10000
tsne = TSNE(perplexity = 90, learning_rate = 50, n_iter = 50000, early_exaggeration = 200)
TSNE_val_learnt_fit = tsne.fit_transform(normalised_learnt[0:indices,:])
sns.scatterplot(TSNE_val_learnt_fit[:,0],TSNE_val_learnt_fit[:,1], hue = val['labels'][0:indices], legend = 'full', palette = palette)