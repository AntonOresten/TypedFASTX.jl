@testset "record.jl" begin

    @testset "TypedFASTARecord constructor" begin
        record = TypedFASTARecord{LongDNA{4}}("Ricky the Record", "GATTACA")
        @test description(record) == "Ricky the Record"
        @test identifier(record) == "Ricky"
        @test identifier(record) isa SubString
        @test sequence(record) == dna"GATTACA"
        @test sequence(record) isa LongDNA{4}
        @test sequence(LongDNA{4}, record) === sequence(record)
        @test sequence(String, record) == "GATTACA"

        @test DNARecord("GATTACA") == DNARecord("", "GATTACA")
    end

    @testset "Conversion" begin
        @test DNARecord("Rick", "ACGT") == convert(TypedFASTA.Record{LongDNA{4}}, DNARecord("Rick", "ACGT"))
        @test DNARecord("Rick", "ACGT") == convert(TypedFASTA.Record{LongDNA{4}}, DNARecord("Rick", "ACGT", "!!!!"))
        @test DNARecord("Rick", "ACGT") == convert(TypedFASTA.Record{LongDNA{4}}, FASTX.FASTA.Record("Rick", "ACGT"))
        @test DNARecord("Rick", "ACGT") == convert(TypedFASTA.Record{LongDNA{4}}, FASTX.FASTQ.Record("Rick", "ACGT", "!!!!"))
    end

    @testset "TypedRecord alias" begin
        @test DNARecord("Ricky", "GATTACA") == TypedFASTARecord{LongDNA{4}}("Ricky", "GATTACA")
        @test DNARecord("Ricky", "GATTACA") == DNARecord("Ricky", dna"GATTACA")
        @test DNARecord("Ricky", "GATTACA") == DNARecord("Ricky", rna"GAUUACA")
    end

    @testset "Hashing" begin
        @test hash(DNARecord("Ricky", "ACGT")) == hash(DNARecord("Ricky", "ACGT"))
        @test hash(DNARecord("Ricky", "ACGT")) != hash(DNARecord("Rick", "ACGT"))
        @test hash(DNARecord("Ricky", "ACGT")) != hash(DNARecord("Ricky", "TGCA"))
        @test hash(DNARecord("Ricky", "ACGT")) != hash(DNARecord("Ricky", "ACGT", "!!!!"))

        record_set = Set{DNARecord}()
        push!(record_set, DNARecord("Ricky", "ACGT"))
        @test DNARecord("Ricky", "ACGT") in record_set
        @test !(DNARecord("Ricky", "ACGT", "!!!!") in record_set)
    end

    @testset "reverse_complement" begin
        record = DNARecord("", "AC")
        record_rc = DNARecord("", "GT")
        @test reverse_complement(record) == record_rc
        reverse_complement!(record)
        @test record == record_rc
    end
    
    @testset "show" begin
        @test repr(DNARecord("Ricky", "ACGT")) == "DNARecord(\"Ricky\", \"ACGT\")"
        @test repr("text/plain", DNARecord("Ricky", "ACGT")) == "DNARecord:\n description: \"Ricky\"\n    sequence: \"ACGT\""  
    end

end