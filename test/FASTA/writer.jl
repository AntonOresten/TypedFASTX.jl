@testset "writer.jl" begin

    @testset "Writing to IOBuffer" begin
        io = IOBuffer()
        w = TypedFASTA.Writer{String}(io)
        @test w.path == "no path"
        @test w.io == io
        @test w.position == 1
        write(w, StringRecord("Rick", "ACGT"))
        @test String(take!(io)) == ">Rick\nACGT\n"
    end

    @testset "Writing to file" begin
        path = "temp.fasta"
        w = TypedFASTA.Writer{String}(path)

        @test repr(w) == "StringWriter(\"temp.fasta\")"
        @test repr("text/plain", w) == "StringWriter (FASTA):\n  path: \"temp.fasta\"\n  position: 1"

        @test w.path == path
        @test w.io isa IOStream
        @test w.position == 1
        record = StringRecord("Rick", "ACGT")
        @test record == write(w, record)
        @test record == write(w, StringRecord("Rick", "ACGT", "!!!!"))
        close(w)
        @test read(path) == codeunits(">Rick\nACGT\n>Rick\nACGT\n")
        rm(path)
    end

end