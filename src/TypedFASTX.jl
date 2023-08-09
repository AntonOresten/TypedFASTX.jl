module TypedFASTX

export
    # record.jl
    TypedRecord,
    StringRecord,
    DNARecord,
    RNARecord,
    AARecord,

    description,
    identifier,
    sequence,
    quality,
    quality_values,

    # reader.jl
    TypedReader,
    StringReader,
    DNAReader,
    RNAReader,
    AAReader,

    # writer.jl
    TypedWriter,
    StringWriter,
    DNAWriter,
    RNAWriter,
    AAWriter,

    # quality
    error_prob_generator,
    error_probs,
    error_rate,
    error_count,
    QualityScores,

    # FASTA
    TypedFASTA,
    TypedFASTARecord,
    has_index,
    seekrecord,
    index!,

    TypedFASTARecord,
    TypedFASTAReader,
    TypedFASTAWriter,

    # FASTQ
    TypedFASTQ,
    TypedFASTQRecord,
    QualityScores,

    TypedFASTQRecord,
    TypedFASTQReader,
    TypedFASTQWriter

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
const TypedFASTAReader = TypedFASTA.Reader
const TypedFASTAWriter = TypedFASTA.Writer

const TypedFASTQRecord = TypedFASTQ.Record
const TypedFASTQReader = TypedFASTQ.Reader
const TypedFASTQWriter = TypedFASTQ.Writer

import .TypedFASTA: has_index
import .TypedFASTQ: quality_values

end
