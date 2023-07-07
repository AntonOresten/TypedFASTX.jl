@testset "fastx-conversion.jl" begin

    fa_record = FASTARecord("Mickey", "SMITH")
    fq_record = FASTQRecord("Ricky", "TTTAA", "Smith")
    
    @test AARecord(fa_record) == AARecord("Mickey", "sMiTh")
    @test_throws ErrorException DNARecord(fa_record)

    @test DNARecord(fq_record) == DNARecord("Ricky", "TTTAA", "Smith")
    @test RNARecord(DNARecord(fq_record)) == RNARecord("Ricky", "UUUAA", "Smith")

    @test FASTARecord(AARecord(fa_record)) == fa_record
    @test FASTARecord(DNARecord(fq_record)) == FASTARecord("Ricky", "TTTAA")

    @test FASTQRecord(DNARecord(fq_record)) == fq_record
    @test FASTQRecord(AARecord(fq_record)) == fq_record
    @test_throws ErrorException FASTQRecord(AARecord(fa_record))

end