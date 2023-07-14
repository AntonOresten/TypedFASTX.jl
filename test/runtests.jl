using TypedFASTX
using Test

using FASTX, BioSequences

@testset "TypedFASTX.jl" begin

    @testset "quality" begin
        include("quality/quality.jl")
    end

    include("record.jl")
    include("fastx-conversion.jl")
    include("reader.jl")
end
