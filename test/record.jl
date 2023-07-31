@testset "record.jl" begin

    #=
    @testset "Sorting" begin
        rec1 = DNARecord("Mickey", dna"TGCA")
        rec2 = DNARecord("Ricky", dna"ACGT")
        @test sort([rec1, rec2]) == [rec2, rec1]
    end

    @testset "description vs identifier" begin
        record = AARecord("ricky the record", aa"SMITH")
        @test description(record) == "ricky the record"
        @test identifier(record) == "ricky"

        @test identifier(DNARecord("", "ACGT")) == ""
    end

    @testset "reverse_complement" begin
        rec1 = DNARecord("AC")
        rec2 = DNARecord("AC", QualityScores("!~"))

        @test reverse_complement(rec1) == DNARecord("GT")
        @test reverse_complement(rec2) == DNARecord("GT", QualityScores("~!"))

        reverse_complement!(rec1)
        reverse_complement!(rec2)
        @test rec1 == DNARecord("GT")
        @test rec2 == DNARecord("GT", QualityScores("~!"))
    end

    rec0 = DNARecord("Ricky", dna"ACGT")
    rec1 = DNARecord("Ricky", dna"ACGT", QualityScores("!!!!"))

    @test hash(rec0) == hash(DNARecord("Ricky", dna"ACGT"))

    @test length(rec1) == 4

    @test description(rec1) == "Ricky"
    @test sequence(rec1) == dna"ACGT"
    @test sequence(LongDNA{4}, rec1) == dna"ACGT"
    @test sequence(String, rec1) == "ACGT"

    @test quality(rec1) == QualityScores(Int8[0, 0, 0, 0], FASTQ.SANGER_QUAL_ENCODING)
    @test quality_values(rec1) == Int8[0, 0, 0, 0]

    rec2 = DNARecord("Ricky", "ACGT", QualityScores("@@@@", :solexa))
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

    rec7 = DNARecord("Ricky", "ACGT")
    io = IOBuffer()
    Base.print(io, rec7)
    output = String(take!(io))
    @test output == ">Ricky\nACGT"

    rec8 = DNARecord("Ricky", "ACGT", "!!!!")
    io = IOBuffer()
    Base.print(io, rec8)
    output = String(take!(io))
    @test output == "@Ricky\nACGT\n+\n!!!!"

    @test sprint(show, rec0) == "DNARecord(\"Ricky\", \"ACGT\")"
    @test sprint(show, rec1) == "DNARecord(\"Ricky\", \"ACGT\", \"!!!!\")"

    io = IOBuffer()
    Base.invokelatest(show, io, MIME("text/plain"), DNARecord("Ricky", "ACGT"))
    str = String(take!(io))
    @test str == "DNARecord:\n description: \"Ricky\"\n   sequence: \"ACGT\""

    io = IOBuffer()
    Base.invokelatest(show, io, MIME("text/plain"), DNARecord("Ricky", "ACGT", "!!!!"))
    str = String(take!(io))
    @test str == "DNARecord:\n description: \"Ricky\"\n   sequence: \"ACGT\"\n    quality: \"!!!!\""
    =#
end