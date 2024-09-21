#Loading the data
sms_raw=read.csv("C:/Users/adity/Downloads/sms_spam.csv", stringsAsFactors = FALSE)
head(sms_raw)

#Data Pre-processing
str(sms_raw)

sms_raw$type=as.factor(sms_raw$type)   #Categorical data, hence as factor
str(sms_raw)

#Loading text mining to handle text data 
install.packages('tm')
library(tm)

#STEP 1: Creating a corpus, which is a collection of text documents.
#         2 types: Virtual - VCorpus() and Permament - PCorpus()

sms_corpus <-VCorpus(VectorSource(sms_raw$text))      #VectorSource is used bcuz the text data is already loaded in R.   
sms_corpus

as.character(sms_corpus[[1]])           #Reading the first document in corpus
lapply(sms_corpus[1:2], as.character)   #Reading the range of documents in corpus

sms_corpus_clean <- tm_map(sms_corpus, content_transformer(tolower))
#tm_map provide the method to apply the transformation 
#content_transformer() is a wrapper function to treat tolower as the transformation function

as.character(sms_corpus[[1]])
as.character(sms_corpus_clean[[1]])

sms_corpus_clean<-tm_map(sms_corpus_clean, removeNumbers)
sms_corpus_clean <- tm_map(sms_corpus_clean, removeWords, stopwords())
sms_corpus_clean <- tm_map(sms_corpus_clean, removePunctuation)

#STEP2: Stemming
#Reducing words to their root form in a process called stemming.

install.packages("SnowballC")
library(SnowballC)

sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)
#wordstemm() is applied only on a character vector, hence this

sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)

#STEP3: Tokenization
#Splitting the messages into individual components is called tokenization.

#Creating a Document Term Matrix (DTM) in which rows indicate documents (SMS messages) and columns indicate terms (words).
sms_dtm<- DocumentTermMatrix(sms_corpus_clean)

#STEP3: Splitting the data into train and test
sms_dtm_train <- sms_dtm[1:4169, ]
sms_dtm_test <- sms_dtm[4170:5559, ]

sms_train_labels <- sms_raw[1:4169, ]$type
sms_test_labels <- sms_raw[4170:5559, ]$type

#Checking the proportion of spam and ham in train and test data
prop.table(table(sms_train_labels))
prop.table(table(sms_test_labels))

#Creating a wordCloud
#A word cloud is a way to visually depict the frequency at which words appear in text data.
#Words appearing more often in the text are shown in a larger font, while less common terms are shown in smaller fonts.

install.packages("wordcloud")
library(wordcloud)

wordcloud(sms_corpus_clean, min.freq = 50, random.order = TRUE)
#random.order=FALSE will keep the bigger font text near the centre

#We're only going to use words that appears in atleast 5 documents for the model training
sms_freq_words <- findFreqTerms(sms_dtm_train, 5)   #present in tm package
str(sms_freq_words)

#updating the train and test data based on frequent words 
sms_dtm_freq_train<- sms_dtm_train[ , sms_freq_words]
sms_dtm_freq_test <- sms_dtm_test[ , sms_freq_words]

#Naive-Bayes Theorem is applied on categorical data, hence converting nummeric(count) to character(yes/no)
convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}

sms_train <- apply(sms_dtm_freq_train, MARGIN = 2,  convert_counts) #margin=2 means apply on each column
sms_test <- apply(sms_dtm_freq_test, MARGIN = 2,   convert_counts)

#STEP 4: Apply Naive-Bayes Theorem
install.packages("e1071")
library(e1071)

#training
sms_classifier <- naiveBayes(sms_train, sms_train_labels)

#prediction
sms_test_pred <- predict(sms_classifier, sms_test)

#STEP 5: Testing model performance
library(gmodels)

CrossTable(sms_test_pred,sms_test_labels, prop.chisq = FALSE, prop.t = FALSE, dnn = c('predicted', 'actual'))

