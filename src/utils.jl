"""
    w_test(coef1, var1, coef2, var2, cov, dof)

Compute the Wald test of two coefficients being equal and return p_value.

# Examples
```julia-repl
julia> w_test(coef1, var1, coef2, var2, cov, dof)
> Float64
```
"""
function w_test(coef1, var1, coef2, var2, cov, dof)
    w = (coef1 - coef2)/((var1 + var2 - 2*cov)^0.5)
    p_value =  2*ccdf(TDist(dof), abs(w))
end

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