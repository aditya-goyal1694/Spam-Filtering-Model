# Spam Filtering Model
## Overview
This project implements a spam filtering model using the Naive Bayes Theorem to classify SMS messages as either "spam" or "ham." The model is built in R and utilizes text mining techniques for data preprocessing and analysis.

## Dataset
The dataset used is sms_spam.csv, which contains SMS messages labeled as "spam" or "ham."

Libraries Used
- tm: For text mining and handling text data.
- SnowballC: For stemming words to their root form.
- e1071: For implementing the Naive Bayes algorithm.
- wordcloud: For visualizing word frequency.
- Getting Started

## Prerequisites
Ensure you have the following R packages installed: tm, SnowballC, e1071, and wordcloud.

## Loading the Data
Load the dataset into R for analysis and exploration.

## Data Pre-processing
Convert the message type to a factor and create a corpus from the SMS text data. Clean the corpus by lowercasing the text, removing numbers, stop words, and punctuation, and applying stemming and whitespace stripping.

## Tokenization
Create a Document-Term Matrix (DTM) and split the data into training and testing sets.

## Creating a Word Cloud
Visualize the most frequent words in the SMS messages to gain insights into common terms.

## Feature Selection
Identify and select frequent words to update the training and testing data.

## Applying Naive Bayes
Convert the text data into categorical format and apply the Naive Bayes classifier to train the model and make predictions.

## Model Performance
Evaluate the model's performance using a cross-table to compare predicted and actual classifications.

## Conclusion
This model effectively classifies SMS messages into spam and ham categories using the Naive Bayes Theorem, demonstrating the power of machine learning in text classification tasks.
