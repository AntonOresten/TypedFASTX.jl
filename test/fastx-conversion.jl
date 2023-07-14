@testset "fastx-conversion.jl" begin

    fa_record = FASTARecord("Mickey", "SMITH")
    fq_record = FASTQRecord("Ricky", "TTTAA", "Smith")

    @test AARecord{NoQuality}(fa_record) == AARecord("Mickey", "SMitH")
    @test_throws ErrorException AARecord{QualityScores}(fa_record)
    @test AARecord(fa_record) == AARecord("Mickey", "sMiTh")

    @test DNARecord{NoQuality}(fq_record) == DNARecord("Ricky", "TTTAA")
    @test DNARecord{QualityScores}(fq_record) == DNARecord("Ricky", "TTTAA", "Smith")
    @test DNARecord(fq_record) == DNARecord("Ricky", "TTTAA", "Smith")

    @test FASTARecord(AARecord(fa_record)) == fa_record
    @test FASTARecord(DNARecord(fq_record)) == FASTARecord("Ricky", "TTTAA")

    @test_throws ErrorException FASTQRecord(AARecord(fa_record))
    @test FASTQRecord(DNARecord(fq_record)) == fq_record
    @test FASTQRecord(AARecord(fq_record)) == fq_record

end