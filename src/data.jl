@doc raw"""
Load and clean the data of the paper

#### RETURNS ####
 - student_pres
 - student_test
 - teacher_pres
"""
function data_student_pres()
    #Load data
    d = load("data/student_pres_data.dta") |> DataFrame
    student_pres = copy(d)

    #Clean and transform data

    return student_pres
end

function data_student_test()
    #Load data
    d = load("data/student_test_data.dta") |> DataFrame
    student_test = copy(d)

    #Clean and transform data
#    transform!(student_test, [:etpteacher, :lowstream] => ByRow(*) => :etpteacher_tracking_lowstream)
#    transform!(student_test, [:sbm,:tracking,:lowstream] => ByRow(*) =>:sbm_tracking_lowstream)
#    get_agetest(agetest, r2_age) = @. ifelse((agetest == missing) , r2_age-1, agetest)
#    transform!(student_test, [:agetest, :r2_age] => get_agetest => :agetest)

    return student_test
end

function data_teacher_pres()
    #Load data
    d = load("data/teacher_pres_data.dta") |> DataFrame
    teacher_pres = copy(d)

    #Clean and transform data

    return teacher_pres
end