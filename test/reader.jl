@testset "reader.jl" begin

    @testset "AbstractReader" begin
        
        @testset "FASTA" begin
            path = "data/seqs.fasta"
            r = DNAReader(path)
            @test r.path == path
            @test first(r) == DNARecord("Seq1", "CAGCGAGTCACCCTAGTACGTCAG")
            close(r)
        end
        
        @testset "FASTQ" begin
            path = "data/seqs.fastq"
            r = DNAReader(path)
            @test r.path == path
            @test first(r) == DNARecord("Seq1", "ACGTACGT", "@@@@@@@@")
            close(r)
        end

        @test_throws ErrorException AbstractReader{LongDNA{4}}("invalid.ext")

        @testset "do" begin
            path = "data/seqs.fasta"

            open(DNAReader(path)) do r
                @test r isa DNAReader
            end

            open(DNAReader, path) do r
                @test r isa DNAReader
            end
        end

    end

end