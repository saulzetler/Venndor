# -*- coding: utf-8 -*-
"""
Created on Sun Aug 14 16:38:14 2016

@author: burksa
"""

from flask import Flask, jsonify
import pandas as pd
import requests
#%%
def getItems(url):
    response = requests.get(url)
    response_dict = response.json()
    return(response_dict)

#%%
api_key = '58bbaee4c53d3643eb0c01211ed537b8ba3bae6d9269503ae1c55916e75f47f2'

url_items = 'http://bitnami-dreamfactory-000b.cloudapp.net/api/v2/venndor/_table/items?api_key=' + api_key
url_matches = 'http://bitnami-dreamfactory-000b.cloudapp.net/api/v2/venndor/_table/matches?api_key=' + api_key
url_posts = 'http://bitnami-dreamfactory-000b.cloudapp.net/api/v2/venndor/_table/posts?api_key=' + api_key
url_seenPosts = 'http://bitnami-dreamfactory-000b.cloudapp.net/api/v2/venndor/_table/seenPosts?api_key=' + api_key
url_users = 'http://bitnami-dreamfactory-000b.cloudapp.net/api/v2/venndor/_table/users?api_key=' + api_key

#%%
response_items = getItems(url_items)
response_matches = getItems(url_matches)
response_posts = getItems(url_posts)
response_seenPosts = getItems(url_seenPosts)
response_users = getItems(url_users)


#%%
df = pd.DataFrame(response_items['resource'])
match_ids = df['matches']
df_matches = pd.DataFrame(response_matches['resource'])



