using RepTracking
using Documenter

DocMeta.setdocmeta!(RepTracking, :DocTestSetup, :(using RepTracking); recursive=true)

makedocs(;
    modules=[RepTracking],
    authors="Elysabeth <105363327+Lysmura@users.noreply.github.com> and contributors",
    sitename="RepTracking.jl",
    format=Documenter.HTML(;
        canonical="https://Lysmura.github.io/RepTracking.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Lysmura/RepTracking.jl",
    devbranch="master",
)
