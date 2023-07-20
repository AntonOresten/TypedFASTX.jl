@testset "qualityscores.jl" begin

    qs1 = QualityScores("!!!!")
    qs2 = QualityScores("@@@@", :solexa)
    @test qs1 == QualityScores("!!!!", :sanger)
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

    @test summary(qs1) == "QualityScores"

    io = IOBuffer()
    Base.invokelatest(show, io, MIME("text/plain"), qs1)
    str = String(take!(io))
    @test str == "QualityScores:\n  encoding: QualityEncoding(33, 126, 33)\n    values: Int8[0, 0, 0, 0]"

end