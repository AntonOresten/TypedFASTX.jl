using TypedFASTX
using Documenter

DocMeta.setdocmeta!(TypedFASTX, :DocTestSetup, :(using TypedFASTX); recursive=true)

makedocs(;
    modules=[TypedFASTX],
    authors="Anton Sollman <anton.sollman@outlook.com>",
    repo="https://github.com/anton083/TypedFASTX.jl/blob/{commit}{path}#{line}",
    sitename="TypedFASTX.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://anton083.github.io/TypedFASTX.jl",
        edit_link="dev",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/anton083/TypedFASTX.jl",
    devbranch="dev",
)
