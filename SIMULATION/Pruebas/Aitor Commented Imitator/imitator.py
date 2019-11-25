import scipy.io #Mathematical library. 

import numpy as np #Support for large mathematical arrays - Wiki
import pandas as pd #Allows easy data manipulation and analysis - Wiki
import tensorflow as tf #Machine learning and neural networks - Wiki
from tensorflow import keras #Neural network library - Wiki
        
mat = scipy.io.loadmat("./dataANNcrd.mat")  #Load data from matlab array.
                
vector = mat['vector']  #Take the submatrix called vector from the loaded matlab array.

result = np.where(vector.T==1)  #Return elements that fulfill the condition (numpy .T -> traspose).
                                #What this line does is to return the position of the 1s in the vector for each row.

columns = list(mat.keys())      #Lists the labels or keys of each column. (Vector would be one of them).
columns.remove('__header__')    #Remove the columns that are unnecessary for the training.
columns.remove('__globals__')
columns.remove('__version__')
columns.remove('x_opt')
columns.remove('vector')

train = pd.DataFrame(np.concatenate([mat[c] for c in columns], axis=1), columns=columns)
train['state'] = list(result[1]+1)

labels = []
for x in range(7):
    train['state_' + str(x+1)] = vector[x,:]
    labels.append('state_' + str(x+1))


    
features = ['R1',
            'if_alpha1',
            'if_beta1',
            'vc_alpha1',
            'vc_beta1',
            'vref_alpha1',
            'vref_beta1',
            'x_opt_old1']

model = tf.keras.Sequential()
model.add(tf.keras.layers.Dense(8, activation='relu'))
model.add(tf.keras.layers.Dense(15, activation='relu'))
model.add(tf.keras.layers.Dense(7, activation='softmax')) 

model.compile(optimizer='adam',
              loss='binary_crossentropy',
              metrics=['accuracy'])

callbacks = keras.callbacks.TensorBoard(log_dir = ".\Tensorboard_logs")

train = train.sample(frac = 1)

history = model.fit(
        x = train[features].to_numpy(),
        y = train[labels].to_numpy(),
        batch_size = 10000,
        steps_per_epoch = 50,
        validation_split = 0.2,
        epochs = 10,
        callbacks = [callbacks])

model.save('./savedmodel.h5')