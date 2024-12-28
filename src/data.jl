"""
    standardize_keep_missing(col)

Helper function
Return standardized value of col for the individuals with tracking = 0 i.e. the values of col are substracted by the mean of those with tracking 0 and dividided by their standard deviation.
The final transformation ensure that the return vector is float64
This form was required to keep the missing values in dataset

# Inputs
 - col : Vector{Float64} : values to standardize

# Examples
```julia-repl
julia> standardize_keep_missing(col ; tracking = d.tracking)
> Vector{Float64}
```
"""
function standardize_keep_missing(col; tracking = d.tracking)
    col_notracking = col[findall(a -> a==0,tracking)]
    mean_col = mean(skipmissing(col_notracking))
    sd_col = std(skipmissing(col_notracking))
    standardized_col = []
        for val in col 
            push!(standardized_col, (val - mean_col)/sd_col)
        end
    return standardized_col .* 1.
end

"""
    data_student_pres()

Import data student_pres of Duflo, & al (2008) Import data student_pres of Duflo, & al (2008).

# Examples
```julia-repl
julia> data_student_pres()
> DataFrame
```
"""
function data_student_pres()
    #Load data
    d = load("data/student_pres_data.dta") |> DataFrame
    student_pres = copy(d)

    #Clean and transform data

    return student_pres
end

"""
    data_student_test()

Import data student_test of Duflo, & al (2008) Import data student_pres of Duflo, & al (2008) and applies basic transformations used in the paper.

# Examples
```julia-repl
julia> data_student_test()
> DataFrame
```
"""
function data_student_test()
    #Load data
    d = load("data/student_test_data.dta") |> DataFrame
    student_test = copy(d)

    #Clean and transform data
        #Create variables
    transform!(student_test, [:etpteacher, :lowstream] => ByRow(*) => :etpteacher_tracking_lowstream)
    transform!(student_test, [:sbm,:tracking,:lowstream] => ByRow(*) =>:sbm_tracking_lowstream)
    transform!(student_test, [:bottomhalf, :tracking ] => ByRow(*) => :bottomhalf_tracking,
                             [:tophalf, :tracking ] => ByRow(*) => :tophalf_tracking,
                             [:etpteacher, :tracking ] => ByRow(*) => :etpteacher_tracking)

        #Reduce number of missing on age at the test
    get_agetest(agetest, r2_age) = ifelse(ismissing(agetest) , r2_age-1, agetest)
    transform!(student_test, [:agetest, :r2_age] => ByRow(get_agetest) => :agetest)

        #Standardize test score
    transform!(student_test,
        [:litscore, :mathscoreraw, :totalscore, :letterscore, :wordscore, :sentscore, :spellscore, :additions_score, :substractions_score, :multiplications_score] 
        .=> x -> standardize_keep_missing(x; d.tracking))
        
    return student_test
end

"""
    data_teacher_pres()

Import data teacher_pres of Duflo, & al (2008) Import data student_pres of Duflo, & al (2008).

# Examples
```julia-repl
julia> data_teacher_pres()
> DataFrame
```
"""
function data_teacher_pres()
    #Load data
    d = load("data/teacher_pres_data.dta") |> DataFrame
    teacher_pres = copy(d)

    #Clean and transform data

    return teacher_pres
end