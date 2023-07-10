@testset "quality.jl" begin
    
    @test NoQuality <: TypedFASTX.AbstractQuality
    @test NO_QUALITY isa NoQuality

end

include("encodings.jl")
include("qualityscores.jl")
include("probability.jl")