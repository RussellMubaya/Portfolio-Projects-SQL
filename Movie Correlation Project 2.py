#!/usr/bin/env python
# coding: utf-8

# In[1]:


#import libraries 
import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjusts the configuartion of the plots we will make


# Read in the data
df = pd.read_csv(r'/Users/russellmubaya/Desktop/movies.csv')


# In[2]:


# read the data
df.head()


# In[3]:


#Let's see if there is any missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[4]:


# Data types for our columns
df.dtypes


# In[6]:


# changing data type to remove unnecessary .0 in some columns(gross and budget)

df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')


# In[7]:


df.head()


# In[8]:


# Create correct year column

df['yearcorrect'] = df['released'].astype(str).str[:4]

df.head()


# In[9]:


# Sorting the inputs in descending order of the gross
df.sort_values(by=['gross'], inplace = False, ascending = False)


# In[10]:


# Modifying the scroll features
pd.set_option('display.max_rows', None)


# In[11]:


# Drop all duplicates in the entire data frame
df.drop_duplicates()


# In[ ]:


# I estimate the budget will have high correlations to the revenue
# I estimate the company will have the same impact as well


# In[12]:


# To check my assumptions, I scatter a plot for budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earning')

plt.xlabel('Budget for film')
plt.ylabel('Gross Earnings')


plt.show()


# In[13]:


# I make plot more clear

sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color":"red"}, line_kws={"color":"blue"})

# As we can see from the line, our suspicion is vindicated and the there truly is a correlation between the budget and the revenue generated from it.(it shows that the more budget put in a film, the greater the revenue generated). 
# This doesn't mean that the budget alone is conducive for the profits. There may be other factor to that come into play 


# In[14]:


# Finding out to what extent it correlate using pearson

df.corr(method='pearson')


# In[15]:


# I produce a heat map to make it correlations more informative in the form of a correlation matrix

correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.show()


# In[16]:


# I make the matrix more readable

correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie features')
plt.ylabel('Movie feature')

plt.show()


# In[17]:


# Numerizing company to prep. it for the matrix. 

df_numerized = df
for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized



# In[18]:


#Now that the company has been numerized, i add it to the matrix

correlation_matrix = df_numerized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie features')
plt.ylabel('Movie feature')

plt.show() 


# In[20]:


# Repressenting the correlations via analog

correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[21]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[22]:


#Analysing the relevant correlations

high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr


# In[ ]:


# As we can see from the data, the budget does have a high correlation with the gross revenue. The company, however,  doesn't have large correlations with anything.
# I was wrong in my assumption that the company would has high correlations

