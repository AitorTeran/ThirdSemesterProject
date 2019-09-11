from __future__ import print_function

import math

from IPython import display
from matplotlib import cm
from matplotlib import gridspec
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
from sklearn import metrics
import tensorflow as tf
from tensorflow.python.data import Dataset

tf.logging.set_verbosity(tf.logging.ERROR)
pd.options.display.max_rows = 10
pd.options.display.float_format = '{:.1f}'.format

#GET DATA
california_housing_dataframe = pd.read_csv("https://download.mlcc.google.com/mledu-datasets/california_housing_train.csv", sep=",")

#RANDOMIZE DATA - Now it is no longer ordered from 1 to 17k but randomly
california_housing_dataframe = california_housing_dataframe.reindex(
    np.random.permutation(california_housing_dataframe.index))
california_housing_dataframe["median_house_value"] /= 1000.0

#EXAMINE DATA
#print(california_housing_dataframe.describe())

#CONFIGURE FEATURE COLUMNS
#Input feature: total rooms
my_feature = california_housing_dataframe[["total_rooms"]]

#Numeric feature colum for total_rooms
feature_columns = [tf.feature_column.numeric_column("total_rooms")]
print(california_housing_dataframe)
print(my_feature)