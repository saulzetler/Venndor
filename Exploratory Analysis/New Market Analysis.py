#  New Market Analysis


# Importing Relevant Libraries
import pandas as pd
import numpy as np
from pylab import *
import seaborn as sns
import matplotlib.pyplot as plt
import scipy as sp
import xlrd as xl
from sklearn import linear_model
from sklearn.feature_selection import RFE
from sklearn import cross_validation
from sklearn.metrics import confusion_matrix
from sklearn.utils import resample
from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import AdaBoostRegressor
from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import DecisionTreeRegressor
from sklearn.preprocessing import Imputer
from matplotlib.pyplot import cm
from itertools import cycle 

# Reading in CSV File
csv_path = 'C:/Users/burksa/Documents/Python Scripts/Venndor/Exploratory Analysis/BU F&FS market simulation (Responses).xlsx'

workbook = xl.open_workbook(csv_path)
sheets = workbook.sheet_names()
df = pd.read_excel(csv_path, sheets[1])
sellingPrice = df.iloc[31,:].drop(['Age','Gender','Race']).reset_index()
sellingPrice.columns = ['Product','Price']
df = df.iloc[0:29,:]
#%% Melting the original dataframe
price_columns = []
id_vars = []
for i in df.columns.values:
    if 'Price' in i:
        price_columns.append(i)
    else:
        id_vars.append(i)
df = pd.melt(df,id_vars=id_vars,value_vars=price_columns,value_name = 'Offer',var_name='Product')
df = pd.merge(df, sellingPrice, left_on='Product',right_on='Product')
df['Profit'] = 0.2*(df['Offer'] - df['Price'])
df['OfferMade'] = df['Profit'] > 0
df['Profit'][df['Profit']<0] = 0
df['Profit'] = df['Profit'].astype(float)


#%% Creating the distributions of each product
ax = sns.factorplot(data=df,x='Price',y='Offer',kind='box')
plt.grid('on')
step = 10
plt.yticks(np.arange(0,df['Offer'].max()+step,step=step),fontsize=15)
ax.set_xticklabels(fontsize=15)
plt.xlabel('Price',fontsize=20)
plt.ylabel('Offer',fontsize=20)
plt.title('Offer vs Price',fontsize=20)


ax = sns.factorplot(data=df,x='Price',y='Profit',kind='bar',ci=None
                ,linewidth=3,alpha=0.7)
plt.grid('on')
plt.xlabel('Price', fontsize=20)
plt.ylabel('Profit',fontsize=20)
plt.title('Profit vs Price',fontsize=20)
max_val = np.max(df[['Profit','Price']].groupby('Price').agg(np.mean))
step = np.ceil(max_val[0]/10)
yticks = (np.arange(0,max_val[0]+step,step=step))
ax.set_xticklabels(fontsize=15)
plt.yticks(yticks)
yticklabels = []
for i in yticks:
    yticklabels.append('$%i' %i)
ax.set_yticklabels(yticklabels,fontsize=15)

ax = sns.factorplot(data=df,x='Price',y='OfferMade',kind='bar',palette='Set2'
                    ,linewidth=3,alpha=0.7)
plt.xlabel('Price [$]',fontsize=20)
plt.ylabel('Percent of Offers Made [%]',fontsize=20)
plt.title('Percent of Offers Made at Varying Price Points',fontsize = 20)
plt.xticks(fontsize=20)
plt.yticks(np.arange(0,1.1,0.1))
ytick_labels = []
for i in np.arange(0,110,10):
    ytick_labels.append('%i%%' %i)
ax.set_yticklabels(ytick_labels,fontsize=20)

#ax = sns.lmplot(x='Price',y='OfferMade',data=df,logistic=True,hue='Age')


#%%
X= df[['Age','Price']]
dummy_vars = pd.get_dummies(df[['Gender','Race']])
X= pd.concat([X,dummy_vars],axis=1).fillna(X.mean())
y = df['OfferMade']
sample_weights = np.unique(y)


for i in np.arange(0,5):
    x_temp, y_temp = resample(X,y,random_state=0)
    if i == 0:
        x_resample = x_temp
        y_resample = y_temp
    else:
        x_resample = pd.concat([x_resample,x_temp])
        y_resample = pd.concat([y_resample,y_temp])

X = x_resample
y = y_resample

X_train, X_test, y_train, y_test = cross_validation.train_test_split(X,y,
                                             test_size=0.2,random_state=0)

AdaClass = AdaBoostClassifier(base_estimator = DecisionTreeClassifier(class_weight='balanced')
                              ,n_estimators = 300, random_state = 0)

AdaClass.fit(X_train,y_train)
ada_predict = AdaClass.predict(X_test)
AdaClass.score(X_test,y_test)

LogModel = linear_model.LogisticRegression(penalty='l1',C=10,class_weight='balanced')
LogModel.fit(X_train,y_train)
y_predict = LogModel.predict(X_test)

coef = LogModel.coef_

confus = confusion_matrix(y_test,y_predict)
confus_normal = 100*confus.astype(float) / confus.sum(axis=1)[:,np.newaxis]

