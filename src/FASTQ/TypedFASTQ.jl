module TypedFASTQ

import ..TypedFASTX:
    AbstractRecord,
    description,
    identifier,
    sequence,
    AbstractReader,
    AbstractWriter,
    QualityScores,
    error_prob_generator,
    error_probs,
    error_rate,
    error_count

import FASTX
using BioSequences

include("record.jl")
include("reader.jl")
include("writer.jl")
include("probability.jl")

end