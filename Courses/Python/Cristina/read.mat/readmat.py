# -*- coding: utf-8 -*-
"""
Created on Thu Oct 17 11:59:01 2019

@author: Kristina
"""

import numpy as np
 
import scipy.io
mat = scipy.io.loadmat('dataANNcrd.mat')






# Create a 2D Numpy array from list of lists
arr = np.array([[0, 0, 1],
                [0, 0, 0],
                [1, 0, 0],
                [0, 1, 0]])

result = np.where(arr == 1)
indexes= list(result[0]+1)

