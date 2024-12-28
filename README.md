# RepTracking.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Lysmura.github.io/RepTracking.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Lysmura.github.io/RepTracking.jl/dev/)
[![Build Status](https://github.com/Lysmura/RepTracking.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/Lysmura/RepTracking.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This package provide a replication of the paper Peer Effects, Teacher Incentives, And Impact Of Tracking : Evidence From a Randomized Evaluation In Kenya by E. Duflo, P. Dupas, and M. Kremer in 2008. The original code is provided in Stata, here it is adapted under julia in the context of the 2024/2025 Computational Economics of Sciences Po by F. Oswald. 

The original paper can be found [here](https://www.nber.org/system/files/working_papers/w14475/w14475.pdf)

## Table of Contents

- [RepTracking.jl](#RepTrackingjl)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Demonstration of the reproduction](#Demonstration-of-the-reproduction)
  - [Functions list](#functions-list)

## Installation

To install the package, use this prompt in the console : 

```julia
|||||||||||||||||||||| TO ADD
```

Then add this command :
```julia
using RepTracking
```

## Demonstration of the reproduction

The following show an exemple call of a function to reproduce the Figure 1, 2, and 3 along with table 2, 3, and 4:
```julia
using .RepTracking

run()
```

And now to reproduce the figure 2 of the paper :
```julia
using .RepTracking

figure2()
```

Notice that the functions to import data aren't exported bythe package, to call them add the prefix 'RepTracking.' before the data function (list later in the README).

## Functions list
This are the different function exported by the package `ReepTracking.jl` :
* `figure1()` reproduce the two histograms of figure 1 on the density per groups (tracked and non tracked) for the standardized total score with mean and standard deviation of non tracked group.
* `figure2()` reproduce the two way scatter plot of figure 2 showing the evolution of the average initial attaintment of classmated given the baseline quantile.
* `table2_panelA()` reproduce the set of robust regressions on the effect of tratment in the short run (18 months after program).

