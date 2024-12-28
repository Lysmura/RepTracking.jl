"""
    empty_cols(df)

Check the presence of any empty column or 
presence of a column full of missing, and retrieve its name

# Examples
```julia-repl
julia> empty_cols(df)
> array
```
"""
function empty_cols(df)
    empty = []
    for name in names(df)
        coltype = eltype(df[!, name])
        if coltype != nonmissingtype(coltype) && all(ismissing.(df[!, name]))
            push!(empty,name)
        end
    end
    return empty
end