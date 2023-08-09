module TypedFASTQ

import ..TypedFASTX:
    TypedRecord,
    description,
    identifier,
    sequence,
    TypedReader,
    TypedWriter,
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