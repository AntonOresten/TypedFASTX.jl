@testset "record.jl" begin

    @testset "Length" begin
        @test length(DNARecord("Ricky", "ACGT")) == 4
        @test length(DNARecord("Ricky", "ACGT", QualityScores("!!!!"))) == 4
    end

    @testset "Sorting" begin
        rec1 = DNARecord("Mickey", "TGCA")
        rec2 = DNARecord("Ricky", "ACGT")
        @test sort([rec1, rec2]) == [rec2, rec1]
    end

    @testset "description vs identifier" begin
        record = AARecord("ricky the record", aa"SMITH")
        @test description(record) == "ricky the record"
        @test identifier(record) == "ricky"

        @test identifier(DNARecord("", "ACGT")) == ""
    end

    @testset "sequence" begin
        record = DNARecord("Ricky", "ACGT")
        @test sequence(record) == dna"ACGT"
        @test sequence(LongDNA{4}, record) == dna"ACGT"
        @test sequence(LongDNA{4}, record) === record.sequence
        @test sequence(String, record) == "ACGT"
    end

    #=

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