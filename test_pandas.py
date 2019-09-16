import pandas as pd
import numpy as np
import sys
s = pd.read_csv(sys.argv[1],sep = "\t")
print(s.shape[0]) #Return the number of row
print(s.shape[1]) #Return the number of column 
#rint(s.head(5)) # Return the top X rows of the datafrmae
#print(s.tail(5)) #Return the bottom X rows of the dataframe
#print(s.describe())
#print(s.info())
print(s[1:3])
print(s.loc[[1,2,4,6,8]]) # The ".loc" can select some incontinuity rows from the dataframe]
for i in s.shape[1]:
    print i