# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from __future__ import print_function

import collections
import io
import math

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import tensorflow as tf
from IPython import display
from sklearn import metrics

tf.logging.set_verbosity(tf.logging.ERROR)
train_url = 'https://download.mlcc.google.com/mledu-datasets/sparse-data-embedding/train.tfrecord'
train_path = tf.keras.utils.get_file(train_url.split('/')[-1], train_url) #it is a set of texts of the
#reviews and a label of if that review is positive or negative
test_url = 'https://download.mlcc.google.com/mledu-datasets/sparse-data-embedding/test.tfrecord'
test_path = tf.keras.utils.get_file(test_url.split('/')[-1], test_url)

# =============================================================================
#  let's configure the input pipeline to import our data into a TensorFlow model. We can use the following function to parse the training and test data (which is in TFRecord format) and return a dict of the features and the corresponding labels.
#To convert the string-value terms for an example into this vector format, we encode such that each coordinate gets a value of 0 if the vocabulary term does not appear in the example string, and a value of 1 if it does. Terms in an example that don't appear in the vocabulary are thrown away.
#it gets each word of the review, set it as item of a dict and put a 1 value for that item 
# =============================================================================

def _parse_function(record):
  """Extracts features and labels.
  
  Args:
    record: File path to a TFRecord file    
  Returns:
    A `tuple` `(labels, features)`:
      features: A dict of tensors representing the features
      labels: A tensor with the corresponding labels.
  """
  features = {
    "terms": tf.VarLenFeature(dtype=tf.string), # terms are strings of varying lengths
    "labels": tf.FixedLenFeature(shape=[1], dtype=tf.float32) # labels are 0 or 1
  } #shape: number of dimensions
  
  parsed_features = tf.parse_single_example(record, features)
  
  terms = parsed_features['terms'].values
  labels = parsed_features['labels']

#'terms' will be the word string
#terms will be value 1
#labels will be the target value of the review for those set of words¿?
  return  {'terms':terms}, labels


# =============================================================================
# To confirm our function is working as expected, let's construct a TFRecordDataset for the training data, and map the data to features and labels using the function above.
# =============================================================================
  
# Create the Dataset object.
ds = tf.data.TFRecordDataset(train_path)
# Map features and labels with the parse function.
ds = ds.map(_parse_function)

ds

# =============================================================================
# Run the following cell to retrieve the first example from the training data set.
# =============================================================================

n = ds.make_one_shot_iterator().get_next()
sess = tf.Session()
sess.run(n)

# =============================================================================
# Now, let's build a formal input function that we can pass to the train() method of a TensorFlow Estimator object.
# =============================================================================

# Create an input_fn that parses the tf.Examples from the given files,
# and split them into features and targets.
def _input_fn(input_filenames, num_epochs=None, shuffle=True):
  
  # Same code as above; create a dataset and map features and labels.
  ds = tf.data.TFRecordDataset(input_filenames)
  ds = ds.map(_parse_function)

  if shuffle:
    ds = ds.shuffle(10000)

  # Our feature data is variable-length, so we pad and batch
  # each field of the dataset structure to whatever size is necessary.
  ds = ds.padded_batch(25, ds.output_shapes)
  
  ds = ds.repeat(num_epochs)

  
  # Return the next batch of data.
  features, labels = ds.make_one_shot_iterator().get_next()
  return features, labels


# =============================================================================
# TASK 1: Use a Linear Model with Sparse Inputs and an Explicit Vocabulary
# =============================================================================

# =============================================================================
# For our first model, we'll build a LinearClassifier model using 50 informative terms; always start simple!
# 
# The following code constructs the feature column for our terms. The categorical_column_with_vocabulary_list function creates a feature column with the string-to-feature-vector mapping.
  
##THIS ARE MY FEATURES FOR THE MODEL
# =============================================================================
# 50 informative terms that compose our model vocabulary 
informative_terms = ("bad", "great", "best", "worst", "fun", "beautiful",
                     "excellent", "poor", "boring", "awful", "terrible",
                     "definitely", "perfect", "liked", "worse", "waste",
                     "entertaining", "loved", "unfortunately", "amazing",
                     "enjoyed", "favorite", "horrible", "brilliant", "highly",
                     "simple", "annoying", "today", "hilarious", "enjoyable",
                     "dull", "fantastic", "poorly", "fails", "disappointing",
                     "disappointment", "not", "him", "her", "good", "time",
                     "?", ".", "!", "movie", "film", "action", "comedy",
                     "drama", "family")

terms_feature_column = tf.feature_column.categorical_column_with_vocabulary_list(key="terms", vocabulary_list=informative_terms)

