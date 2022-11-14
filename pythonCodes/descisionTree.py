import pandas
from sklearn import *
from numpy import *
from sklearn.metrics import *
import numpy

df = pandas.read_csv("DataRaw.csv")

X = df[['Window Size', 'Packet Size']]
Y1 = df['Packet Delivery Ratio']
Y2 = df['Dropped Packets']
Y3 = df['Avg Throughput']
Y4 = df['Avg End to End Delay']

regr1 = tree.DecisionTreeRegressor(max_depth=5)
regr2 = tree.DecisionTreeRegressor(max_depth=5)
regr3 = tree.DecisionTreeRegressor(max_depth=5)
regr4 = tree.DecisionTreeRegressor(max_depth=5)

regr1.fit(X.values, Y1)
regr2.fit(X.values, Y2)
regr3.fit(X.values, Y3)
regr4.fit(X.values, Y4)

wSize = [20, 30, 40, 50, 60]
pSize = [1000, 1010, 1020, 1030, 1040, 1050, 1060, 1070, 1080, 1090]

#Predicted Values
predictedPDRList = []
predictedDPList = []
predictedThptList = []
predictedETEDList = []
for i in wSize:
    for j in pSize:
        predictedPDR = regr1.predict([[i, j]])
        predictedPDRList.append(predictedPDR)
        predictedDP = regr2.predict([[i, j]])
        predictedDPList.append(predictedDP)
        predictedThpt = regr3.predict([[i, j]])
        predictedThptList.append(predictedThpt)
        predictedETED = regr4.predict([[i, j]])
        predictedETEDList.append(predictedETED)

#Converting to list
predictedPDRList = [prod(x) for x in predictedPDRList]
predictedDPList = [prod(x) for x in predictedDPList]
predictedThptList = [prod(x) for x in predictedThptList]
predictedETEDList = [prod(x) for x in predictedETEDList]

#Actual Values List
actualPDRList = df['Packet Delivery Ratio'].tolist()
actualDPList = df['Dropped Packets'].tolist()
actualThptList = df['Avg Throughput'].tolist()
actualETEDList = df['Avg End to End Delay'].tolist()


#PDR
print("\n")
print("Packet Delivery Ratio - ")
print("Mean Absolute Error: ", mean_absolute_error(actualPDRList, predictedPDRList))
print("Mean Square Error: ", numpy.square(numpy.subtract(actualPDRList, predictedPDRList)).mean())
print("Root Mean Square Error: ", math.sqrt(numpy.square(numpy.subtract(actualPDRList, predictedPDRList)).mean()))
print("Maximum Error: ", max_error(actualPDRList, predictedPDRList))

#Dropped Packets
print("\n")
print("Dropped Packets - ")
print("Mean Absolute Error: ", mean_absolute_error(actualDPList, predictedDPList))
print("Mean Square Error: ", numpy.square(numpy.subtract(actualDPList, predictedDPList)).mean())
print("Root Mean Square Error: ", math.sqrt(numpy.square(numpy.subtract(actualDPList, predictedDPList)).mean()))
print("Maximum Error: ", max_error(actualDPList, predictedDPList))

#Average Throughput
print("\n")
print("Average Throughput - ")
print("Mean Absolute Error: ", mean_absolute_error(actualThptList, predictedThptList))
print("Mean Square Error: ", numpy.square(numpy.subtract(actualThptList, predictedThptList)).mean())
print("Root Mean Square Error: ", math.sqrt(numpy.square(numpy.subtract(actualThptList, predictedThptList)).mean()))
print("Maximum Error: ", max_error(actualThptList, predictedThptList))

#Average End to End Delay
print("\n")
print("Average End to End Delay - ")
print("Mean Absolute Error: ", mean_absolute_error(actualETEDList, predictedETEDList))
print("Mean Square Error: ", numpy.square(numpy.subtract(actualETEDList, predictedETEDList)).mean())
print("Root Mean Square Error: ", math.sqrt(numpy.square(numpy.subtract(actualETEDList, predictedETEDList)).mean()))
print("Maximum Error: ", max_error(actualETEDList, predictedETEDList))