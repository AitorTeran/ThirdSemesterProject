'''
Modify the cities table by adding a new boolean column that is True if and only if both of the following are True:

The city is named after a saint.
The city has an area greater than 50 square miles.
Note: Boolean Series are combined using the bitwise, rather than the traditional boolean, operators. For example, when performing logical and, use & instead of and.

Hint: "San" in Spanish means "saint."
'''

from __future__ import print_function
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

city_names = pd.Series(['San Francisco', 'San Jose', 'Sacramento'])
population = pd.Series([852469, 1015785, 485199])

cities = pd.DataFrame({'City name': city_names, 'Population': population})

cities['Area square miles'] = pd.Series([46.87, 176.53, 97.92])
cities['Population density'] = cities['Population'] / cities['Area square miles']


hasSaint = city_names.apply(lambda a: "San" in a)
moreThan50sqMiles = cities['Area square miles'].apply(lambda area: 50 < area)

cities['After Saint'] = hasSaint
cities["More than 50"] = moreThan50sqMiles

cities['Both'] = cities['After Saint'] & cities['More than 50']

print(cities)