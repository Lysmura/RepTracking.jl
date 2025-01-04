module RepTracking

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

include("data.jl")
include("fig1.jl")
include("fig2.jl")
include("tab2.jl")
include("fig3.jl")
figure3()
end
