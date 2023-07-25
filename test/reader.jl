fasta_file = "data/seqs.fasta"
fastq_file = "data/seqs.fastq"

@testset "reader.jl" begin

    @testset "Show reader" begin
        tr = TypedReader{LongDNA{4}, NoQuality}(fasta_file)
        io = IOBuffer()
        @test isnothing(show(io, tr))
        @test String(take!(io)) == "DNAReader{NoQuality}(\"data/seqs.fasta\", 1)"

        tr = TypedReader{LongDNA{2}, NoQuality}(fasta_file)
        io = IOBuffer()
        Base.invokelatest(show, io, MIME("text/plain"), tr)
        str = String(take!(io))
        @test str == "TypedReader{LongSequence{DNAAlphabet{2}}, NoQuality}\n  path: \"data/seqs.fasta\"\n  position: 1"
    end

    @testset "FASTA with index" begin
        tr = TypedReader{LongDNA{4}, NoQuality}(fasta_file, true)
        @test tr.path == fasta_file
        @test tr.reader isa FASTA.Reader
        @test tr isa TypedReader{LongDNA{4}, NoQuality}
        @test eltype(tr) <: TypedRecord{LongDNA{4}, NoQuality}
        @test eltype(typeof(tr)) == eltype(tr)

        @test has_index(tr)
        @test length(tr) == length(tr.reader.index.lengths)
        @test size(tr) == (length(tr), )

        first_index = firstindex(tr)
        last_index = lastindex(tr)
        @test first_index == 1
        @test last_index == length(tr)
        @test eachindex(tr) == firstindex(tr):lastindex(tr)

        rec1 = first(tr)
        @test rec1 == tr["Seq1"]
        @test rec1 == tr[1]
        @test tr[[1,2]] == [tr[1], tr[2]]
        @test tr[1:2] == [tr[1], tr[2]]
        @test_throws ErrorException tr[0:5]

        @test rec1 in tr
        @test !(AARecord("AASeq", "SMITH") in tr)

        @test seekrecord(tr, 1) == 1
        @test rec1 == first(tr)
        seekrecord(tr, 1)
        @test all(in(tr), (r for r in tr))

        seekrecord(tr, 1)
        recs1 = collect(tr)
        @test length(recs1) == 4
        @test eltype(recs1) == eltype(tr)

        seekrecord(tr, 1)
        @test isempty(take!(tr, -1))
        recs2 = take!(tr)
        @test recs1 == recs2
        
        seekrecord(tr, 1)
        @test length(@test_logs (:warn,) take!(tr, 5)) == 4
        
        seekrecord(tr, 1)
        @test isempty(@test_logs (:warn,) take!(tr, 4, max_length=0))
    end

    @testset "FASTA without index" begin
        tr = TypedReader{LongDNA{4}, NoQuality}(fasta_file, false)
        @test_throws ErrorException DNARecord("Seq1", "ACGT") in tr

        recs = collect(tr)
        @test length(recs) == 4
        @test eltype(recs) == eltype(tr)

        @test index!(tr) == tr
        @test seekrecord(tr, 1) == 1
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
        @test_throws ErrorException first_record in tr # even though it's in the file, 

        @test length(collect(tr)) == 3
        tr = TypedReader{LongDNA{4}, QualityScores}(fastq_file)
        @test length(take!(tr)) == 4
    end

end