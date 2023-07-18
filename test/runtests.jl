using TypedFASTX
using Test
using Logging

using FASTX, BioSequences

@testset "TypedFASTX.jl" begin

    @testset "quality" begin
        include("quality/quality.jl")
    end

    include("record.jl")
    include("conversion.jl")
    include("reader.jl")
end
