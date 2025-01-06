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
        [:etpteacher] => ByRow(invert_dummy) => :Rteacher)
    transform!(d, [:girl, :tracking, :bottomhalf] => ByRow(*) => :girl_tracking_bottomhalf,
        [:boy, :tracking, :bottomhalf] => ByRow(*) => :boy_tracking_bottomhalf,
        [:girl, :tracking, :tophalf] => ByRow(*) => :girl_tracking_tophalf,
        [:boy, :tracking, :tophalf] => ByRow(*) => :boy_tracking_tophalf,
        [:girl, :bottomhalf] => ByRow(*) => :girl_bottomhalf,
        [:etpteacher, :tracking, :tophalf] => ByRow(*) => :Cteacher_tracking_tophalf,
        [:Rteacher, :tracking, :tophalf] => ByRow(*) => :Rteacher_tracking_tophalf,
        [:etpteacher, :tracking, :bottomhalf] => ByRow(*) => :Cteacher_tracking_bottomhalf,
        [:Rteacher, :tracking, :bottomhalf] => ByRow(*) => :Rteacher_tracking_bottomhalf,
        [:etpteacher, :bottomhalf] => ByRow(*) => :Cteacher_bottomhalf)

    #Run the regressions for gender and teacher, then for change the dependent variable from total score to long run total score
    fit1 = reg(d, term(:totalscore_function) ~ term(:girl_tracking_bottomhalf) + term(:boy_tracking_bottomhalf) +
        term(:girl_tracking_tophalf) + term(:boy_tracking_tophalf) + term(:girl) +
        term(:percentile) + term(:agetest) + term(:etpteacher) + term(:bottomhalf) + term(:girl_bottomhalf), 
            Vcov.cluster(:schoolid))

    fit2 = reg(d, term(:r2_totalscore_function) ~ term(:girl_tracking_bottomhalf) + term(:boy_tracking_bottomhalf) +
    term(:girl_tracking_tophalf) + term(:boy_tracking_tophalf) + term(:girl) +
        term(:percentile) + term(:agetest) + term(:etpteacher) + term(:bottomhalf) + term(:girl_bottomhalf), 
            Vcov.cluster(:schoolid))

    fit3 = reg(d, term(:totalscore_function) ~ term(:Rteacher_tracking_bottomhalf) + term(:Cteacher_tracking_bottomhalf) +
    term(:Rteacher_tracking_tophalf) + term(:Cteacher_tracking_tophalf) + term(:girl) +
        term(:percentile) + term(:agetest) + term(:etpteacher) + term(:bottomhalf) + term(:Cteacher_bottomhalf), 
            Vcov.cluster(:schoolid))

    fit4 = reg(d, term(:r2_totalscore_function) ~ term(:Rteacher_tracking_bottomhalf) + term(:Cteacher_tracking_bottomhalf) +
        term(:Rteacher_tracking_tophalf) + term(:Cteacher_tracking_tophalf) + term(:girl) +
        term(:percentile) + term(:agetest) + term(:etpteacher) + term(:bottomhalf) + term(:Cteacher_bottomhalf), 
            Vcov.cluster(:schoolid))
    
    #Compute the p-value for each coeff interaction e.g. Boys = girls in bottomhalf
    p_values = []
    for fit in [fit1, fit2, fit3, fit4]
        val1 = fit.coef[2]
        val2 = fit.coef[3]
        val3 = fit.coef[4]
        val4 = fit.coef[5]
        var1 = fit.vcov[2,2]
        var2 = fit.vcov[3,3]
        var3 = fit.vcov[4,4]
        var4 = fit.vcov[5,5]
        cov12 = fit.vcov[2,3]
        cov34 = fit.vcov[4,5]
        cov24 = fit.vcov[3,5]
        cov13 = fit.vcov[2,4]
        dof = fit.dof_residual

        push!(p_values, w_test(val1, var1, val2, var2, cov12, dof),
            w_test(val3, var3, val4, var4, cov34, dof),
            w_test(val1, var1, val3, var3, cov13, dof),
            w_test(val2, var2, val4, var4, cov24, dof))
    end

    tab3 = regtable(fit1, fit3,fit2, fit4,
        drop = ["(Intercept)", "girl", "percentile", "agetest", "etpteacher" , "bottomhalf", "girl_bottomhalf", "Cteacher_bottomhalf"],
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
            "Cteacher_tracking_tophalf" => "Contract teacher and tophalf"),
            regression_statistics = [],
            extralines = [
                ["Test p-value", ""=> 2:5],
                ["Girls = Boys in bottomhalf", p_values[1], "", p_values[5],""],
                ["Girls = Boys in tophalf", p_values[2], "", p_values[6],""],
                ["Bottomhalf = tophalf girls", p_values[3], "",p_values[7],""],
                ["Bottomhalf = tophalf boys", p_values[4], "", p_values[8],""],
                ["Contract = Regular in bottomhalf", "", p_values[9],"", p_values[13]],
                ["Contract = Regular in tophalf","", p_values[10], "", p_values[14]],
                ["Bottomhalf = tophalf contract","", p_values[11], "",p_values[15]],
                ["Bottomhalf = tophalf regular","", p_values[12], "", p_values[16]]],
                file = "output/table3.txt"
            )

    return tab3
end
