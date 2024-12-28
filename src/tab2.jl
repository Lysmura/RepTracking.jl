include("data.jl")

"""
    table2_panelA()

Replicate table 2 panel A of Duflo, & al (2008) on the short run results

# Examples
```julia-repl
julia> table2_panelA()
> table
```
"""
function table2_panelA()
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
    #We use the programmatic construction of formula to allow the usage of a for loop
    fits = []
    coef_sum = []
    for dep_var in [:totalscore_function, :mathscoreraw_function, :litscore_function]

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
    t1, t2, t3, t4, m1, m2, m3, m4, l1, l2, l3, l4 = fits

    #Plot the table, notice difference in intercept, and small differences in some value, with two values extra compare to authors
    tab = regtable(t1, t2, t3, t4, m1, m2, m3, m4, l1, l2, l3, l4,
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
    return tab
end