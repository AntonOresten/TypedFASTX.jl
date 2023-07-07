using TypedFASTX
using Test

using FASTX, BioSequences

@testset "TypedFASTX.jl" begin

    @testset "typedrecords" begin
        include("quality/quality.jl")
    end

    @testset "typedrecords" begin
        include("typedrecord.jl")
    end

    @testset "typedrecords" begin
        include("fastx-conversion.jl")
    end

    @testset "README Example" begin
        record1 = DNARecord("Ricky", "ACGTA")
        record2 = TypedRecord("Ricky", dna"ACGTA")
        record3 = DNARecord(FASTARecord("Ricky", "ACGTA"))

        @test record1 == record2 == record3
    end

end
