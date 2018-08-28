---
title: Intro To Keras/TensorFlow
presenter: Vince Kegel
date: 2018-08-28
email: vkegel@gmail.com
twitter: "@vkegel"
---

[Keras]: https://keras.rstudio.com
[TensorFlow]: https://www.tensorflow.org/

## Description

Learn about using the Tensorflow/Keras packages in RStudio.
Short introduction will be provided on Tensorflow and demonstration using basic samples.
Vince will walk us through an example demonstrating MNIST numeral recognition and discuss the environment needed to run neural networks on a workstation or in the cloud.

Vince Kegel is an independent Project Mgr consultant and is involved with the start up community in Tampa. He uses R mostly as a hobby, but has been known to use R in job-related data analysis. He is by nature a hardware guy (chip design) who is evolving into software. He can be found online at [&commat;vkegel](https://twitter.com/status/vkegel), [LinkedIn](https://www.linkedin.com/in/vkegel), or vkegel@gmail.com.

## Files


- [Intro to TensorFlow.Keras.pdf](Intro to TensorFlow.Keras.pdf) contains the presentation slides
- [MNIST - Demo.R](MNIST - Demo.R) contains a demonstration of TensorFlow and Keras on the MNIST data set.
- [MNIST CNN.R](MNIST CNN.R) contains another demonstration using a convolutional neural network on the MNIST data set.

## Data

The MNIST data is provided with the [Keras] package.

## Setup

Install the [keras] package for R, which uses the [TensorFlow] backend enging by default.
To install both Keras as well as [Tensorflow], use the `install_keras()` function.

```r
install.packages("keras")
library(keras)
install_keras()
```
