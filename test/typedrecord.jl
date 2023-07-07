include("quality/quality.jl")

@testset "typedrecord.jl" begin

    rec1 = DNARecord("Rick", "ACGT", "!!!!")

    @test rec1 == DNARecord("Rick", dna"ACGT", "!!!!")
    @test rec1 == TypedRecord("Rick", dna"ACGT", "!!!!")
    @test rec1 == DNARecord("Rick", rna"ACGU", "!!!!")
    @test rec1 == DNARecord(rec1)

    @test identifier(rec1) == "Rick"
    @test sequence(rec1) == dna"ACGT"
    @test sequence(String, rec1) == "ACGT"

    rec2 = DNARecord("Rick", "ACGT", QualityScores("@@@@", :solexa))
    @test rec1 != rec2
    @test rec1.quality.values == rec2.quality.values

    rec3 = TypedRecord("Morty", "Smith", "!!!!!")
    @test rec3 isa StringRecord
    @test AARecord(rec3) == TypedRecord("Morty", aa"SMITH", "!!!!!")

end

include("fastx-conversion.jl")