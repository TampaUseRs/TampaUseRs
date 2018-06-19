## ---- eval = FALSE-------------------------------------------------------
## if (User@Use_R) User@Intelligence = "Smart" else User@Intelligence = "Unknown"

## ---- eval = FALSE-------------------------------------------------------
## # Given data, estimate beta0, beta1
## # probability of being Smart:
## p = 1/
##   (1 + exp(beta0 + beta1 * User@Use_R))
## 

## ------------------------------------------------------------------------
Letter_recognition = read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/letter-recognition/letter-recognition.data",
                              header = FALSE,
                              col.names = c("Letter", paste0("V", 1:16)))
head(Letter_recognition)

## ------------------------------------------------------------------------
# library(devtools)
# install_github("minh2182000/Mtoolbox")
library(MToolBox)
visual = Plot.VisualizeSupervise(Letter ~ . , data = Letter_recognition)
ggplotly(visual$Plot) -> Plot1

## ---- echo = FALSE-------------------------------------------------------
htmlwidgets::saveWidget(as.widget(Plot1), file = "6.19.2018-figure/Plot1.html")

## ------------------------------------------------------------------------
library(caret, quietly = TRUE)
tail(names(getModelInfo()), 40) # list of ML methods wrapped by caret
length(names(getModelInfo())) 


## ------------------------------------------------------------------------
set.seed(9)
RandomForest = train(form = Letter ~ .,data = Letter_recognition,
                     method = "rf",
                     trControl = trainControl(method = "cv", number = 10))
set.seed(9)
# SVM = train(form = Letter ~ .,data = Letter_recognition,
                     # method = "svmPoly",
                     # trControl = trainControl(method = "cv", number = 10))
# accuracy 0.968
set.seed(9)
LDA = train(form = Letter ~ .,data = Letter_recognition,
                     method = "lda",
                     trControl = trainControl(method = "cv", number = 10))
set.seed(9)
KNN = train(form = Letter ~ .,data = Letter_recognition,
                     method = "knn",
                     trControl = trainControl(method = "cv", number = 10))
set.seed(9)
# NeuralNetworks = train(form = Letter ~ .,data = Letter_recognition,
                     # method = "mxnet",
                     # trControl = trainControl(method = "cv", number = 10))
# fail to converge

RandomForest$results[which.max(RandomForest$results$Accuracy),]
LDA$results[which.max(LDA$results$Accuracy),]
KNN$results[which.max(KNN$results$Accuracy),]


## ------------------------------------------------------------------------
set.seed(9)
LM = train(form = V1 ~ .,data = Letter_recognition,
                     method = "lm",
                     trControl = trainControl(method = "cv", number = 10))
set.seed(9)
LASSO = train(form = V1 ~ .,data = Letter_recognition,
                     method = "lasso",
                     trControl = trainControl(method = "cv", number = 10))
LM$results[which.max(LM$results$RMSE),]
LASSO$results[which.max(LASSO$results$RMSE),]

# predict new data
predict(LM, newdata = Letter_recognition[1,])

## ------------------------------------------------------------------------
data(economics)
head(economics, 3)
timeSlices = createTimeSlices(economics$unemploy,
                              initialWindow = 100, # number of train
                              horizon = 10, # number of test
                              skip = 75) # to reduce number of slices
library(forecast, quietly = TRUE); library(dplyr, quietly = TRUE)
MSPE = numeric(0)
for (i in 1:length(timeSlices$train) ){ # for each time slice
  ARIMA = auto.arima(ts(economics$unemploy[timeSlices$train[[i]]]), # train
                     xreg = as.matrix(
                       economics 
                        %>% select(pce, pop, psavert)
                        %>% slice(timeSlices$train[[i]])
                     )
                     )
  pred = predict(ARIMA, n.ahead = 10, # test
                 newxreg = as.matrix(
                   economics 
                   %>% select(pce, pop, psavert)
                   %>% slice(timeSlices$test[[i]])
                 ))
  MSPE[i] = mean((pred$pred - economics$unemploy[timeSlices$test[[i]]])^2)
}
mean(sqrt(MSPE))

## ------------------------------------------------------------------------
LDA_RFE = rfe(x = model.matrix(Letter ~ . - 1, data = Letter_recognition),
              y = Letter_recognition$Letter,
              sizes = c(7, 13),
              rfeControl = rfeControl(functions = caretFuncs, # select method in caret
                                      number = 3, # number of resampling
                                      ),
              method = "lda")
LDA_RFE$optVariables

## ------------------------------------------------------------------------
PCA = prcomp(model.matrix(Letter ~ . - 1, data = Letter_recognition))
cat("variance explained according to number of PCs selected \n"); cumsum(PCA$sdev)/sum(PCA$sdev)
NewPredictors = PCA$x[,1:15]
cat("selected PCs \n"); head(NewPredictors, 5)

## ------------------------------------------------------------------------
Image_data = Letter_recognition %>% select(-Letter)

## ------------------------------------------------------------------------
HC = hclust(dist(Image_data))
plot(HC)

## ------------------------------------------------------------------------
KMEAN = kmeans(Image_data, centers = 26)
KMEAN_result = cbind(cluster = as.factor(KMEAN$cluster), Image_data)
library(MToolBox)
Plot2 <- Plot.VisualizeSupervise(cluster ~ ., data = KMEAN_result)$Plot

## ---- echo = FALSE-------------------------------------------------------
htmlwidgets::saveWidget(as.widget(Plot2), file = "6.19.2018-figure/Plot2.html")

## ------------------------------------------------------------------------
library(MToolBox)
Plot.ClusterElbow(Image_data, 30)

## ------------------------------------------------------------------------
clusters = cutree(HC, k = 20) # this is a vector of cluster numbers

## ------------------------------------------------------------------------
KMEAN = kmeans(Image_data, centers = 20)
clusters = KMEAN$cluster # this is a vector of cluster numbers

## ------------------------------------------------------------------------
library(arules)
groceries = read.csv("http://www.sci.csueastbay.edu/~esuess/classes/Statistics_6620/Presentations/ml13/groceries.csv", header = FALSE)
head(groceries,5)
transactions = read.transactions("http://www.sci.csueastbay.edu/~esuess/classes/Statistics_6620/Presentations/ml13/groceries.csv", sep = ",")
summary(transactions)


## ------------------------------------------------------------------------
rules = apriori(transactions, parameter = list(support = 0.001 # parameter for sensitivity
                                       ),
                control = list(verbose = FALSE))

rules_df = as(rules, "data.frame")
head(rules_df$rules[
  order(rules_df$lift, decreasing = TRUE)]
  , 10) # print associated items

