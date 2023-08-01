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

    @testset "Conversion" begin
        @test FASTX.FASTA.Record("Rick", "ACGT") == convert(FASTX.FASTA.Record, DNARecord("Rick", "ACGT"))
        @test FASTX.FASTA.Record("Rick", "ACGT") == convert(FASTX.FASTA.Record, DNARecord("Rick", "ACGT", "!!!!"))
    end

    @test summary(DNARecord("", "")) == "TypedFASTX.TypedFASTA.Record{LongSequence{DNAAlphabet{4}}}"
end