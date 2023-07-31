module TypedFASTX

export
    # probability.jl
    error_prob_generator,
    error_probs,
    error_rate,

    # quality.jl
    QualityScores,

    # record.jl
    AbstractRecord,
    StringRecord,
    DNARecord,
    RNARecord,
    AARecord,

    # FASTA,
    TypedFASTA,
    TypedFASTARecord,

    # FASTQ,
    TypedFASTQ,
    TypedFASTQRecord,
    QualityScores,

    description,
    identifier,
    sequence,
    quality,
    quality_values,

    # reader.jl
    AbstractReader,
    has_index,
    seekrecord,
    index!,
    StringReader,
    DNAReader,
    RNAReader,
    AAReader

import FASTX
import Statistics
using BioSequences

include("record.jl")
include("reader.jl")
include("writer.jl")
include("quality/quality.jl")

include("FASTA/TypedFASTA.jl")
include("FASTQ/TypedFASTQ.jl")

const TypedFASTARecord = TypedFASTA.Record
const TypedFASTQRecord = TypedFASTQ.Record

const TypedFASTAReader = TypedFASTA.Reader
const TypedFASTQReader = TypedFASTQ.Reader

const TypedFASTAWriter = TypedFASTA.Writer
const TypedFASTQWriter = TypedFASTQ.Writer

import .TypedFASTQ: quality_values

include("conversion.jl")

end
