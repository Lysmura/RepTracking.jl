using .RepTracking
using Test

include("helper.jl")

student_pres = RepTracking.data_student_pres()
student_test = RepTracking.data_student_test()
teacher_test = RepTracking.data_teacher_pres()

@testset "RepTracking.jl" begin
    # Test on the data import : check if dataframes imported are of the same size than expected
    # Notice that the number of columns in the test include the expected added columns
    # by the transformation of the function.
    @test size(student_pres) == (97100, 10)
    @test size(student_test) == (7022, 121)
    @test size(teacher_test) == (2484, 12)
    # Test if data imported as any empty col 
    @test isempty(empty_cols(student_pres)) == true
    @test isempty(empty_cols(student_test)) == true
    @test isempty(empty_cols(teacher_test)) == true
end
