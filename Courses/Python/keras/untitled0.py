# importing libraries

import tensorflow as tf
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.pyplot import rcParams
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score

# reading in files

train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv')
df = pd.concat([train, test], axis=0, sort=True)

model = tf.keras.Sequential()
model.add(tf.keras.layers.Dense(3, activation='relu'))
model.add(tf.keras.layers.Dense(1, activation='sigmoid')) #softmax para que todas las probabilidades de la ultima capa sumen 1

model.compile(optimizer='adam',
              loss='binary_crossentropy',
              metrics=['accuracy'])

train_feature=train['Pclass'].to_numpy()
train_labels=train['Survived'].to_numpy()
history = model.fit(train_feature, train_labels, epochs = 100)