# =============================================================================
# Next, we'll construct the LinearClassifier, train it on the training set, and evaluate it on the evaluation set. After you read through the code, run it and see how you do.

##NOW WE TRAIN, I TAKE FOR EACH EXAMPLE THE VALUE OF EACH FEATURE, IF I SEARCH A FEATURE AND IT IS NOT IN THAT REVIEW, IT WILL HAVE A 0 VALUE IN THAT FEATURE TERM. THE TARGET IS ALREADY IN THE DATA, IS 0 OR 1 DEPENDING ON IF IT IS A POSITIVE OR NEGATIVE REVIEW
# =============================================================================
my_optimizer = tf.train.AdagradOptimizer(learning_rate=0.1)
my_optimizer = tf.contrib.estimator.clip_gradients_by_norm(my_optimizer, 5.0)

feature_columns = [ terms_feature_column ]


classifier = tf.estimator.LinearClassifier(
  feature_columns=feature_columns,
  optimizer=my_optimizer,
)

classifier.train(
  input_fn=lambda: _input_fn([train_path]),
  steps=1000)

evaluation_metrics = classifier.evaluate(
  input_fn=lambda: _input_fn([train_path]),
  steps=1000)
print("Training set metrics:")
for m in evaluation_metrics:
  print(m, evaluation_metrics[m])
print("---")

evaluation_metrics = classifier.evaluate(
  input_fn=lambda: _input_fn([test_path]),
  steps=1000)

print("Test set metrics:")
for m in evaluation_metrics:
  print(m, evaluation_metrics[m])
print("---")

# =============================================================================
# TASK 2: Use a Deep Neural Network (DNN) Model
# =============================================================================

# =============================================================================
#  now using a DNNClassifier for the LinearClassifier.
# =============================================================================
##################### Here's what we changed ##################################
classifier = tf.estimator.DNNClassifier(                                      #
  feature_columns=[tf.feature_column.indicator_column(terms_feature_column)], #
  hidden_units=[20,20],                                                       #
  optimizer=my_optimizer,                                                     #
)                                                                             #
###############################################################################

try:
  classifier.train(
    input_fn=lambda: _input_fn([train_path]),
    steps=1000)

  evaluation_metrics = classifier.evaluate(
    input_fn=lambda: _input_fn([train_path]),
    steps=1)
  print("Training set metrics:")
  for m in evaluation_metrics:
    print(m, evaluation_metrics[m])
  print("---")

  evaluation_metrics = classifier.evaluate(
    input_fn=lambda: _input_fn([test_path]),
    steps=1)

  print("Test set metrics:")
  for m in evaluation_metrics:
    print(m, evaluation_metrics[m])
  print("---")
except ValueError as err:
  print(err)

# =============================================================================
# TASK 3: Use an Embedding with a DNN Model
# =============================================================================
# =============================================================================
# we'll implement our DNN model using an embedding column. An embedding column takes sparse data as input and returns a lower-dimensional dense vector as output.
  #An embedding_column is usually the computationally most efficient option to use for training a model on sparse data. In an optional section at the end of this exercise, we'll discuss in more depth the implementational differences between using an embedding_column and an indicator_column, and the tradeoffs of selecting one over the other.
# =============================================================================

# =============================================================================
# In the following code, do the following:

    #Define the feature columns for the model using an embedding_column that projects the data into 2 dimensions (see the            TF docs for more details on the function signature for embedding_column).
    #Define a DNNClassifier with the following specifications:
    #Two hidden layers of 20 units each
    #Adagrad optimization with a learning rate of 0.1
    #A gradient_clip_norm of 5.0

##IMPORTANT, in our case, the embedding is a matrix that allows us to project a 50-dimensional vector down to 2 dimensions.
# =============================================================================





########################## SOLUTION CODE ########################################
terms_embedding_column = tf.feature_column.embedding_column(terms_feature_column, dimension=2)
feature_columns = [ terms_embedding_column ]

my_optimizer = tf.train.AdagradOptimizer(learning_rate=0.1)
my_optimizer = tf.contrib.estimator.clip_gradients_by_norm(my_optimizer, 5.0)

classifier = tf.estimator.DNNClassifier(
  feature_columns=feature_columns,
  hidden_units=[20,20],
  optimizer=my_optimizer
)
#################################################################################

classifier.train(
  input_fn=lambda: _input_fn([train_path]),
  steps=1000)

evaluation_metrics = classifier.evaluate(
  input_fn=lambda: _input_fn([train_path]),
  steps=1000)
print("Training set metrics:")
for m in evaluation_metrics:
  print(m, evaluation_metrics[m])
print("---")

evaluation_metrics = classifier.evaluate(
  input_fn=lambda: _input_fn([test_path]),
  steps=1000)

