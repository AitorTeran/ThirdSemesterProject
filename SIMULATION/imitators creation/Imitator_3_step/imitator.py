import scipy.io #Mathematical library. 
import numpy as np #Support for large mathematical arrays - Wiki
import pandas as pd #Allows easy data manipulation and analysis - Wiki
import tensorflow as tf #Machine learning and neural networks - Wiki
from tensorflow import keras #Neural network library - Wiki
        

#COLLECTING THE DATA.

mat = scipy.io.loadmat("./dataANNcrd.mat")          #Load data from matlab array.
valmat = scipy.io.loadmat("./Validationdata.mat")   

vector = mat['vector']  #Take the submatrix called vector from the loaded matlab array.
valvector = valmat['vector']

result = np.where(vector.T==1)  #Return elements that fulfill the condition (numpy .T -> traspose).
                                #What this line does is to return the position of the 1s in the vector for each row.
                                #Watch out bc the positions go from 0 to 6 instead of 1 to 7.
valresult = np.where(valvector.T==1)

columns = list(mat.keys())      #Lists the labels or keys of each column. (Vector would be one of them).
columns.remove('__header__')    #Remove the columns that are unnecessary for the training.
columns.remove('__globals__')
columns.remove('__version__')
columns.remove('x_opt')
columns.remove('vector')

train = pd.DataFrame(np.concatenate([mat[c] for c in columns], axis=1), columns=columns)    #Concatenate in variable train the reminding columns of mat (remember mat was a collection of submatrixes).
val = pd.DataFrame(np.concatenate([valmat[c] for c in columns], axis=1), columns=columns)

train['state'] = list(result[1]+1)  #Add another column with the state going from 1 to 7.
val['state'] = list(valresult[1]+1)

labels = []     #Init variable label which will contain the columns of vector with appropiate header.
for x in range(7):
    train['state_' + str(x+1)] = vector[x,:]    #Add name and include each column in vector.
    val['state_' + str(x+1)] = valvector[x,:]
    labels.append('state_' + str(x+1))          #Create array with the names of the states.

features = ['R1',
            'if_alpha1',
            'if_beta1',
            'vc_alpha1',
            'vc_beta1',
            'vref_alpha1',
            'vref_beta1',
            'x_opt_old1']

#At this point: 
    #result is a tuple containing the state (from 0 to 6) of each sample along with its location in the dataframe, it's no longer used.
    #columns is a column list containing only the labels of those inputs that haven't been removed.
    #labels is a row list containing only the labels of the states.
    #features is a column list containing the values to be examined. (EXACTLY THE SAME AS COLUMNS)
    #train is a pandas dataframe with columns of different data where first row is the label of the column. 
        #States are included as the last 7 columns of the matris train.
    
    #Overall, data is ready to be treated.



#TRAINING THE MODEL.

model = tf.keras.Sequential()   #Create a sequential model, linear stack of layers.
model.add(tf.keras.layers.Dense(15, activation='relu', input_dim = 8))   #Add layer with 8 neurons and relu activation. Other activations found at https://keras.io/activations/
model.add(tf.keras.layers.Dense(7, activation='softmax')) 

model.compile(optimizer='adam',                 #Other optimizers found at https://keras.io/optimizers/
              loss='categorical_crossentropy',  #Other loss functions found at https://keras.io/losses/
              metrics=['accuracy'])

callbacks = keras.callbacks.TensorBoard(log_dir = "./Tensorboard_logs") #Callbacks are called at different stages of training, saves data for later inspection.

train = train.sample(frac = 1)  #Takes frac percentage of the data (in this case 100%) and shuffles it.
                                #Taking less than 100% of data could be usefull to only train the model on partial data. 
                                #Now the data stored in train is shuffled.

history = model.fit(        #Train the model with the characteristics listed below.
        x = train[features].to_numpy(), #Input data
        y = train[labels].to_numpy(),   #Target data
        batch_size = 100,                #Parts in which the dataset is divided into.
        validation_data = (val[features].to_numpy(), val[labels].to_numpy()),	#Validation data used.
        epochs = 20)                     #How many times the dataset is passed through the neural network.
                      
#        validation_split = 0.1,         #What percentage of data is used for validation.
#        callbacks = [callbacks]         #Call the function stated before to save tensoflow data.

model.save('./savedmodel.h5')   #Save the model.