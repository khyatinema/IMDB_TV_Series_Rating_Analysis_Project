import numpy as np 
import matplotlib.pyplot as plt
import seaborn as sns
import os
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.decomposition import LatentDirichletAllocation
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.decomposition import NMF
import nltk
from nltk.corpus import stopwords

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from sklearn.metrics import plot_confusion_matrix

#changing the working directory
os.getcwd()
os.chdir(r"C:\Users\Loksagar\Documents\RStudio for GIT\project-deliverable-1-kkkl")

#accessing the data
imdb_data = pd.read_csv('imdbposneg.csv')
imdb_data.columns

#Random Forest Classification

features = imdb_data['Keywords']
vectorizer = TfidfVectorizer(max_features=2500, min_df=7, max_df=0.8, stop_words=stop)
processed_features = vectorizer.fit_transform(features).toarray()

labels = imdb_data['pos_neg']

X_train, X_test, y_train, y_test = train_test_split(processed_features, labels, test_size=0.2, random_state=0)

text_classifier = RandomForestClassifier(n_estimators=200, random_state=0)
text_classifier.fit(X_train, y_train)

predictions = text_classifier.predict(X_test)

cm = confusion_matrix(y_test,predictions)
print(cm)

plot_confusion_matrix(text_classifier, X_test, y_test)

print(classification_report(y_test,predictions))