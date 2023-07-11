using TypedFASTX
using Test

using FASTX, BioSequences

@testset "TypedFASTX.jl" begin

    @testset "quality" begin
        include("quality/quality.jl")
    end

    @testset "records" begin
        include("record.jl")
    end

    @testset "fastx-conversion" begin
        include("fastx-conversion.jl")
    end

    @testset "README Example" begin
        record1 = DNARecord("Ricky", "ACGTA")
        record2 = DNARecord(FASTARecord("Ricky", "ACGTA"))
        record3 = TypedRecord("Ricky", dna"ACGTA")
        record4 = TypedRecord{LongDNA{4}}("Ricky", "ACGTA")

        @test record1 == record2 == record3 == record4
    end

end
