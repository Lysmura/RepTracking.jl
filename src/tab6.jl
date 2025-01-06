"""
    table6

Replicate table 6 panel A of Duflo, & al (2008) on the short run results

# Examples
```julia-repl
julia> table6()
> table
```
"""
function table6()
    #DataFrame
    df = data_teacher_pres()
    
     #Clean and transform data
     transform!(df, [:lowstream, :tracking ] => ByRow(*) => :bottomhalf_tracking,
     )
    
    # Initialize lists to store regression results
    fits = []
    coef_summary = []
    means = []
    
    # Column 1 Regression
    fit1 = reg(
        df,
        term(:pres) ~ term(:tracking) + term(:bottomhalf_tracking) + term(:yrstaught) + 
        term(:female) + term(:visitno) + term(:bungoma) + term(:realdate),
        Vcov.cluster(:schoolid)
    )
    push!(fits, fit1)
    mean_pres1 = mean(skipmissing(df.pres[df.tracking .== 0]))
    push!(means, mean_pres1)
    
    # Column 2 Regression
    fit2 = reg(
        df,
        term(:inclass) ~ term(:tracking) + term(:bottomhalf_tracking) + term(:yrstaught) + 
        term(:female) + term(:visitno) + term(:bungoma) + term(:realdate),
        Vcov.cluster(:schoolid)
    )
    push!(fits, fit2)
    mean_inclass2 = mean(skipmissing(df.inclass[df.tracking .== 0]))
    push!(means, mean_inclass2)
    
    # Column 3 Regression
    subset_data2 = filter(row -> row.etpteacher == 0, df)
    fit3 = reg(
        subset_data2,
        term(:pres) ~ term(:tracking) + term(:bottomhalf_tracking) + term(:yrstaught) + 
        term(:female) + term(:visitno) + term(:bungoma) + term(:realdate),
        Vcov.cluster(:schoolid)
    )
    push!(fits, fit3)
    subset_data = filter(row -> row.etpteacher == 0 && row.tracking == 0, df)
    mean_pres3 = mean(skipmissing(subset_data[!, :pres]))
    push!(means, mean_pres3)
    
    # Column 4 Regression
    fit4 = reg(
        subset_data2,
        term(:inclass) ~ term(:tracking) + term(:bottomhalf_tracking) + term(:yrstaught) + 
        term(:female) + term(:visitno) + term(:bungoma) + term(:realdate),
        Vcov.cluster(:schoolid)
    )
    push!(fits, fit4)
    mean_inclass4 = mean(skipmissing(subset_data[!, :inclass]))
    push!(means, mean_inclass4)
    
    # Column 5 Regression
    subset_data3 = filter(row -> row.etpteacher == 1, df)
    fit5 = reg(
        subset_data3,
        term(:pres) ~ term(:tracking) + term(:bottomhalf_tracking) + term(:yrstaught) + 
        term(:female) + term(:visitno) + term(:bungoma) + term(:realdate),
        Vcov.cluster(:schoolid)
    )
    push!(fits, fit5)
    subset_data4 = filter(row -> row.etpteacher == 1 && row.tracking == 0, df)
    mean_pres5 = mean(skipmissing(subset_data4[!, :pres]))
    push!(means, mean_pres5)
    
    # Column 6 Regression
    fit6 = reg(
        subset_data3,
        term(:inclass) ~ term(:tracking) + term(:bottomhalf_tracking) + term(:yrstaught) + 
        term(:female) + term(:visitno) + term(:bungoma) + term(:realdate),
        Vcov.cluster(:schoolid)
    )
    push!(fits, fit6)
    mean_inclass6 = mean(skipmissing(subset_data4[!, :inclass]))
    push!(means, mean_inclass6)
    
    # Column 7 Regression (with etpteacher and MonthYear)
    d = data_student_pres()
    transform!(d, [:bottomhalf, :tracking ] => ByRow(*) => :bottomhalf_tracking,
    [:etpteacher, :tracking ] => ByRow(*) => :etpteacher_tracking)
    
    d[!, :female] = d[!, :girl]
    
    
    
    fit7 = reg(
        d,
        term(:pres) ~ term(:tracking) + term(:bottomhalf_tracking) + term(:female) + 
        term(:etpteacher) + term(:etpteacher_tracking) + term(:bungoma) + 
        term(:realdate),
        Vcov.cluster(:schoolid)
    )
    push!(fits, fit7)
    mean_pres7 = mean(skipmissing(d[!, :pres]))
    push!(means, mean_pres7)
    
    # Extract results from each regression
    obs = [Nobs(fit) for fit in fits]
    
    
    # Extract specific coefficients
    coef_summary = [coef(fit) for fit in fits]
    
    
    
    # Regression table
    tab = regtable(
        fit1, fit2, fit3, fit4, fit5, fit6, fit7,
        drop = ["(Intercept)", "visitno", "bungoma", "realdate"],
        labels = Dict(
            "tracking" => "Tracking School",
            "etpteacher" => "Contract Teacher",
            "pres" => "Teacher Presence",
            "inclass" => "Teacher In-Class",
            "bottomhalf_tracking" => "Bottom Half x Tracking",
            "girl" => "Female Student"
        ),
        regression_statistics = [Nobs => "Observations"],
        extralines = [
            vcat(["Mean (Tracking=0)"], means[1:7]...),  # Adjust length to 7
        ],
                file = "output/table6.txt"
    )
    
    return tab
    
    end
