import scipy.io
import numpy as np
import pandas as pd
from tensorflow import keras
import itertools
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix

#%% Read test data
testmat = scipy.io.loadmat("./Testdata.mat")

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


#%% Make predictions on test data
#model = keras.models.load_model("./model_9796.h5")
#model = keras.models.load_model("./2step_9710.h5")
model = keras.models.load_model("./3step_9757.h5")
predictions = model.predict(test[features])



#%% Calculate and show confusion matrix 
def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
  """
  This function prints and plots the confusion matrix.
  Normalization can be applied by setting `normalize=True`.
  """
  if normalize:
      cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
      cm = cm * 100
      print("\nNormalized confusion matrix")
  else:
      print('\nConfusion matrix, without normalization')
  print(cm)
  print ()
  


  plt.imshow(cm, interpolation='nearest', cmap=cmap)
  plt.title(title)
  plt.colorbar()
  tick_marks = np.arange(len(classes))
  plt.xticks(tick_marks, classes, rotation=45)
  plt.yticks(tick_marks, classes)

  fmt = '.1f' if normalize else 'd'
  thresh = cm.max() / 2.
  for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
      plt.text(j, i, format(cm[i, j], fmt),
                horizontalalignment="center",
                color="white" if cm[i, j] > thresh else "black")

  plt.tight_layout()
  plt.ylabel('True label')
  plt.xlabel('Predicted label')
  plt.show()
  
 # Compute confusion matrix
y_pred = np.argmax(predictions, axis=1)
y_label = np.argmax(test[labels].to_numpy(), axis = 1)
cnf_matrix = confusion_matrix(y_label, y_pred)
np.set_printoptions(precision=2) # set NumPy to 2 decimal places


# Plot non-normalized confusion matrix
class_names = ['State 1', 'State 2', 'State 3', 'State 4', 'State 5', 'State 6', 'State 7']

plt.figure()
plot_confusion_matrix(cnf_matrix, classes=class_names,
                      title='Confusion matrix, without normalization')

# Plot normalized confusion matrix

f = plt.figure()
plot_confusion_matrix(cnf_matrix, classes=class_names, normalize=True,
                      title='Normalized confusion matrix')
f.savefig("ConfusionMatrix.pdf", bbox_inches='tight')

#df.savefig("ConfusionMatrix.pdf", bbox_inches='tight')

rightpred = 0
for index in range(len(cnf_matrix)):
    rightpred += cnf_matrix[index,index]
    
# Save plot to PDF


print("Total test accuracy: " + str(format(rightpred/sum(sum(cnf_matrix)), '.4f')))
    