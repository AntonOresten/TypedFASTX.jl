@testset "reader.jl" begin

    fasta_file = "data/seqs.fasta"
    
    @testset "FASTA with index" begin
        reader = TypedFASTA.Reader{LongDNA{4}}(fasta_file, true)
        @test eltype(reader) == TypedFASTA.Record{LongDNA{4}}
        @test eltype(typeof(reader)) == TypedFASTA.Record{LongDNA{4}}
        @test reader.path == fasta_file
        @test reader.reader isa FASTX.FASTA.Reader
        @test reader isa TypedFASTA.Reader{LongDNA{4}}
        @test eltype(reader) <: TypedFASTA.Record{LongDNA{4}}
        @test eltype(typeof(reader)) == eltype(reader)

        @test has_index(reader)
        @test length(reader) == length(reader.reader.index.lengths)
        @test size(reader) == (length(reader), )

        first_index = firstindex(reader)
        last_index = lastindex(reader)
        @test first_index == 1
        @test last_index == length(reader)
        @test eachindex(reader) == firstindex(reader):lastindex(reader)

        rec1 = first(reader)
        @test rec1 == reader["Seq1"]
        @test rec1 == reader[1]
        @test reader[[1,2]] == [reader[1], reader[2]]
        @test reader[1:2] == [reader[1], reader[2]]
        @test_throws ErrorException reader[0:5]

        @test rec1 in reader
        @test !(AARecord("AASeq", "SMITH") in reader)

        @test seekrecord(reader, 1) == 1
        @test rec1 == first(reader)
        seekrecord(reader, 1)
        @test all(in(reader), (r for r in reader))

        seekrecord(reader, 1)
        recs1 = collect(reader)
        @test length(recs1) == 4
        @test eltype(recs1) == eltype(reader)

        seekrecord(reader, 1)
        @test isempty(take!(reader, -1))
        recs2 = take!(reader)
        @test recs1 == recs2
        
        seekrecord(reader, 1)
        @test length(@test_logs (:warn,) take!(reader, 5)) == 4
        
        seekrecord(reader, 1)
        @test isempty(@test_logs (:warn,) take!(reader, 4, max_length=0))
    end

    @testset "FASTA without index" begin
        reader = TypedFASTA.Reader{LongDNA{4}}(fasta_file, false)
        @test_throws ErrorException DNARecord("Seq1", "ACGT") in reader

        recs = collect(reader)
        @test length(recs) == 4
        @test eltype(recs) == eltype(reader)

        @test index!(reader) == reader
        @test seekrecord(reader, 1) == 1
    end

    @testset "show" begin
        @test summary(TypedFASTA.Reader{LongDNA{4}}(fasta_file)) == "DNAReader"
        @test repr(DNAReader(fasta_file)) == "DNAReader(\"data/seqs.fasta\")"
        @test repr("text/plain", DNAReader(fasta_file)) == "DNAReader (FASTA):\n  path: \"data/seqs.fasta\"\n  position: 1" 
    end

end