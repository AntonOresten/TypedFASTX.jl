@testset "typedrecord.jl" begin

    rec1 = DNARecord("Rick", "ACGT", "!!!!")

    @test rec1 == DNARecord("Rick", dna"ACGT", "!!!!")
    @test rec1 == TypedRecord("Rick", dna"ACGT", "!!!!")
    @test rec1 == DNARecord("Rick", rna"ACGU", "!!!!")
    @test rec1 == DNARecord(rec1)

    @test length(rec1) == 4

    @test identifier(rec1) == "Rick"
    @test sequence(rec1) == dna"ACGT"
    @test sequence(String, rec1) == "ACGT"

    @test quality(rec1) == QualityScores(Int8[0, 0, 0, 0], FASTQ.SANGER_QUAL_ENCODING)
    @test quality_values(rec1) == Int8[0, 0, 0, 0]

    rec2 = DNARecord("Rick", "ACGT", QualityScores("@@@@", :solexa))
    @test rec1 != rec2
    @test quality_values(rec1) == quality_values(rec2)

    rec3 = TypedRecord("Morty", "Smith", "!!!!!")
    @test rec3 isa StringRecord
    @test AARecord(rec3) == TypedRecord("Morty", aa"SMITH", "!!!!!")
    
    rec4 = DNARecord("", "ACGT", "!!!!")
    rec5 = DNARecord("", "ACTG", "~~~~")
    @test all(==(1.0), error_prob_generator(rec4))
    @test all(<(1e-5), error_prob_generator(rec5))

    @test error_probs(rec4) == collect(error_prob_generator(rec4))
    @test error_rate(rec4) == 1.0
    @test error_rate(rec5) < 1e-5

end