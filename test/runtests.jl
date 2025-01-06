using .RepTracking
using Test
using DataFrames
using StatFiles
using Statistics
using Plots
using StatsPlots
using Chain
using StatsBase
using FixedEffectModels
using RegressionTables
using FileIO
using JLD2
using GLM
using Distributions

include("helper.jl")

student_pres = RepTracking.data_student_pres()
student_test = RepTracking.data_student_test()
teacher_test = RepTracking.data_teacher_pres()

@testset "RepTracking.jl" begin
    ############################################################
    # Test on the data import : check if dataframes imported are of the same size than expected
    ############################################################
    # Notice that the number of columns in the test include the expected added columns
    # by the transformation of the function.
    @test size(student_pres) == (97100, 10)
    @test size(student_test) == (7022, 124)
    @test size(teacher_test) == (2484, 12)

    ############################################################
    # Test if data imported as any empty col 
    ############################################################
    @test isempty(empty_cols(student_pres)) == true
    @test isempty(empty_cols(student_test)) == true
    @test isempty(empty_cols(teacher_test)) == true

    ############################################################
    #Test if the content of table 3 is consistent with paper 
    ############################################################
    #This test will be conducted only on 2 columns out of the 4 and 4 randomly picked values in those two
    #2 of those values will be the p-value to assess if the function w_test() works
    #Import data
    d = copy(student_test)
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
    fit4 = reg(d, term(:r2_totalscore_function) ~ term(:Rteacher_tracking_bottomhalf) + term(:Cteacher_tracking_bottomhalf) +
            term(:Rteacher_tracking_tophalf) + term(:Cteacher_tracking_tophalf) + term(:girl) +
            term(:percentile) + term(:agetest) + term(:etpteacher) + term(:bottomhalf) + term(:Cteacher_bottomhalf), 
                Vcov.cluster(:schoolid))
    
    #Compute the p-values
    p_values = []
    for fit in [fit1, fit4]
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

        push!(p_values, RepTracking.w_test(val1, var1, val2, var2, cov12, dof),
            RepTracking.w_test(val3, var3, val4, var4, cov34, dof),
            RepTracking.w_test(val1, var1, val3, var3, cov13, dof),
            RepTracking.w_test(val2, var2, val4, var4, cov24, dof))
    end

    #We test allowing only a deviation of 5% in the result
    @test isapprox(p_values[2],0.470;rtol= 0.05)
    @test isapprox(p_values[2],0.470;rtol= 0.05)
    @test isapprox(fit1.coef[2],0.188;rtol= 0.05)
    @test isapprox(fit4.coef[4],0.198;rtol= 0.05)
end
