@testset "encodings" begin

    @test TypedFASTX.QUALITY_ENCODINGS[:sanger] == FASTQ.SANGER_QUAL_ENCODING
    @test TypedFASTX.encoding_name_to_quality_encoding(:sanger) == TypedFASTX.encoding_name_to_quality_encoding(:SANGER)
    
end