@testset "probability.jl" begin
    


    @test TypedFASTX.error_prob_function(FASTQ.SANGER_QUAL_ENCODING) == TypedFASTX.phred_to_p
    @test TypedFASTX.error_prob_function(FASTQ.SOLEXA_QUAL_ENCODING) == TypedFASTX.solexa_to_p

    qs1 = QualityScores("!!!!", :sanger)
    qs2 = QualityScores("~~~~", :sanger)
    @test all(==(1.0), error_prob_generator(qs1))
    @test all(<(1e-5), error_prob_generator(qs2))

    @test error_probs(qs1) == collect(error_prob_generator(qs1))
    @test error_rate(qs1) == 1.0
    @test error_rate(qs2) < 1e-5

    qs3 = QualityScores(";;;;", :solexa)
    @test all(>(0.75), error_prob_generator(qs3))

end