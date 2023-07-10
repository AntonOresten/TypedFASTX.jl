@testset "qualityscores.jl" begin

    qs1 = QualityScores("!!!!", :sanger)
    qs2 = QualityScores("@@@@", :solexa)
    @test qs1 != qs2
    @test qs1.values == qs2.values 

    @test QualityScores(qs1) == qs1
    @test String(qs1) == "!!!!"

    io = IOBuffer()
    @test isnothing(show(io, qs1))
    @test String(take!(io)) == "!!!!"

    @test isnothing(show(io, qs2))
    @test String(take!(io)) == "@@@@"

end