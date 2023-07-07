@testset "quality.jl" begin

    @test TypedFASTX.QUALITY_ENCODINGS[:sanger] == FASTQ.SANGER_QUAL_ENCODING
    @test TypedFASTX.qualformat_to_quality_encoding(:sanger) == TypedFASTX.qualformat_to_quality_encoding(:SANGER)

end

include("qualityscores.jl")
include("probability.jl")