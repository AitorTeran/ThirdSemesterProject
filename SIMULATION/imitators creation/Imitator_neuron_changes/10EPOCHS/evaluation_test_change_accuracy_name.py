import scipy.io
import numpy as np
import pandas as pd
from tensorflow import keras
import itertools
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix

import os

#%%
neuron_num=[]
list_of_names = []
for file in os.listdir("./"):
    if file.endswith(".h5"):
        list_of_names.append(os.path.join("./", file))
        if int(file[-11:-9]) > 70:
            neuron_num.append(int(file[-10:-9]))
        else:
            neuron_num.append(int(file[-11:-9]))
        

      
#%% Read test data
            
testmat = scipy.io.loadmat("./Testdata.mat") #load test data to see test results of the net
    
vector = testmat['vector']
result = np.where(vector.T==1) # numpy .T -> trasponer
    
columns = list(testmat.keys())
columns.remove('__header__')
columns.remove('__globals__')
columns.remove('__version__')
columns.remove('x_opt')
columns.remove('vector')
    
test = pd.DataFrame(np.concatenate([testmat[c] for c in columns], axis=1), columns=columns)
test['state'] = list(result[1]+1)
    
labels = []
for x in range(7):
        test['state_' + str(x+1)] = vector[x,:]
        labels.append('state_' + str(x+1))
        
features = ['R1',
            'if_alpha1',
            'if_beta1',
            'vc_alpha1',
            'vc_beta1',
            'vref_alpha1',
            'vref_beta1',
            'x_opt_old1']
    
#%% LOOP


for idx,names in enumerate(list_of_names):   #idx is the number of the iteration in the loop
            
#Make predictions on test data
    model = keras.models.load_model(names)
    predictions = model.predict(test[features])

    y_pred = np.argmax(predictions, axis=1)
    y_label = np.argmax(test[labels].to_numpy(), axis = 1)
    accuracy = sum(y_pred==y_label)/len(y_pred)
    
    model.save('./'+str(neuron_num[idx])+'_'+str(accuracy)[2:6]+'.h5')
    