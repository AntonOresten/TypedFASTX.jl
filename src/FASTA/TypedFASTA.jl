module TypedFASTA

import ..TypedFASTX: AbstractRecord, description, identifier, sequence, AbstractWriter

import FASTX
using BioSequences

include("record.jl")
include("reader.jl")
include("writer.jl")

end