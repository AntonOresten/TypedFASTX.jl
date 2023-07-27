@testset "typedrecord.jl" begin

    @testset "NoQuality" begin
        rec1 = DNARecord("Ricky", dna"ACGT")

        @test rec1 == DNARecord{NoQuality}("Ricky", dna"ACGT")
        @test rec1 == DNARecord{NoQuality}("Ricky", "ACGT")
        @test rec1 == DNARecord("Ricky", dna"ACGT")
        @test rec1 == DNARecord("Ricky", "ACGT")
        @test rec1 == TypedRecord("Ricky", dna"ACGT")
        @test rec1 == DNARecord{QualityScores}("Ricky", dna"ACGT", NO_QUALITY)

        @test DNARecord("ACGT") == DNARecord("", "ACGT")
    end

    @testset "QualityScores" begin
        rec1 = DNARecord("Ricky", dna"ACGT", QualityScores("!!!!"))

        @test rec1 == DNARecord{QualityScores}("Ricky", dna"ACGT", QualityScores("!!!!"))
        @test rec1 == DNARecord{QualityScores}("Ricky", "ACGT", "!!!!")
        @test rec1 == DNARecord("Ricky", dna"ACGT", "!!!!")
        @test rec1 == DNARecord("Ricky", "ACGT", "!!!!")
        @test rec1 == TypedRecord("Ricky", dna"ACGT", "!!!!")

        @test DNARecord("ACGT", QualityScores("!!!!")) == DNARecord("", "ACGT", "!!!!")
        @test DNARecord(dna"ACGT", QualityScores("!!!!")) == DNARecord("", "ACGT", "!!!!")
    end

    @testset "TypedRecord to TypedRecord" begin
        rec1 = DNARecord("Ricky", dna"ACGT")
        rec2 = DNARecord("Ricky", dna"ACGT", QualityScores("!!!!"))
        
        @test DNARecord{NoQuality}(rec1) == rec1
        @test DNARecord{NoQuality}(rec2) == rec1
        @test DNARecord(rec1) == rec1
        @test DNARecord{QualityScores}(rec2) == rec2
        @test DNARecord(rec2) == rec2
        @test TypedRecord(rec1) == rec1
    end

    @testset "Sorting" begin
        rec1 = DNARecord("Mickey", dna"TGCA")
        rec2 = DNARecord("Ricky", dna"ACGT")
        @test sort([rec1, rec2]) == [rec2, rec1]
    end

    @testset "description vs identifier" begin
        record = AARecord("ricky the record", aa"SMITH")
        @test description(record) == "ricky the record"
        @test identifier(record) == "ricky"
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

end