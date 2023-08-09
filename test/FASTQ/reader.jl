@testset "reader.jl" begin

    fastq_file = "data/seqs.fastq"

    @testset "FASTQ" begin
        reader = TypedFASTQ.Reader{LongDNA{4}}(fastq_file)
        @test eltype(reader) == TypedFASTQ.Record{LongDNA{4}}
        @test eltype(typeof(reader)) == TypedFASTQ.Record{LongDNA{4}}
        @test reader.path == fastq_file
        @test reader.reader isa FASTQ.Reader
        @test reader.encoding == FASTQ.SANGER_QUAL_ENCODING

        @test_throws MethodError length(reader)
        @test_throws MethodError size(reader)

        first_record = first(reader)
        @test first_record isa TypedFASTQ.Record{LongDNA{4}}
        @test_throws ErrorException first_record in reader # even though it's in the file, 

        @test length(collect(reader)) == 3
        reader = DNAReader(fastq_file)
        @test length(take!(reader)) == 4
        
        reader = DNAReader(fastq_file)
        @test length(take!(reader, max_error_rate=0.0)) == 0
        
        reader = DNAReader(fastq_file)
        @test length(take!(reader, 0)) == 0

        reader = DNAReader(fastq_file)
        @test length(take!(reader, max_length = 0)) == 0

        reader = DNAReader(fastq_file)
        @test_logs (:warn,) @test length(take!(reader, 10)) == 4
    
        io = IOBuffer()
        Base.invokelatest(show, io, MIME("text/plain"), TypedFASTQ.Reader{LongDNA{4}}(fastq_file))
        str = String(take!(io))
        @test str == "TypedFASTQ.Reader{LongSequence{DNAAlphabet{4}}}:\n  path: \"data/seqs.fastq\"\n  position: 1"
    end

    @testset "show" begin

        @test summary(TypedFASTQ.Reader{LongDNA{4}}(fastq_file)) == "TypedFASTQ.Reader{LongSequence{DNAAlphabet{4}}}"

        @testset "compact" begin
            reader = TypedFASTQ.Reader{LongDNA{4}}(fastq_file)
            io = IOBuffer()
            @test isnothing(show(io, reader))
            str = String(take!(io))
            @test str == "TypedFASTQ.Reader{LongSequence{DNAAlphabet{4}}}(\"data/seqs.fastq\")"
        end

        @testset "long" begin
            reader = TypedFASTQ.Reader{LongDNA{4}}(fastq_file)
            io = IOBuffer()
            Base.invokelatest(show, io, MIME("text/plain"), reader)
            str = String(take!(io))
            @test str == "TypedFASTQ.Reader{LongSequence{DNAAlphabet{4}}}:\n  path: \"data/seqs.fastq\"\n  position: 1" 
        end

    end

end