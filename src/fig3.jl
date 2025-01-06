"""
    figure3()

Replicate figure 3 of Duflo, & al (2008).

# Examples
```julia-repl
julia> figure3()
> 1 scatterplot and fitted polynomial function
```
"""
function figure3()
    # Load the data
    d= data_student_test()

    # Generate `interval` variable
    d[!, :interval] = d[:, :realpercentile]

    # Generate `cec` (above-the-cutoff dummy)
    d[!, :cec] = ifelse.(ismissing.(d[:, :quantile5p]) .| (d[:, :quantile5p] .<= 10), 0, 1)
    d[!, :cec] .= ifelse.(ismissing.(d[:, :realpercentile]), missing, d[:, :cec])

    # Rename `totalscore` to `Total` which is the standardised totalscore
    d[!, :Total] = d[!, :totalscore_function]


    # Collapse data by interval, cec, and tracking
    d = filter(row -> !ismissing(row.Total), d)

    collapsed_df = combine(groupby(d, [:interval, :cec, :tracking]), 
    :Total => mean => :Total, 
    :stream_meanpercentile => mean => :stream_meanpercentile)


    # Generate higher-order terms for `interval`
    collapsed_df[!, :interval2] = collapsed_df[!, :interval] .^ 2
    collapsed_df[!, :interval3] = collapsed_df[!, :interval] .^ 3

    #handling missing values 
    collapsed_df = filter(row -> !ismissing(row.interval), collapsed_df)

    #converting to float64
    collapsed_df[!,:Total] = Float64.(collapsed_df[!,:Total])
    collapsed_df[!,:interval] = Float64.(collapsed_df[!,:interval])
    collapsed_df[!,:tracking] = Float64.(collapsed_df[!,:tracking])
    collapsed_df[!,:stream_meanpercentile] = Float64.(collapsed_df[!,:stream_meanpercentile])

    ##Regression for tracking
    for x in 0:1
    # Filter the dataset for the current `x` value and `tracking == 1`
    subset = filter(row -> row[:cec] == x && row[:tracking] == 1, collapsed_df)
    
    # Run the regression
    model = lm(@formula(Total ~ interval + interval2 + interval3), subset)
    
    # Predict values based on the model
    predictions = predict(model, collapsed_df)
    
    # Store predictions in YT1 for x=1 and YT0 for x=0
    if x == 1
        collapsed_df[!, :YT1] = ifelse.((collapsed_df[!, :cec] .== x) .& (collapsed_df[!, :tracking] .== 1), predictions, missing)
    else
        collapsed_df[!, :YT0] = ifelse.((collapsed_df[!, :cec] .== x) .& (collapsed_df[!, :tracking] .== 1), predictions, missing)
    end
    end


    ##Regression for Non-Tracking
    for x in 0:1
    # Filter the dataset for the current `x` value and `tracking == 0`
    subset = filter(row -> row[:cec] == x && row[:tracking] == 0, collapsed_df)
    
    # Run the regression
    model = lm(@formula(Total ~ interval + interval2 + interval3), subset)
    
    # Predict values based on the model
    predictions = predict(model, collapsed_df)
    
    # Store predictions in YN1 for x=1 and YN0 for x=0
    if x == 1
        collapsed_df[!, :YN1] = ifelse.((collapsed_df[!, :cec] .== x) .& (collapsed_df[!, :tracking] .== 0), predictions, missing)
    else
        collapsed_df[!, :YN0] = ifelse.((collapsed_df[!, :cec] .== x) .& (collapsed_df[!, :tracking] .== 0), predictions, missing)
    end
    end


   #Generating Actual Values of Total for tracking and non-tracking
   collapsed_df[!, :TotalN] = ifelse.(collapsed_df[!, :tracking] .== 0, collapsed_df[!, :Total], missing)
   collapsed_df[!, :TotalT] = ifelse.(collapsed_df[!, :tracking] .== 1, collapsed_df[!, :Total], missing)

   #Confirming the data DataFrame
   interval = collapsed_df[!, :interval]
   TotalT = collapsed_df[!, :TotalT]  # Replace with the actual column name for TotalT
   TotalN = collapsed_df[!, :TotalN]  # Replace with the actual column name for TotalN
   YT1 = collapsed_df[!, :YT1]
   YT0 = collapsed_df[!, :YT0]
   YN1 = collapsed_df[!, :YN1]
   YN0 = collapsed_df[!, :YN0]

   # Function to filter non-missing values and extract intervals and predictions

    function filter_and_extract(df, prediction_col, interval_col)
    valid_rows = filter(row -> !ismissing(row[prediction_col]), eachrow(df))
    intervals = [row[interval_col] for row in valid_rows]
    predictions = [row[prediction_col] for row in valid_rows]
    return intervals, predictions
    end

   # Apply the function for each case
   interval_YT1, YT1 = filter_and_extract(collapsed_df, :YT1, :interval)
   interval_YT0, YT0 = filter_and_extract(collapsed_df, :YT0, :interval)
   interval_YN1, YN1 = filter_and_extract(collapsed_df, :YN1, :interval)
   interval_YN0, YN0 = filter_and_extract(collapsed_df, :YN0, :interval)

 # plot with valid data
 fig3 = plot()
 # Scatter plot for TotalT with yellow markers
 scatter!(fig3, interval, TotalT, label="Local Average, Tracking Schools", 
       marker=:circle, color=:yellow, markerstrokecolor=:yellow)

 # Scatter plot for TotalN with brown markers
 scatter!(fig3, interval, TotalN, label="Local Average, Non-Tracking Schools", 
       marker=:circle, color=:brown, markerstrokecolor=:brown)

 # Line plot for YT1 and YT0 with blue solid lines
 plot!(fig3, interval_YT1, YT1, label="Polynomial Fit, Tracking", color=:blue, linestyle=:solid)
 plot!(fig3, interval_YT0, YT0, label="", color=:blue, linestyle=:solid)  # Empty label to group with the previous line

 # Line plot for YN1 and YN0 with red dashed lines
 plot!(fig3, interval_YN1, YN1, label="Polynomial Fit, Non-Tracking", color=:red, linestyle=:dash)
 plot!(fig3, interval_YN0, YN0, label="", color=:red, linestyle=:dash)  # Empty label to group with the previous line

 # Add vertical line at x = 50
 vline!(fig3, [50], label="", color=:red, linestyle=:dash)

 # Customize the plot
 xlabel!(fig3, "Initial Attainment Percentile")
 ylabel!(fig3, "Endline Test Scores")
 title!(fig3, "Effect of Tracking by Initial Attainment")
 
 return fig3

end
