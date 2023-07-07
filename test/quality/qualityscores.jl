@testset "qualityscores.jl" begin

    qs1 = QualityScores("!!!!", :sanger)
    qs2 = QualityScores("@@@@", :solexa)
    @test qs1 != qs2
    @test qs1.values == qs2.values 

    @test QualityScores(nothing) === nothing
    @test QualityScores(qs1) == qs1
    @test String(qs1) == "!!!!"

end