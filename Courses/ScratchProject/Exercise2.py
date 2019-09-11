'''
Exercise #2
The reindex method allows index values that are not in the original DataFrame's index values.
Try it and see what happens if you use such values! Why do you think this is allowed?
'''
from __future__ import print_function
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

city_names = pd.Series(['San Francisco', 'San Jose', 'Sacramento'])
population = pd.Series([852469, 1015785, 485199])

cities = pd.DataFrame({'City name': city_names, 'Population': population})

#cities['Area square miles'] = pd.Series([46.87, 176.53, 97.92])
#cities['Population density'] = cities['Population'] / cities['Area square miles']


#cities['Is wide and has saint name'] = (cities['Area square miles'] > 50) & cities['City name'].apply(lambda name: name.startswith('San'))


cities = cities.reindex([0,4,5,2])

print(cities)
