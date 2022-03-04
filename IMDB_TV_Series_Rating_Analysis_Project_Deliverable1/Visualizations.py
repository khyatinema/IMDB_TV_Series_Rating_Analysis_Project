import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df=pd.read_csv(r'/Users/kushal/Downloads/imdbseries.csv')
df

#df['Average Episodes/season']=pd.to_numeric(df['Average Episodes/season'])
df.dtypes

# Plot
plt.figure(figsize=(20,20))
plt.scatter(df['Average Episodes/season'], df['Rating'], alpha=0.5, )
plt.title('Scatter plot pythonspot.com')
plt.xlabel('Average Episodes/season')
plt.ylabel('Rating')


m, b = np.polyfit(df['Average Episodes/season'], df['Rating'], 1)
plt.plot(df['Average Episodes/season'], m*df['Average Episodes/season'] + b)
plt.show()

import seaborn as sns
plt.figure(figsize=(24,4))
sns.lmplot(x='Average Episodes/season',
            y='Rating', 
            ci=None,
            data=df,height=7, aspect=1.6);

import seaborn as sns
plt.figure(figsize=(24,4))
sns.lmplot(x='Avg_runtime',
            y='Rating', 
            ci=None,
            data=df,height=7, aspect=1.6);

import seaborn as sns
plt.figure(figsize=(24,4))
sns.lmplot(x='Number_of_seasons',
            y='Rating', 
            ci=None,
            data=df,height=7, aspect=1.6,palette=dict(Yes="g", No="m"));

fig = plt.figure(figsize=(10,8))
ax = fig.add_axes([0,0,1,1])
ax.bar(df['Genre'],df['Rating'])
plt.show()

df['Genre'].value_counts().plot(kind='bar')

import seaborn as sns
plt.figure(figsize=(24,4))
sns.lmplot(x='Number_of_reviews',
            y='Rating', 
            ci=None,
            data=df,height=7, aspect=1.6,palette=dict(Yes="g", No="m"));

import seaborn as sns
plt.figure(figsize=(24,4))
sns.lmplot(x='Number_of_critics_review',
            y='Rating', 
            ci=None,
            data=df,height=7, aspect=1.6,palette=dict(Yes="g", No="m"));

import seaborn as sns
plt.figure(figsize=(24,4))
sns.lmplot(x='Number_of_raters',
            y='Rating', 
            ci=None,
            data=df,height=7, aspect=1.6,palette=dict(Yes="g", No="m"));

res = df['Year_released'].count()

fig = plt.figure(figsize=(10,8))
ax = fig.add_axes([0,0,1,1])
ax.bar(df['Year_released'],df['Rating'])
plt.ylim(8,10)
plt.xlabel('Release year')
plt.ylabel('rating')
plt.show()

import matplotlib
matplotlib.rc_file_defaults()
ax1 = sns.set_style(style=None, rc=None )

fig, ax1 = plt.subplots(figsize=(12,6))

#sns.lineplot(data = df['Rating'], marker='o', sort = False, ax=ax1)
ax2 = ax1.twinx()

sns.barplot(data = df, x='Year_released', y='Rating', alpha=0.5, ax=ax2)

sns.tsplot(df['Year_released'],df['Rating'])

ax = plt.subplot(111)
ax.plot(df['Year_released'],df['Rating'], color='r')

plt.show()

df.dtypes

df.describe()

df1=df['Genre']
df1.describe()

boxplot = df.boxplot(column=['Number_of_episodes', 'Number_of_seasons', 'Year_released','Avg_runtime','Rating','Number_of_reviews','Number_of_critics_review','Average Episodes/season'],figsize=(20,10))


