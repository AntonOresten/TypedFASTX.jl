using TypedFASTX
using Test

using FASTX, BioSequences

@testset "TypedFASTX.jl" begin

    @testset "typedrecords" begin
        include("quality/quality.jl")
    end

    @testset "typedrecords" begin
        include("typedrecord.jl")
    end

    @testset "typedrecords" begin
        include("fastx-conversion.jl")
    end

end