print("Test set metrics:")
for m in evaluation_metrics:
  print(m, evaluation_metrics[m])
print("---")


# =============================================================================
# The above model used an embedding_column, and it seemed to work, but this doesn't tell us much about what's going on internally. How can we check that the model is actually using an embedding inside?

#To start, let's look at the tensors in the model:
# =============================================================================

a=classifier.get_variable_names()


# =============================================================================
# Okay, we can see that there is an embedding layer in there: 'dnn/input_from_feature_columns/input_layer/terms_embedding/...'. (What's interesting here, by the way, is that this layer is trainable along with the rest of the model just as any hidden layer is.)

#Is the embedding layer the correct shape? Run the following code to find out.
# =============================================================================


b=classifier.get_variable_value('dnn/input_from_feature_columns/input_layer/terms_embedding/embedding_weights').shape

# =============================================================================
# Spend some time manually checking the various layers and shapes to make sure everything is connected the way you would expect it would be.
# =============================================================================

# =============================================================================
# TASK 5: EXAMINE THE EMBEDDING
# =============================================================================
# =============================================================================
# Let's now take a look at the actual embedding space, and see where the terms end up in it. Do the following:

#Run the following code to see the embedding we trained in Task 3. Do things end up where you'd expect?

#Re-train the model by rerunning the code in Task 3, and then run the embedding visualization below again. What stays the same? What changes?

#Finally, re-train the model again using only 10 steps (which will yield a terrible model). Run the embedding visualization below again. What do you see now, and why?
# =============================================================================
print('mira hasta aqui')

# =============================================================================
# ITS AMAZING, HERE YOU CAN SEE HOW IT PLACES THE WORDS IN 2D, (Y AND X AXIS ONLY), AND IT DOES IT QUITE GOOD, BAD TYPICAL REVIEW WORDS ARE PLACED CLOSEST TO EACH OTHER AND GOOD WORDS TO GOOD WORDS, THEN APPART THERE ARE WORDS THAT DOESNT ADD ANYTHING. IF WE TRAIN WITH 10 STEPS INSTEAD OF WITH 1000 STEPS (CHANGING IT IN TASK 3) AND SEE THIS FIGURE AGAIN, WE SEE THAT IT REDUCES THE DIMENSIONS WORSE, SOME BAD WORDS ARE MIXED WITH GOOD WORDS.
#BEFORE EACH WORD WAS AN AXES, NOW AXES HAVE A NEW MEANING NOT PHYSICAL. THE DISTANCE BETWEEN WORDS AND THE DIRECTION IS WHAT IT MEANS NOW.
# =============================================================================
import numpy as np
import matplotlib.pyplot as plt

embedding_matrix = classifier.get_variable_value('dnn/input_from_feature_columns/input_layer/terms_embedding/embedding_weights')

for term_index in range(len(informative_terms)):
  # Create a one-hot encoding for our term. It has 0s everywhere, except for
  # a single 1 in the coordinate that corresponds to that term.
  term_vector = np.zeros(len(informative_terms))
  term_vector[term_index] = 1
  # We'll now project that one-hot vector into the embedding space.
  embedding_xy = np.matmul(term_vector, embedding_matrix)
  plt.text(embedding_xy[0],
           embedding_xy[1],
           informative_terms[term_index])

# Do a little setup to make sure the plot displays nicely.
plt.rcParams["figure.figsize"] = (15, 15)
plt.xlim(1.2 * embedding_matrix.min(), 1.2 * embedding_matrix.max())
plt.ylim(1.2 * embedding_matrix.min(), 1.2 * embedding_matrix.max())
plt.show() 

# =============================================================================
# Task 6: Try to improve the model's performance
# =============================================================================
# =============================================================================
# See if you can refine the model to improve performance. A couple things you may want to try:

#Changing hyperparameters, or using a different optimizer like Adam (you may only gain one or two accuracy percentage points following these strategies).
#Adding additional terms to informative_terms. There's a full vocabulary file with all 30,716 terms for this data set that you can use at: https://download.mlcc.google.com/mledu-datasets/sparse-data-embedding/terms.txt You can pick out additional terms from this vocabulary file, or use the whole thing via the categorical_column_with_vocabulary_file feature column.
# =============================================================================
# Download the vocabulary file.
terms_url = 'https://download.mlcc.google.com/mledu-datasets/sparse-data-embedding/terms.txt'
terms_path = tf.keras.utils.get_file(terms_url.split('/')[-1], terms_url)

# Create a feature column from "terms", using a full vocabulary file.
informative_terms = None
with io.open(terms_path, 'r', encoding='utf8') as f:
  # Convert it to a set first to remove duplicates.
  informative_terms = list(set(f.read().split()))
  
