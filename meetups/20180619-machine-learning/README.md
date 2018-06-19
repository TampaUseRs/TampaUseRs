## Materials for 2018-06-19 Tampa R Users Group Meetup

### Basic Machine Learning Techniques in R by Minh Pham (minhpham@usf.edu)

- [6.19.2018.html](6.19.2018.html) is presentation slides
- [6.19.2018.Rpres](6.19.2018.Rpres) is the source code for the slides
- [6.19.2018.R](6.19.2018.R) contains the R code from the slides

### Data

- <https://archive.ics.uci.edu/ml/machine-learning-databases/letter-recognition/letter-recognition.data>
- <http://www.sci.csueastbay.edu/~esuess/classes/Statistics_6620/Presentations/ml13/groceries.csv>

### Packages Used

```r
pkgs <- c(
  "ggplot2",
  "dplyr",
  "caret",
  "randomForest",
  "e1071",
  "plotly",
  "nnet",
  "sqldf",
  "devtools",
  "htmlwidgets",
  "forecast",
  "arules"
)

install.packages(pkgs)
```

Also, some functions require Minh's personal package

```r
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
devtools::install_github("minh2182000/Mtoolbox")
```