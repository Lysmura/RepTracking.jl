module RepTracking

##############################################################################
##
## Dependencies
##
##############################################################################
using DataFrames
using StatFiles
using Statistics
using Plots
using StatsPlots
using Chain
using StatsBase
using FixedEffectModels
using RegressionTables
using FileIO
using JLD2
using GLM

##############################################################################
##
## Exported methods 
##
##############################################################################
export figure1, 
    figure2, 
    figure3,
    table2,
    table3

##############################################################################
##
## Load Files
##
##############################################################################
include("data.jl")
include("fig1.jl")
include("fig2.jl")
include("tab2.jl")
include("fig3.jl")

end
