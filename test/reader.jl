fasta_file = "data/seqs.fasta"
fastq_file = "data/seqs.fastq"

@testset "reader.jl" begin

    @testset "FASTA with index" begin
        tr = TypedReader{LongDNA{4}, NoQuality}(fasta_file, true)
        @test tr.path == fasta_file
        @test tr.reader isa FASTA.Reader
        @test tr.encoding == FASTQ.SANGER_QUAL_ENCODING
        @test tr isa TypedReader{LongDNA{4}, NoQuality, FASTA.Reader}

        @test has_index(tr)
        @test length(tr) == length(tr.reader.index.lengths)
        @test size(tr) == (length(tr), )

        first_index = firstindex(tr)
        last_index = lastindex(tr)
        @test first_index == 1
        @test last_index == length(tr)

        rec1 = first(tr)
        @test rec1 == tr[1]
        @test rec1 in tr
        @test !(AARecord("AASeq", "SMITH") in tr)

        @test seekrecord(tr, 1) == 1
        @test rec1 == first(tr)
        seekrecord(tr, 1)
        @test all(in(tr), (r for r in tr))
    end

    @testset "FASTA without index" begin
        tr = TypedReader{LongDNA{4}, NoQuality}(fasta_file, false)
        @test_throws ErrorException DNARecord("Seq1", "ACGT") in tr
    end

    @testset "FASTQ" begin
        tr = TypedReader{LongDNA{4}, QualityScores}(fastq_file)
        @test tr.path == fastq_file
        @test tr.reader isa FASTQ.Reader
        @test tr.encoding == FASTQ.SANGER_QUAL_ENCODING

        @test_throws MethodError length(tr)
        @test_throws MethodError size(tr)

        first_record = first(tr)
        @test first_record isa TypedRecord{LongDNA{4}, QualityScores}
        @test !(first_record in tr) # even though it's in the file, 
    end

end