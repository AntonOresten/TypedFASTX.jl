@testset "writer.jl" begin

    @testset "AbstractWriter" begin
        
        @testset "FASTA" begin
            path = "temp.fasta"
            w = DNAWriter(path)
            @test w.path == path
            write(w, DNARecord("Ricky", "ACGT"))
            close(w)
            @test read("temp.fasta") == codeunits(">Ricky\nACGT\n")
            rm("temp.fasta")
        end

        @testset "FASTQ" begin
            path = "temp.fastq"
            w = DNAWriter(path)
            @test w.path == path
            write(w, DNARecord("Ricky", "ACGT", "!!!!"))
            close(w)
            @test read("temp.fastq") == codeunits("@Ricky\nACGT\n+\n!!!!\n")
            rm("temp.fastq")
        end

        @test_throws ErrorException DNAWriter("invalid.ext")

        @testset "do" begin
            path = "temp.fasta"
            open(DNAWriter(path)) do r
                @test r isa TypedFASTA.Writer
            end
            rm(path)

            path = "temp.fastq"
            open(DNAWriter, path) do r
                @test r isa TypedFASTQ.Writer
            end
            rm(path)
        end

    end

end