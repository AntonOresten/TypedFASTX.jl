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
    StringFASTARecord,
    DNAFASTARecord,
    RNAFASTARecord,
    AAFASTARecord,

    # FASTQ,
    TypedFASTQ,
    TypedFASTQRecord,
    StringFASTQRecord,
    DNAFASTQRecord,
    RNAFASTQRecord,
    AAFASTQRecord,
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
    AAReader,

    # writer.jl
    StringWriter,
    DNAWriter,
    RNAWriter,
    AAWriter,

    TypedFASTARecord,
    TypedFASTQRecord,

    TypedFASTAReader,
    TypedFASTQReader,

    TypedFASTAWriter,
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
const TypedFASTQRecord = TypedFASTQ.Record

const TypedFASTAReader = TypedFASTA.Reader
const TypedFASTQReader = TypedFASTQ.Reader

const TypedFASTAWriter = TypedFASTA.Writer
const TypedFASTQWriter = TypedFASTQ.Writer

import .TypedFASTA: has_index
import .TypedFASTQ: quality_values

end
