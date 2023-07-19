@testset "TypedWriter" begin

    @testset "FASTA" begin

        @testset "Writing to IOBuffer" begin
            io = IOBuffer()
            tw = TypedWriter{String, NoQuality}(io)
            @test tw.path == "no path"
            @test tw.io == io
            @test tw.position == 1
            write(tw, StringRecord("Rick", "ACGT"))
            @test String(take!(io)) == ">Rick\nACGT\n"
        end

        @testset "Writing to file" begin
            path = "temp.fasta"
            tw = TypedWriter{String, NoQuality}(path)
            @test tw.path == path
            @test tw.io isa IOStream
            @test tw.position == 1
            write(tw, StringRecord("Rick", "ACGT"))
            close(tw)
            @test read(path) == codeunits(">Rick\nACGT\n")
            rm(path)
        end

    end

    @testset "FASTQ" begin

        @testset "Writing to IOBuffer" begin
            io = IOBuffer()
            tw = TypedWriter{String, QualityScores}(io)
            @test tw.path == "no path"
            @test tw.io == io
            @test tw.position == 1
            write(tw, StringRecord("Rick", "ACGT", "!!!!"))
            @test String(take!(io)) == "@Rick\nACGT\n+\n!!!!\n"
        end
        
    end

end