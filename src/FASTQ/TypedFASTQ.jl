module TypedFASTQ

import ..TypedFASTX:
    AbstractRecord,
    description,
    identifier,
    sequence,
    AbstractReader,
    AbstractWriter,
    QualityScores

import FASTX
using BioSequences

include("record.jl")
include("reader.jl")
include("writer.jl")

end