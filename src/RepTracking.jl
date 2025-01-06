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
using Distributions

##############################################################################
##
## Exported methods 
##
##############################################################################
export data_student_pres,
    data_student_test,
    data_teacher_pres,
    figure1, 
    figure2, 
    figure3,
    table2,
    table3,
    run,
    w_test
    

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
include("tab3.jl")
include("utils.jl")
include("run.jl")
include("tab6.jl")
table6()
end
