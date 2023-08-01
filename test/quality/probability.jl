@testset "probability.jl" begin

    SANGER = FASTQ.SANGER_QUAL_ENCODING
    SOLEXA = FASTQ.SOLEXA_QUAL_ENCODING

    @test TypedFASTX.error_prob_function(SANGER) == TypedFASTX.phred_to_p
    @test TypedFASTX.error_prob_function(SOLEXA) == TypedFASTX.solexa_to_p

    qs1 = QualityScores("!!!!", SANGER)
    qs2 = QualityScores("~~~~", SOLEXA)
    @test all(==(1.0), error_prob_generator(qs1))
    @test all(<(1e-6), error_prob_generator(qs2))

    @test error_probs(qs1) == collect(error_prob_generator(qs1))
    @test error_probs(qs2) == collect(error_prob_generator(qs2))

    qs3 = QualityScores(";;;;", SOLEXA)
    @test all(>(0.75), error_prob_generator(qs3))

    @test error_rate(qs1) == 1.0
    @test error_count(qs1) == 4.0

end