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
df_data['Difference'] = df_data['Offer'] - df_data['SellingPrice']

#%%
ax = sns.factorplot(data = df_data,y='Offer',x='SellingPrice',hue='Product',col='OfferMade',kind='bar')

ax = sns.FacetGrid(data=df_data,hue='OfferMade')
ax = (ax.map(plt.scatter,'SellingPrice','Offer',s=10*df_data['SellingPrice'].astype(int))).add_legend()

ax = sns.stripplot(data=df_data,x='SellingPrice',y='Offer',hue='OfferMade',split=True)

ax = sns.lmplot(data=df_data,x='Offer',y='Difference')
