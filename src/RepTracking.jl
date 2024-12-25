module RepTracking

using DataFrames
using StatFiles
using Statistics
using Plots
using StatsPlots
using Chain

include("data.jl")
d = data_student_pres()
include("fig1.jl")
figure1()

end