terms_feature_column = tf.feature_column.categorical_column_with_vocabulary_list(key="terms", 
                                                                                 vocabulary_list=informative_terms)

terms_embedding_column = tf.feature_column.embedding_column(terms_feature_column, dimension=2)
feature_columns = [ terms_embedding_column ]

my_optimizer = tf.train.AdagradOptimizer(learning_rate=0.1)
my_optimizer = tf.contrib.estimator.clip_gradients_by_norm(my_optimizer, 5.0)

classifier = tf.estimator.DNNClassifier(
  feature_columns=feature_columns,
  hidden_units=[10,10],
  optimizer=my_optimizer
)

classifier.train(
  input_fn=lambda: _input_fn([train_path]),
  steps=1000)

evaluation_metrics = classifier.evaluate(
  input_fn=lambda: _input_fn([train_path]),
  steps=1000)
print("Training set metrics:")
for m in evaluation_metrics:
  print(m, evaluation_metrics[m])
print("---")

evaluation_metrics = classifier.evaluate(
  input_fn=lambda: _input_fn([test_path]),
  steps=1000)

print("Test set metrics:")
for m in evaluation_metrics:
  print(m, evaluation_metrics[m])
print("---")

# =============================================================================
# A Final Word (WHY SOMETIMES DNN ARE NOT NEEDED)
# We may have gotten a DNN solution with an embedding that was better than our original linear model, but the linear model was also pretty good and was quite a bit faster to train. Linear models train more quickly because they do not have nearly as many parameters to update or layers to backprop through.
# 
# In some applications, the speed of linear models may be a game changer, or linear models may be perfectly sufficient from a quality standpoint. In other areas, the additional model complexity and capacity provided by DNNs might be more important. When defining your model architecture, remember to explore your problem sufficiently so that you know which space you're in.
# =============================================================================
# =============================================================================
# Optional Discussion: Trade-offs between embedding_column and indicator_column

 #summary: in one hot encoding: when we want words that dont appear (they have 0 value) to count as something to shape our weigths, we use indicator_column, however the number of weights to be shaped for each example increases.
 #if we only want to shape the weights of words that appear in each example (diff for each) use embedding_column
 #this summary is only for DNNClassifier, because in LinearClassifier you cant choose to use embedding_column
 
 
 
 
#Conceptually when training a LinearClassifier or a DNNClassifier, there is an adapter needed to use a sparse column. TF provides two options: embedding_column or indicator_column.

#When training a LinearClassifier (as in Task 1), an embedding_column in used under the hood (it's always used embedding, you can't choose). As seen in Task 2, when training a DNNClassifier, you must explicitly choose either embedding_column or indicator_column. This section discusses the distinction between the two, and the trade-offs of using one over the other, by looking at a simple example.

#Suppose we have sparse data containing the values "great", "beautiful", "excellent". Since the vocabulary size we're using here is  V=50 , each unit (neuron) in the first layer will have 50 weights. We denote the number of terms in a sparse input using  s . So for this example sparse data,  s=3 . For an input layer with  V  possible values, a hidden layer with  d  units needs to do a vector-matrix multiply:  (1×V)∗(V×d) . This has  O(V∗d)  computational cost. Note that this cost is proportional to the number of weights in that hidden layer and independent of  s .

#If the inputs are one-hot encoded (a Boolean vector of length  V  with a 1 for the terms present and a 0 for the rest) using an indicator_column, this means multiplying and adding a lot of zeros.

#When we achieve the exact same results by using an embedding_column of size  d , we look up and add up just the embeddings corresponding to the three features present in our example input of "great", "beautiful", "excellent":  (1×d)+(1×d)+(1×d) . Since the weights for the features that are absent are multiplied by zero in the vector-matrix multiply, they do not contribute to the result. Weights for the features that are present are multiplied by 1 in the vector-matrix multiply. Thus, adding the weights obtained via the embedding lookup will lead to the same result as in the vector-matrix-multiply.

#When using an embedding, computing the embedding lookup is an  O(s∗d)  computation, which is computationally much more efficient than the  O(V∗d)  cost for the indicator_column in sparse data for which  s  is much smaller than  V . (Remember, these embeddings are being learned. In any given training iteration it is the current weights that are being looked up.)

#As we saw in Task 3, by using an embedding_column in training the DNNClassifier, our model learns a low-dimensional representation for the features, where the dot product defines a similarity metric tailored to the desired task. In this example, terms that are used similarly in the context of movie reviews (e.g., "great" and "excellent") will be closer to each other the embedding space (i.e., have a large dot product), and terms that are dissimilar (e.g., "great" and "bad") will be farther away from each other in the embedding space (i.e., have a small dot product).
# =============================================================================
