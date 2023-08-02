module TypedFASTA

import ..TypedFASTX:
    TypedRecord,
    description,
    identifier,
    sequence,
    AbstractReader,
    AbstractWriter

import FASTX
using BioSequences

include("record.jl")
include("reader.jl")
include("writer.jl")

end