fig = plt.figure()
ax= fig.add_subplot(111)
ax.imshow(confus_normal,interpolation='nearest',cmap='autumn')
ax.set_ylabel('True Label')
ax.set_xlabel('Predicted Label')
ax.text(0,0,'%2.2f%%'%(confus_normal[0,0])
        ,va='center'
        ,ha='center'
        ,bbox=dict(fc='w',boxstyle='round,pad=1'))
ax.text(1,0,'%2.2f%%'%(confus_normal[0,1])
        ,va='center'
        ,ha='center'
        ,bbox=dict(fc='w',boxstyle='round,pad=1'))
ax.text(0,1,'%2.2f%%'%(confus_normal[1,0])
        ,va='center'
        ,ha='center'
        ,bbox=dict(fc='w',boxstyle='round,pad=1'))     
ax.text(1,1,'%2.2f%%'%(confus_normal[1,1])
        ,va='center'
        ,ha='center'
        ,bbox=dict(fc='w',boxstyle='round,pad=1'))
ax.set_xticks([0,1])        
ax.set_xticklabels(['Offer Not Made','Offer Made'])        
ax.set_yticks([0,1])        
ax.set_yticklabels(['Offer Not Made','Offer Made'])
fig.suptitle('Confusion Matrix')  

confus_ada = confusion_matrix(y_test,ada_predict)
confus_normal_ada = 100*confus_ada.astype(float) / confus_ada.sum(axis=1)[:,np.newaxis]

fig = plt.figure()
ax= fig.add_subplot(111)
ax.imshow(confus_normal_ada,interpolation='nearest',cmap='autumn')
ax.set_ylabel('True Label')
ax.set_xlabel('Predicted Label')
ax.text(0,0,'%2.2f%%'%(confus_normal_ada[0,0])
        ,va='center'
        ,ha='center'
        ,bbox=dict(fc='w',boxstyle='round,pad=1'))
ax.text(1,0,'%2.2f%%'%(confus_normal_ada[0,1])
        ,va='center'
        ,ha='center'
        ,bbox=dict(fc='w',boxstyle='round,pad=1'))
ax.text(0,1,'%2.2f%%'%(confus_normal_ada[1,0])
        ,va='center'
        ,ha='center'
        ,bbox=dict(fc='w',boxstyle='round,pad=1'))     
ax.text(1,1,'%2.2f%%'%(confus_normal_ada[1,1])
        ,va='center'
        ,ha='center'
        ,bbox=dict(fc='w',boxstyle='round,pad=1'))
ax.set_xticks([0,1])        
ax.set_xticklabels(['Offer Not Made','Offer Made'])        
ax.set_yticks([0,1])        
ax.set_yticklabels(['Offer Not Made','Offer Made'])
fig.suptitle('Confusion Matrix AdaBoost')  


#%%
X= df[['Age','Price']]
dummy_vars = pd.get_dummies(df[['Gender','Race']])
X= pd.concat([X,dummy_vars],axis=1).fillna(X.mean())
y = df['Profit']


X_train, X_test, y_train, y_test = cross_validation.train_test_split(X,y,
                                             test_size=0.2,random_state=0)

AdaReg = AdaBoostRegressor(DecisionTreeRegressor(max_depth=5,max_features='auto')
                        ,n_estimators = 3000, random_state = 0)
AdaReg.fit(X_train,y_train)
AdaReg.score(X_train,y_train)
AdaReg.feature_importances_
pd.DataFrame(index=np.append(np.array(X_train.columns),['R Square']),data=np.append(AdaReg.feature_importances_,AdaReg.score(X_train,y_train))
            ,columns=['FeatureImportance']).to_csv('C:/Users/burksa/Documents/Python Scripts/Venndor/Exploratory Analysis/LogModelFeatureImp.csv')
ada_reg_predict = AdaReg.predict(X_test)

plt.figure()
color = cycle(cm.rainbow(np.linspace(0,1,20)))
for price, profit,predict in zip(X_test['Price'],y_test,ada_reg_predict):
    c = next(color)
    plt.scatter(x=price,y=profit,marker='*',c=c,s=450,linewidth=2,alpha=0.7) 
    plt.scatter(x=price,y=predict,marker='.',c=c,s=450,linewidth=2,alpha=0.7) 
plt.show()    



#train_score = []
#test_score = []
#max_depth_dict = {}
#max_depth = []
#for i in np.arange(1,10):
#    for j in np.arange(2,300,step=10):
#        ada_model = AdaBoostRegressor(DecisionTreeRegressor(max_depth=i,max_features='auto')
#                            ,n_estimators = j, random_state = 0)
#        ada_model.fit(X_train,y_train)
#        train_score.append(ada_model.score(X_train,y_train))
#        test_score.append(ada_model.score(X_test,y_test))
#        max_depth.append([j,ada_model.score(X_test,y_test)])
#    max_depth_dict[i] = max_depth
#np.max(test_score)
#plt.figure()
#plt.scatter(max_depth,train_score,c='r')
#plt.scatter(max_depth,test_score,c='b')
#plt.show()

