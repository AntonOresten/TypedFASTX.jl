@testset "quality.jl" begin

    SANGER = FASTQ.SANGER_QUAL_ENCODING
    SOLEXA = FASTQ.SOLEXA_QUAL_ENCODING

    qs1 = QualityScores("!!!!")
    qs2 = QualityScores("@@@@", SOLEXA)
    @test qs1 == QualityScores("!!!!", SANGER)
    @test qs1 != qs2
    @test qs1.values == qs2.values 
    @test length(qs1) == 4
    @test qs1[1] == 0

    @test QualityScores(qs1) == qs1
    @test String(qs1) == "!!!!"

    io = IOBuffer()
    @test isnothing(show(io, qs1))
    @test String(take!(io)) == "!!!!"

    @test isnothing(show(io, qs2))
    @test String(take!(io)) == "@@@@"

    qs3 = QualityScores("!~")
    qs4 = QualityScores("~!")
    @test reverse(qs3) == qs4
    @test reverse!(qs3) == qs4
    @test qs3 == qs4

    @test summary(qs1) == "QualityScores"

    io = IOBuffer()
    Base.invokelatest(show, io, MIME("text/plain"), qs1)
    str = String(take!(io))
    @test str == "QualityScores:\n  encoding: QualityEncoding(33, 126, 33)\n    values: Int8[0, 0, 0, 0]"

    include("probability.jl")

end