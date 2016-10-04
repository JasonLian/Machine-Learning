# coding:utf8

## == Lesson 1: Download and Install Python and SciPy Ecosystem ==
# Python version

# import sys
# print('Python: {}'.format(sys.version))
# # scipy
# import scipy
# print('scipy: {}'.format(scipy.__version__))
# # numpy
# import numpy
# print('numpy: {}'.format(numpy.__version__))
# # matplotlib
# import matplotlib
# print('matplotlib: {}'.format(matplotlib.__version__))
# # pandas
# import pandas
# print('pandas: {}'.format(pandas.__version__))
# # scikit-learn
# import sklearn
# print('sklearn: {}'.format(sklearn.__version__))


## == Lesson 2: Get Around In Python, NumPy, Matplotlib and Pandas ==

# import numpy
# import pandas
# myarray = numpy.array([[1, 2, 3], [4, 5, 6]])
# rownames = ['a', 'b']
# colnames = ['one', 'two', 'three']
# mydataframe = pandas.DataFrame(myarray, index=rownames, columns=colnames)
# print(mydataframe)


## == Lesson 3: Load Data From CSV ==

# Load CSV using Pandas from URL
# import pandas
# # url = "https://goo.gl/vhm1eU"
# names = ['preg', 'plas', 'pres', 'skin', 'test', 'mass', 'pedi', 'age', 'class']
# data = pandas.read_csv('sample.csv', names=names)
# print(data.shape)

## == Lesson 4: Understand Data with Descriptive Statistics ==

# Statistical Summary
# import pandas
# # url = "https://goo.gl/vhm1eU"
# names = ['preg', 'plas', 'pres', 'skin', 'test', 'mass', 'pedi', 'age', 'class']
# data = pandas.read_csv('sample.csv', names=names)
# description = data.describe()
# print(description)

## == Lesson 5: Understand Data with Visualization ==

# Scatter Plot Matrix
# import matplotlib.pyplot as plt
# import pandas
# from pandas.tools.plotting import scatter_matrix
# names = ['preg', 'plas', 'pres', 'skin', 'test', 'mass', 'pedi', 'age', 'class']
# data = pandas.read_csv('sample.csv', names=names)
# scatter_matrix(data)
# plt.show()


## == Lesson 6: Prepare For Modeling by Pre-Processing Data ==

# Standardize data (0 mean, 1 stdev)
# from sklearn.preprocessing import StandardScaler
# import pandas
# import numpy
# names = ['preg', 'plas', 'pres', 'skin', 'test', 'mass', 'pedi', 'age', 'class']
# dataframe = pandas.read_csv('sample.csv', names=names)
# array = dataframe.values
# print(array)
# # separate array into input and output components
# X = array[:,0:8]
# Y = array[:,8]
# scaler = StandardScaler().fit(X)
# rescaledX = scaler.transform(X)
# # summarize transformed data
# numpy.set_printoptions(precision=3)
# print(rescaledX[0:5,:])


## == Lesson 7: Algorithm Evaluation With Resampling Methods ==

# Evaluate using Cross Validation
import pandas
from sklearn import cross_validation
from sklearn.linear_model import LogisticRegression
names = ['preg', 'plas', 'pres', 'skin', 'test', 'mass', 'pedi', 'age', 'class']
dataframe = pandas.read_csv('sample.csv', names=names)
array = dataframe.values
X = array[:,0:8]
Y = array[:,8]
num_folds = 10
num_instances = len(X)
seed = 7
kfold = cross_validation.KFold(n=num_instances, n_folds=num_folds, random_state=seed)
model = LogisticRegression()
results = cross_validation.cross_val_score(model, X, Y, cv=kfold)
print("Accuracy: %.3f%% (%.3f%%)") % (results.mean()*100.0, results.std()*100.0)

# chekc the coefficient of logit model
model = model.fit(X, Y)
print(model.coef_)