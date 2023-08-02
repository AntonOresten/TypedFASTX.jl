@testset "record.jl" begin

    @testset "TypedFASTQRecord constructor" begin
        record = TypedFASTQRecord{LongDNA{4}}("Ricky the Record", "ACGT", "!!!!")
        @test description(record) == "Ricky the Record"
        @test identifier(record) == "Ricky"
        @test identifier(record) isa SubString
        @test sequence(record) == dna"ACGT"
        @test sequence(LongDNA{4}, record) === sequence(record)
        @test sequence(String, record) == "ACGT"
        @test quality(record) == QualityScores("!!!!")
        @test quality_values(record) == Int8[0, 0, 0, 0]
        @test quality(record) == quality(TypedFASTQRecord{LongDNA{4}}("Ricky the Record", "ACGT", QualityScores("!!!!", FASTQ.SANGER_QUAL_ENCODING)))
        @test quality_values(record) == quality_values(TypedFASTQRecord{LongDNA{4}}("Ricky the Record", "ACGT", QualityScores("@@@@", FASTQ.SOLEXA_QUAL_ENCODING)))
    end

    @testset "Conversion" begin
        @test DNARecord("Rick", "ACGT", "!!!!") == convert(TypedFASTQ.Record{LongDNA{4}}, DNARecord("Rick", "ACGT", "!!!!"))
        @test DNARecord("Rick", "ACGT", "!!!!") == convert(TypedFASTQ.Record{LongDNA{4}}, FASTX.FASTQ.Record("Rick", "ACGT", "!!!!"))
        @test FASTX.FASTQ.Record("Rick", "ACGT", "!!!!") == convert(FASTX.FASTQ.Record, DNARecord("Rick", "ACGT", "!!!!"))
    end

    @testset "TypedRecord alias" begin
        @test DNARecord("Rick", "ACGT", "!!!!") == TypedFASTQRecord{LongDNA{4}}("Rick", "ACGT", "!!!!")
        @test DNARecord("Rick", "ACGT", "!!!!") == DNARecord("Rick", dna"ACGT", "!!!!")
        @test DNARecord("Rick", "ACGT", "!!!!") == DNARecord("Rick", rna"ACGU", "!!!!")
    end

    @testset "Hashing" begin
        @test hash(DNARecord("Ricky", "ACGT", "!!!!")) == hash(DNARecord("Ricky", "ACGT", "!!!!"))
        @test hash(DNARecord("Ricky", "ACGT", "!!!!")) != hash(DNARecord("Rick", "ACGT", "!!!!"))
        @test hash(DNARecord("Ricky", "ACGT", "!!!!")) != hash(DNARecord("Ricky", "TGCA", "!!!!"))
        @test hash(DNARecord("Ricky", "ACGT", "!!!!")) != hash(DNARecord("Ricky", "ACGT", "~~~~"))

        record_set = Set{DNARecord}()
        push!(record_set, DNARecord("Ricky", "ACGT", "!!!!"))
        @test DNARecord("Ricky", "ACGT", "!!!!") in record_set
        @test !(DNARecord("Ricky", "ACGT") in record_set)
    end

    @testset "reverse_complement" begin
        record = DNARecord("", "AC", QualityScores("!~"))
        record_rc = DNARecord("", "GT", QualityScores("~!"))
        @test reverse_complement(record) == record_rc
        reverse_complement!(record)
        @test record == record_rc
    end

    @testset "Quality" begin
        record = DNARecord("", "ACGT", "!!!!")
        @test quality(record) == QualityScores("!!!!")
        @test quality_values(record) == Int8[0, 0, 0, 0]
    end
    
    @testset "show" begin
        @test sprint(show, DNARecord("Ricky", "ACGT", "!!!!")) == "TypedFASTX.TypedFASTQ.Record{LongSequence{DNAAlphabet{4}}}(\"Ricky\", \"ACGT\", \"!!!!\")"
    
        io = IOBuffer()
        Base.invokelatest(show, io, MIME("text/plain"), DNARecord("Ricky", "ACGT", "!!!!"))
        str = String(take!(io))
        @test str == "TypedFASTX.TypedFASTQ.Record{LongSequence{DNAAlphabet{4}}}:\n description: \"Ricky\"\n    sequence: \"ACGT\"\n     quality: \"!!!!\""    
    end
    
end