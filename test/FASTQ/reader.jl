@testset "reader.jl" begin

    fastq_file = "data/seqs.fastq"

    @testset "FASTQ" begin
        reader = TypedFASTQ.Reader{LongDNA{4}}(fastq_file)
        @test reader.path == fastq_file
        @test reader.reader isa FASTQ.Reader
        @test reader.encoding == FASTQ.SANGER_QUAL_ENCODING

        @test_throws MethodError length(reader)
        @test_throws MethodError size(reader)

        first_record = first(reader)
        @test first_record isa TypedFASTQ.Record{LongDNA{4}}
        @test_throws ErrorException first_record in reader # even though it's in the file, 

        @test length(collect(reader)) == 3
        reader = TypedFASTQ.Reader{LongDNA{4}}(fastq_file)
        @test length(take!(reader)) == 4
    end

end