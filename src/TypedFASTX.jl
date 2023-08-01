module TypedFASTX

export
    # record.jl
    AbstractRecord,
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
    AbstractReader,
    StringReader,
    DNAReader,
    RNAReader,
    AAReader,

    # writer.jl
    StringWriter,
    DNAWriter,
    RNAWriter,
    AAWriter,

    # quality
    error_prob_generator,
    error_probs,
    error_rate,
    QualityScores,

    # FASTA
    TypedFASTA,
    TypedFASTARecord,
    StringFASTARecord,
    DNAFASTARecord,
    RNAFASTARecord,
    AAFASTARecord,
    has_index,
    seekrecord,
    index!,

    # FASTQ
    TypedFASTQ,
    TypedFASTQRecord,
    StringFASTQRecord,
    DNAFASTQRecord,
    RNAFASTQRecord,
    AAFASTQRecord,
    QualityScores,

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
