module TypedFASTA

import ..TypedFASTX:
    TypedRecord,
    description,
    identifier,
    sequence,
    TypedReader,
    TypedWriter

import FASTX
using BioSequences

include("record.jl")
include("reader.jl")
include("writer.jl")

end