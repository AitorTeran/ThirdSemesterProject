import scipy.io
import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow import keras

mat = scipy.io.loadmat("./dataANNcrd.mat")

vector = mat['vector']
result = np.where(vector.T==1) # numpy .T -> trasponer

columns = list(mat.keys())
columns.remove('__header__')
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
model.add(tf.keras.layers.Dense(15, activation='sigmoid', input_dim = 8))
model.add(tf.keras.layers.Dense(7, activation='softmax')) 

model.compile(optimizer='adam',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

callbacks = keras.callbacks.TensorBoard(log_dir = ".\Tensorboard_logs")

train = train.sample(frac = 1)

history = model.fit(
        x = train[features].to_numpy(),
        y = train[labels].to_numpy(),
        batch_size = 100,
        validation_split = 0.1,
        epochs = 10)

model.save('./savedmodel.h5')
