"""
Created on Wed Jul  6 17:35:51 2016

@author: burksa
"""

#%% Importing Relevant Libraries
import pandas as pd
import numpy as np
from pylab import *
import seaborn as sns
import matplotlib.pyplot as plt
import scipy as sp

#%% Extracting data from csv file

df_original = pd.read_excel('C:\\Users\\burksa\\Documents\\Python Scripts\\Venndor\\Exploratory Analysis\\Analytics Sheets.xlsx'
                        ,'Market tests')
                        
#%% Cleaning up the data set
# Removing information past line 174
df_market = df_original[df_original.index < 172].drop('Timestamp',axis=1)
fan_idx = np.array(np.where(df_market.columns.values == 'Fan'))
sellers_price = pd.DataFrame(df_original.iloc[174,np.arange(1,fan_idx+2)].dropna())
sellers_price.reset_index(level=0,inplace=True)
df_market = df_market[df_market.columns[np.arange(fan_idx+1)]]

sellers_price.columns.values[[0,1]] = ['Product','SellingPrice']


#%% Replacing missing values
# Since we have missing data (because people didn't want to purchase the product)
# we have to make do with filling in that data with the average of the column
df_market = (df_market.apply(pd.to_numeric,errors='coerce')).fillna(df_market.mean())
df_market_melt = pd.melt(df_market)
df_data = pd.merge(df_market_melt,sellers_price,left_on='variable',right_on='Product',how='left').drop('variable',axis=1)
df_data.rename(columns={'value':'Offer'},inplace=True)
df_data['OfferMade'] = df_data['Offer'] >= df_data['SellingPrice']
df_data['Profit'] = (df_data['Offer'] - df_data['SellingPrice'])*0.1

# Discritizing the product prices into 3 categories
bins = np.linspace(df_data['SellingPrice'].min(),df_data['SellingPrice'].max(),4)
df_data['PricePoints'] = pd.cut(df_data['SellingPrice'],bins,labels=['Low','Med','High'],include_lowest=True).astype('str')
df_data['PriceRatio'] = df_data['Profit'].div(df_data['SellingPrice'])

df_grouped = df_data[['SellingPrice','Profit']].astype('float').groupby('SellingPrice',as_index=False).aggregate(np.mean)
#%%
ax = sns.factorplot(data = df_data,y='Offer',x='SellingPrice',hue='Product',col='OfferMade',kind='bar')

ax = sns.FacetGrid(data=df_data,hue='OfferMade')
ax = (ax.map(plt.scatter,'SellingPrice','Offer',s=10*df_data['SellingPrice'].astype(int))).add_legend()

ax = sns.stripplot(data=df_data,x='SellingPrice',y='Profit',hue='OfferMade',split=True)

# Linear Regression Plot
ax = sns.lmplot(data=df_grouped,x='SellingPrice',y='Profit')
linReg=np.array(sp.stats.linregress(x=df_grouped['SellingPrice'] ,y=df_grouped['Profit']))
regressionSummary = pd.DataFrame(,columns=[['Slope','Int','RValue','Pvalue','Stderr']])

ax = sns.FacetGrid(data=df_data,hue='Product')
ax = ax.map(plt.hist,'Profit',alpha=0.5).add_legend()

ax = sns.boxplot(data=df_data,x='PricePoints',y='Profit',order=['Low','Med','High'],linewidth=4)

# Distributions of Offers
ax = sns.FacetGrid(data=df_data,hue='PricePoints')
ax = ax.map(sns.kdeplot
            ,'Offer'
            #,bins=np.arange(len( set( df_data['PriceRatio'] ) )+1)-0.5
            ,shade=True
            ,linewidth=5).add_legend()
plt.xlabel('Offer Value',fontsize=20)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.title('KDE Distribution of Offer Value',fontsize=20)


# KDE Distributions of Price Ratio
ax = sns.FacetGrid(data=df_data,hue='PricePoints')
ax = ax.map(sns.kdeplot
            ,'PriceRatio'
            #,bins=np.arange(len( set( df_data['PriceRatio'] ) )+1)-0.5
            ,shade=True
            ,linewidth=5).add_legend()
plt.xlabel('Price Ratio',fontsize=20)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.title('KDE Distribution of Price Ratios',fontsize=20)

