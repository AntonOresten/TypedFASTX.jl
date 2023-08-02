@testset "probability.jl" begin
    record = DNARecord("", "ACGT", "!!~~")
    @test error_prob_generator(record) == error_prob_generator(record.quality)
    @test error_probs(record) == error_probs(record.quality)
    @test error_rate(record) == sum(error_probs(record)) / length(record)
    @test error_count(record) == sum(error_probs(record))
end