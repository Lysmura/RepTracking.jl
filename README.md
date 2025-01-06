# RepTracking.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Lysmura.github.io/RepTracking.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Lysmura.github.io/RepTracking.jl/dev/)
[![Build Status](https://github.com/Lysmura/RepTracking.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/Lysmura/RepTracking.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This package provide a replication of the paper Peer Effects, Teacher Incentives, And Impact Of Tracking : Evidence From a Randomized Evaluation In Kenya by E. Duflo, P. Dupas, and M. Kremer in 2008. The original code is provided in Stata, here it is adapted under julia in the context of the 2024/2025 Computational Economics of Sciences Po by F. Oswald. 

The original paper can be found [here](https://www.nber.org/system/files/working_papers/w14475/w14475.pdf).
Ressource on the course for which this replication was made can be found [here](https://floswald.github.io/NumericalMethods/).

Authors : Alexandra ANGHEL, Nayanika Mitash, Elysabeth Triffe
## Table of Contents

- [RepTracking.jl](#RepTrackingjl)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Demonstration of the reproduction](#Demonstration-of-the-reproduction)
  - [Functions list](#functions-list)
  - [Limitations of the replication](#Limitations-of-the-replication)

## Installation

To initialise the package, use this prompt in the console : 

```julia
git clone https://github.com/Lysmura/RepTracking.jl.git

using Pkg

Pkg.activate(".")

Pkg.instantiate()
```

## Demonstration of the reproduction

The following show an exemple call of a function to reproduce the Figure 1, 2, and 3 along with table 2, 3, and 6. All outputs are saved in the output folder.
```julia
RepTracking.run()
```

And now to reproduce the figure 2 of the paper :
```julia
figure2()
```

Notice that the functions to import data aren't exported by the package, to call them add the prefix 'RepTracking.' before the data function (list later in the README).

## Functions list
This are the different function exported by the package `RepTracking.jl`, all outputs of those function can be saved in the output folder using  `run()`:
* `figure1()` : two histograms of figure 1 on the density per groups (tracked and non tracked) for the standardized total score with mean and standard deviation of non tracked group.
* `figure2()` : two way scatter plot of figure 2 showing the evolution of the average initial attaintment of classmated given the baseline quantile.
* `figure3()` : fuzzy regression design with polynomial model on results given initial attainment before treatment.
* `table2()` : set of robust regressions on the effect of tratment in the short and long run (18 months in program, and 1 year after program ended).
* `table3()` : table on heterogeinity of effect across population treated, and test if the differences are significant on short and long run.
* `table6()` : teacher and presence effect on outcome. Table 6 was added to replace table1 that we couldn't reproduce.

Those functions are implemented to facilitate the reproduction i.e. either import and clean data, or to serve as helpers to build replication content :
* `data_student_test()`, `data_student_pres()`, `data_teacher_test()` import the dataset from the format .dta and apply the transformation required to replicate the results.
* `w_test()` introduces a Wald test and compute the p-value of the Hypothesise : H0 : $\beta_1$ = $\beta_2$ in a regression model, such that the test score is $\frac{\beta_1 - \beta_2}{V(\beta_1) + V[\beta_2] - 2Cov(\beta_1, \beta_2)}$, following a Fisher law of 1 and N-k-1 degrees of freedom i.e. a Student law of N-k-1 degrees of freedom.
* `standardize_keep_missing()` standardizes data using the mean and the standard deviation of the untracked school as the author did. Function implemented to compute the standardized value and keep the missing ones.

## Limitations of the replication
Some part of the author work couldn't be replicated due to the lack of libraries on Julia or the time constraint :
* On mutliple tables, the values we compute are not fully consistent with the paper, yet those discrepancies remain below 5% (as shown by the test we implemented). This is due to some differences in the number of observations (slighlty higher in our case), but also to the fact that computation on Stata might use slightly different specification. 
* Some differences with our results  can be traced by the absence of their complete code online. They released an intermediary version, and we couldn't access the full one showing all the specifications they used for their model. This is also the reason for the absence of table 1 in our replication work.
* For table 6 the paper mentions using test date dummies, which they might have created by defining baseline, endline, and long-term test dates. While the paper explains this process, it seems that the timing of the endline tests varied across schools, making it difficult to construct a dummy from the dataset to determine which dates correspond to the endline. This dummy construction is also not available in their STATA code. We believe this is the primary reason for the discrepancy in our Table 6 values. The STATA code however returns values that are extremely close to the values reported in our JULIA replication. 

If required, please reach a group member to get some more information or insights.
