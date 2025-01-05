"""
    figure1()

Replicate figure 1 of Duflo, & al (2008).

# Examples
```julia-repl
julia> figure1()
> 2 histograms
```
"""
function figure1()
    df1 = data_student_test()
    select!(df1, :std_mark,:tracking,  :tracking => ByRow(x -> ifelse(x == 1,  "Tracking Schools" , "Non-Tracking Schools")) => :trackinggroup)
    dropmissing!(df1)
    @df df1 groupedhist(:std_mark, group = :trackinggroup, layout = 2, legend = :bottom, ylabel = "density", normed = true)
end