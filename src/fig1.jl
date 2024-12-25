using StatsPlots
include("data.jl")
function figure1()
    df1 = data_student_test()
    select!(df1, :std_mark,:tracking,  :tracking => ByRow(x -> ifelse(x == 1,  "Tracking Schools" , "Non-Tracking Schools")) => :trackinggroup)
    dropmissing!(df1)
    @df df1 groupedhist(:std_mark, group = :trackinggroup, layout = 2, legend = :bottom, ylabel = "density", normed = true)
end