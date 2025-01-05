include("data.jl")

"""
    table2()

Replicate table 2 panel A and B of Duflo, & al (2008) on the short and long run results

# Examples
```julia-repl
julia> table2()
> tabA, tabB
```
"""
function table2()
    #Import data
    d = data_student_test()

    #Aplly required transformation for indicator of percentile and tracking 
    #squared and cubed percentile
    transform!(d, [:tracking, :bottomquarter] => ByRow(*) => :bottomquarter_tracking,
                [:tracking, :secondquarter] => ByRow(*) => :secondquarter_tracking,
                [:tracking, :thirdquarter] => ByRow(*) => :thirdquarter_tracking,
                [:tracking, :topquarter] => ByRow(*) => :topquarter_tracking,
                [:tracking, :girl] => ByRow(*) => :girl_tracking,
                :percentile => ByRow(a -> a ^ 2 ) => :percentilesq,
                :percentile => ByRow(a -> a ^ 3 ) => :percentilecub) 

    #regress the 4 specifications of the model on the total standardize score for total, maths, and litscore
    #but also on the r2 variables of score for long term effect (same test measure in later period)
    #We use the programmatic construction of formula to allow the usage of a for loop
    fits = []
    coef_sum = []
    for dep_var in [:totalscore_function, :mathscoreraw_function, :litscore_function, :r2_totalscore_function, :r2_mathscoreraw_function, :r2_litscore_function]

        fit1 = reg(d, term(dep_var) ~ term(:tracking) ,
            Vcov.cluster(:schoolid))


        fit2 =reg(d, term(dep_var) ~ term(:tracking)  + term(:bottomhalf)  +
            term(:bottomquarter) + term(:secondquarter) + term(:topquarter) +
            term(:girl) + term(:percentile) + term(:percentilesq) + term(:agetest) + term(:etpteacher),
            Vcov.cluster(:schoolid))


        fit3 = reg(d, term(dep_var) ~ term(:tracking) + term(:bottomhalf_tracking) + term(:bottomhalf)  +
            term(:bottomquarter) + term(:secondquarter) + term(:topquarter) +
            term(:girl) + term(:percentile) + term(:percentilesq) + term(:agetest) + term(:etpteacher),
            Vcov.cluster(:schoolid))

        fit4 = reg(d, term(dep_var) ~ term(:tracking) + term(:bottomquarter_tracking) + term(:secondquarter_tracking) + 
            term(:topquarter_tracking) + term(:bottomhalf)  +
            term(:bottomquarter) + term(:secondquarter) + term(:topquarter) +
            term(:girl) + term(:percentile) + term(:percentilesq) + term(:agetest) + term(:etpteacher),
            Vcov.cluster(:schoolid))

        push!(coef_sum, coef(fit3)[2] + coef(fit3)[3],coef(fit4)[2]+ coef(fit4)[3])
        
        push!(fits, fit1, fit2, fit3, fit4)
    end

    #the function regtable require reg and not a list of reg
    t1, t2, t3, t4, m1, m2, m3, m4, l1, l2, l3, l4, r2_t1, r2_t2, r2_t3, r2_t4, r2_m1, r2_m2, r2_m3, r2_m4, r2_l1, r2_l2, r2_l3, r2_l4 = fits

    #Plot the table, notice difference in intercept, and small differences in some value, with two values extra compare to authors
    tabA = regtable(t1, t2, t3, t4, m1, m2, m3, m4, l1, l2, l3, l4,
        drop = ["bottomhalf", "bottomquarter", "secondquarter", "topquarter", "girl",
            "percentile", "percentilesq", "agetest", "Intercept"],
            labels = Dict(
                "tracking" => "Tracking School",
                "etpteacher" => "Assigned to Contract Teacher",
                "totalscore_function" => "Total Score",
                "mathscoreraw_function" => "Maths Score",
                "litscore_function" => "Literacy Score",
                "bottomhalf_tracking" => "In bottom half of initial distribution x tracking",
                "bottomquarter_tracking" => "In bottom quarter x tracking",
                "secondquarter_tracking" => "In second to bottom quarter x tracking",
                "topquarter_tracking" => "In top quarter x tracking"),
            regression_statistics = [Nobs => "Observations"],
            extralines = [
                ["Total effects on bottom half and bottom quarter", ""=> 2:13],
                ["Coeff bottom half + tracking ", "","",coef_sum[1], "", "","",coef_sum[3], "", "","",coef_sum[5], ""],
                ["Coeff bottom quarter + tracking ", "", "", "",coef_sum[2], "", "", "",coef_sum[4],"", "", "",coef_sum[6]]]
                )
    #Same for long term panel
    tabB = regtable(r2_t1, r2_t2, r2_t3, r2_t4, r2_m1, r2_m2, r2_m3, r2_m4, r2_l1, r2_l2, r2_l3, r2_l4,
    drop = ["bottomhalf", "bottomquarter", "secondquarter", "topquarter", "girl",
        "percentile", "percentilesq", "agetest", "Intercept"],
        labels = Dict(
            "tracking" => "Tracking School",
            "etpteacher" => "Assigned to Contract Teacher",
            "totalscore_function" => "Total Score",
            "mathscoreraw_function" => "Maths Score",
            "litscore_function" => "Literacy Score",
            "bottomhalf_tracking" => "In bottom half of initial distribution x tracking",
            "bottomquarter_tracking" => "In bottom quarter x tracking",
            "secondquarter_tracking" => "In second to bottom quarter x tracking",
            "topquarter_tracking" => "In top quarter x tracking"),
        regression_statistics = [Nobs => "Observations"],
        extralines = [
            ["Total effects on bottom half and bottom quarter", ""=> 2:13],
            ["Coeff bottom half + tracking ", "","",coef_sum[1], "", "","",coef_sum[3], "", "","",coef_sum[5], ""],
            ["Coeff bottom quarter + tracking ", "", "", "",coef_sum[2], "", "", "",coef_sum[4],"", "", "",coef_sum[6]]]
            )

    return tabA, tabB
end