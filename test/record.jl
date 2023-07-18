@testset "typedrecord.jl" begin

    rec1 = DNARecord("Rick", "ACGT", "!!!!")

    @test rec1 == DNARecord("Rick", dna"ACGT", "!!!!")
    @test rec1 == TypedRecord("Rick", dna"ACGT", "!!!!")
    @test rec1 == DNARecord("Rick", rna"ACGU", "!!!!")
    @test rec1 == DNARecord(RNARecord("Rick", rna"ACGU", "!!!!"))
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

    rec6 = DNARecord("", "ACGT", QualityScores(";;;;", :solexa))
    @test all(>(0.75), error_prob_generator(rec6))

    rec7 = DNARecord("Rick", "ACGT")
    io = IOBuffer()
    Base.print(io, rec7)
    output = String(take!(io))
    @test output == ">Rick\nACGT"

    rec8 = DNARecord("Rick", "ACGT", "!!!!")
    io = IOBuffer()
    Base.print(io, rec8)
    output = String(take!(io))
    @test output == "@Rick\nACGT\n+\n!!!!"

    @test sprint(show, rec1) == "DNARecord(\"Rick\", \"ACGT\", \"!!!!\")"

    io = IOBuffer()
    Base.invokelatest(show, io, MIME("text/plain"), rec1)
    str = String(take!(io))
    @test str == "DNARecord:\n identifier: \"Rick\"\n   sequence: \"ACGT\"\n    quality: \"!!!!\""

end