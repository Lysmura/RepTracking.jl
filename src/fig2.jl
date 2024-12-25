include("data.jl")

"""
    figure2()

Replicate figure 2 of Duflo, & al (2008).

# Examples
```julia-repl
julia> figure2()
> 1 scatter plot
```
"""
function figure2()
    d = data_student_test()
    dropmissing!(d,[:quantile5p, :tracking])
    d.stream_meanpercentile
    gd = groupby(d, [:quantile5p, :tracking])
    mean_gd = combine(gd, :stream_meanpercentile => mean)
    @df mean_gd scatter(:quantile5p, :stream_meanpercentile_mean, title="My DataFrame Scatter Plot!", group = :tracking, 
        ylabel = "Mean Standardized Baseline Score of Classmates",
        xlabel = "Own Initial Attainment:  Baseline 20-Quantile",
        labels = ["Non-tracking schools" "Tracking schools"])
    vline!([10.5], labels = "Median")
end
