@testset "writer.jl" begin

    @testset "Writing to IOBuffer" begin
        io = IOBuffer()
        w = TypedFASTQ.Writer{String}(io)
        @test w.path == "no path"
        @test w.io == io
        @test w.position == 1
        write(w, StringRecord("Rick", "ACGT", "!!!!"))
        @test String(take!(io)) == "@Rick\nACGT\n+\n!!!!\n"
    end

    @testset "Writing to file" begin
        path = "temp.fastq"
        w = TypedFASTQ.Writer{String}(path)

        @test repr(w) == "StringWriter(\"temp.fastq\")"
        @test repr("text/plain", w) == "StringWriter (FASTQ format):\n  path: \"temp.fastq\"\n  position: 1"

        @test w.path == path
        @test w.io isa IOStream
        @test w.position == 1
        write(w, StringRecord("Rick", "ACGT", "!!!!"))
        @test_throws ErrorException write(w, StringRecord("Rick", "ACGT"))
        @test_throws MethodError write(w, DNARecord("Rick", "ACGT"))
        close(w)
        @test read(path) == codeunits("@Rick\nACGT\n+\n!!!!\n")
        rm(path)
    end
    
end