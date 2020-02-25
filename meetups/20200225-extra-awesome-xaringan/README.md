---
title: Extra Awesome xaringan Presentations
presenter: Garrick Aden-Buie
date: 2020-02-25
email: garrick@adenbuie.com
twitter: "@grrrck"
web: https://www.garrickadenbuie.com
---

[xaringan]: https://slides.yihui.org/xaringan/
[xaringanthemer]: https://pkg.garrickadenbuie.com/xaringanthemer
[xaringanExtra]: https://pkg.garrickadenbuie.com/xaringanExtra
[metathis]: https://pkg.garrickadenbuie.com/metathis
[grrrck]: https://twitter.com/grrrck
[gab]: https://www.garrickadenbuie.com

# Extra Awesome xaringan Presentations

[Official slide repository](https://github.com/gadenbuie/extra-awesome-xaringan)

## Description

Learn how to make extra awesome [xaringan] presentations with a few new packages

- [xaringanthemer]
- [xaringanExtra]
- [metathis]

that add the extra touches needed to personalize your slides and make them stand out from the crowd.

Garrick is a Scientific Programmer and data scientist at Moffitt Cancer Center where he uses R and Shiny on a daily basis to help accelerate research toward the prevention and cure of cancer. He recently led the [JavaScript for Shiny Users](https://js4shiny.com) workshop at `rstudio::conf(2020)` where he definitely spent a _whole lot of time_ [slidecrafting](https://twitter.com/grrrck/status/1159087961931169795). You can find him on Twitter at [&commat;grrrck][grrrck] or at [garrickadenbuie.com][gab].

## Setup

Included files:

- [20200225_extra-awesome-xaringan_companion.R](20200225_extra-awesome-xaringan_companion.R)

_slides will be added soon..._

## Data

I think I will probably use the `babynames` package at least once.

## Packages Used

I'll use `xaringan`, `ggplot2`, `babynames` and three packages that I've released to GitHub. Use the code chunk below to install all the packages you'll need to follow along.

```r
install.packages("xaringan")
install.packages("babynames")

if (!requireNamespace("devtools", quietly = TRUE)) {
  stop("Please install the devtools package: install.packages('devtools')")
}

devtools::install_github("gadenbuie/xaringanthemer@dev", dependencies = TRUE)
devtools::install_github("gadenbuie/xaringanExtra", dependencies = TRUE)
devtools::install_github("gadenbuie/metathis", dependencies = TRUE)
```
