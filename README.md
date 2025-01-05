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

The following show an exemple call of a function to reproduce the Figure 1, 2, and 3 along with table 2, 3, and 4. All outputs are saved in the output folder.
```julia
run()
```

And now to reproduce the figure 2 of the paper :
```julia
figure2()
```

Notice that the functions to import data aren't exported bythe package, to call them add the prefix 'RepTracking.' before the data function (list later in the README).

## Functions list
This are the different function exported by the package `ReepTracking.jl` :
* `figure1()` reproduces the two histograms of figure 1 on the density per groups (tracked and non tracked) for the standardized total score with mean and standard deviation of non tracked group.
* `figure2()` reproduces the two way scatter plot of figure 2 showing the evolution of the average initial attaintment of classmated given the baseline quantile.
* `table2()` reproduces the set of robust regressions on the effect of tratment in the short and long run (18 months in program, and 1 year after program ended).
* `figure3()` reproduces

Those functions are implemented to facilitate the reproduction and aren't exported by the package. To call them add the prefix `RepTracking.` before calling them.
* `data_student_test()`, `data_student_pres()`, `data_teacher_test()` import the dataset from the format .dta and apply the transformation required to replicate the results.

## Limitations of the replication
Some part of the author work couldn't be replicated due to the lack of libraries on Julia or the time constraint :
* On mutliple tables, the t-test for the equality between treatment effect across group effect couldn't be reproduced due to the lack of compatibility between the `HypothesisTests.jl` package and `FixedEffectModel.jl`. It is however possible to implement a function to manually compute it to complete our work using the formula of the Wald test : $\frac{\beta_1 - \beta_2}{V(\beta_1) + V[\beta_2] - 2Cov(\beta_1, \beta_2)}$, and retrieving it's quantile with the normal law quantile function. We ran in the same issue with the total effect of bottom. After trying, this was too tedious to implement as our results doing so were not conclusive.
* Some differences with our results and the author ones (for instance in table 3 panel B) can be traced by the absence of their complete code online. They released an intermediary version, and we couldn't access the full one showing all the specifications they used for their model. This is also the reason for the absence of table 1 in our replication work. 

If required, please reach a group member to get some more information or insights.