using TypedFASTX
using Test
using Logging

using FASTX, BioSequences

@testset "TypedFASTX.jl" begin

    include("record.jl")
    include("reader.jl")
    include("writer.jl")
    include("quality/quality.jl")

    include("FASTA/TypedFASTA.jl")
    include("FASTQ/TypedFASTQ.jl")

end
