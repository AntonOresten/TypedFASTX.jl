@testset "writer.jl" begin

    @testset "Writing to IOBuffer" begin
        io = IOBuffer()
        tw = TypedFASTA.Writer{String}(io)
        @test tw.path == "no path"
        @test tw.io == io
        @test tw.position == 1
        write(tw, StringRecord("Rick", "ACGT"))
        @test String(take!(io)) == ">Rick\nACGT\n"
    end

    @testset "Writing to file" begin
        path = "temp.fasta"
        tw = TypedFASTA.Writer{String}(path)
        @test tw.path == path
        @test tw.io isa IOStream
        @test tw.position == 1
        write(tw, StringRecord("Rick", "ACGT"))
        close(tw)
        @test read(path) == codeunits(">Rick\nACGT\n")
        rm(path)
    end

end