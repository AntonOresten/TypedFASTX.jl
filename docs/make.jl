push!(LOAD_PATH, "../src/")

using TypedFASTX
using Documenter

makedocs(
    sitename = "TypedFASTX.jl",
    modules = [TypedFASTX],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo = "github.com/anton083/TypedFASTX.jl.git",
    branch = "gh-pages",
    devbranch = "dev",
)