@testset "record.jl" begin

    @testset "TypedFASTARecord constructor" begin
        record = TypedFASTARecord{LongDNA{4}}("Ricky the Record", "GATTACA")
        @test description(record) == "Ricky the Record"
        @test identifier(record) == "Ricky"
        @test identifier(record) isa SubString
        @test sequence(record) == dna"GATTACA"
        @test sequence(record) isa LongDNA{4}
        @test sequence(LongDNA{4}, record) === sequence(record)
        @test sequence(String, record) == "GATTACA"
    end

    @testset "AbstractRecord alias" begin
        @test DNARecord("Ricky", "GATTACA") == TypedFASTARecord{LongDNA{4}}("Ricky", "GATTACA")
        @test DNARecord("Ricky", "GATTACA") == DNARecord("Ricky", dna"GATTACA")
        @test DNARecord("Ricky", "GATTACA") == DNARecord("Ricky", rna"GAUUACA")
    end
    
end