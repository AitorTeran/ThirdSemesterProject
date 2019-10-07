# importing libraries

import tensorflow as tf
import numpy as np
import pandas as pd
from tensorflow import keras

train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv')
df = pd.concat([train, test], axis=0, sort=True)
train['SexEncoding'] = train.Sex.map({'female':1, 'male':0})
traindummies = pd.get_dummies(train['Embarked'], prefix = 'Embarked')
train = pd.concat([train, traindummies],axis=1)

keys = ['Fare','Age','SexEncoding','Parch','SibSp','Embarked_C','Embarked_Q','Embarked_S']
keys.append('Survived')

training_data = train[keys]
training_data = training_data[~np.isnan(training_data).any(axis=1)]
keys.remove('Survived')
features = training_data[keys].to_numpy()
labels = training_data[['Survived']].to_numpy()

model = tf.keras.Sequential()
model.add(tf.keras.layers.Dense(8, activation='relu', input_shape = [len(keys)], kernel_regularizer=keras.regularizers.l2(l=0.1)))
model.add(tf.keras.layers.Dense(16, activation='relu'))
model.add(tf.keras.layers.Dense(1, activation='sigmoid')) #softmax para que todas las probabilidades de la ultima capa sumen 1

model.compile(optimizer='adam',
              loss='binary_crossentropy',
              metrics=['accuracy'])

history = model.fit(x = features, y = labels, batch_size = 10, steps_per_epoch = 100, validation_split = 0.2, epochs = 100) #fit(x=None, y=None, batch_size=None, epochs=1, verbose=1, callbacks=None, validation_split=0.0, validation_data=None, shuffle=True, class_weight=None, sample_weight=None, initial_epoch=0, steps_per_epoch=None, validation_steps=None, validation_freq=1, max_queue_size=10, workers=1, use_multiprocessing=False)
