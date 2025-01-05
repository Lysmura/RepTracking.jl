"""
    table3()

Replicate table 3 panel A of Duflo, & al (2008) on the short run results with distinction by gender

# Examples
```julia-repl
julia> table3()
> tabA
```
"""
function table3()
    #Import data
    d = data_student_test()
    dropmissing!(d, [:girl, :bottomhalf, :etpteacher])

    #helper
    invert_dummy(x) = ifelse(x == 1, 0, 1)
    #Cross dummy to interact gender and teacher type with tracking
    #First require also boy and Contract teacher
    transform!(d, [:girl] => ByRow(invert_dummy) => :boy,
        [:bottomhalf] => ByRow(invert_dummy) => :tophalf,
        [:etpteacher] => ByRow(invert_dummy) => :Cteacher)
    transform!(d, [:girl, :tracking, :bottomhalf] => ByRow(*) => :girl_tracking_bottomhalf,
        [:boy, :tracking, :bottomhalf] => ByRow(*) => :boy_tracking_bottomhalf,
        [:girl, :tracking, :tophalf] => ByRow(*) => :girl_tracking_tophalf,
        [:boy, :tracking, :tophalf] => ByRow(*) => :boy_tracking_tophalf,
        [:girl, :bottomhalf] => ByRow(*) => :girl_bottomhalf,
        [:etpteacher, :tracking, :tophalf] => ByRow(*) => :Rteacher_tracking_tophalf,
        [:Cteacher, :tracking, :tophalf] => ByRow(*) => :Cteacher_tracking_tophalf,
        [:etpteacher, :tracking, :bottomhalf] => ByRow(*) => :Rteacher_tracking_bottomhalf,
        [:Cteacher, :tracking, :bottomhalf] => ByRow(*) => :Cteacher_tracking_bottomhalf,
        [:girl, :bottomhalf] => ByRow(*) => :Rteacher_bottomhalf)

        #Run the regressions for gender and teacher, then for change the dependent variable from total score to long run total score
        fit1 = reg(d, term(:totalscore_function) ~ term(:girl_tracking_bottomhalf) + term(:boy_tracking_bottomhalf) +
        term(:girl_tracking_tophalf) + term(:boy_tracking_tophalf) + term(:girl) +
        term(:percentile) + term(:agetest) + term(:etpteacher) + term(:bottomhalf) + term(:girl_bottomhalf), 
            Vcov.cluster(:schoolid))

fit2 = reg(d, term(:totalscore_function) ~ term(:Rteacher_tracking_bottomhalf) + term(:Cteacher_tracking_bottomhalf) +
    term(:Rteacher_tracking_tophalf) + term(:Cteacher_tracking_tophalf) + term(:girl) +
    term(:percentile) + term(:agetest) + term(:etpteacher) + term(:bottomhalf) + term(:Rteacher_bottomhalf), 
        Vcov.cluster(:schoolid))

fit3 = reg(d, term(:r2_totalscore_function) ~ term(:girl_tracking_bottomhalf) + term(:boy_tracking_bottomhalf) +
    term(:girl_tracking_tophalf) + term(:boy_tracking_tophalf) + term(:girl) +
    term(:percentile) + term(:agetest) + term(:etpteacher) + term(:bottomhalf) + term(:girl_bottomhalf), 
        Vcov.cluster(:schoolid))

fit4 = reg(d, term(:r2_totalscore_function) ~ term(:Rteacher_tracking_bottomhalf) + term(:Cteacher_tracking_bottomhalf) +
    term(:Rteacher_tracking_tophalf) + term(:Cteacher_tracking_tophalf) + term(:girl) +
    term(:percentile) + term(:agetest) + term(:etpteacher) + term(:bottomhalf) + term(:Rteacher_bottomhalf), 
        Vcov.cluster(:schoolid))

tab3 = regtable(fit1, fit2, fit3, fit4,
    drop = ["(Intercept)", "girl", "percentile", "agetest", "etpteacher" , "bottomhalf", "girl_bottomhalf", "Rteacher_bottomhalf"],
    labels = Dict(
        "totalscore_function" => "Effect of Tracking on Total score 18 months in program",
        "r2_totalscore_function" => "Effect of Tracking on Total score 1 year after program ended",
        "girl_tracking_bottomhalf" => "Girl in bottomhalf",
        "boy_tracking_bottomhalf" => "Boy in bottomhalf",
        "girl_tracking_tophalf" => "Girl in tophalf",
        "boy_tracking_tophalf" => "Boy in tophalf",
        "Rteacher_tracking_bottomhalf" => "Regular teacher and bottomhalf",
        "Cteacher_tracking_bottomhalf" => "Contract teacher and bottomhalf",
        "Rteacher_tracking_tophalf" => "Regular teacher and bottomhalf tophalf",
        "Cteacher_tracking_tophalf" => "Contract teacher and tophalf")
        )
    return tab3
end








