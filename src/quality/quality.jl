# for converting formats specified by the user to FASTQ QualityEncodings
const QUALITY_ENCODINGS = Dict{Symbol, QualityEncoding}(
    :sanger     => FASTQ.SANGER_QUAL_ENCODING,
    :solexa     => FASTQ.SOLEXA_QUAL_ENCODING,
    :illumina13 => FASTQ.ILLUMINA13_QUAL_ENCODING,
    :illumina15 => FASTQ.ILLUMINA15_QUAL_ENCODING,
    :illumina18 => FASTQ.ILLUMINA18_QUAL_ENCODING,
)

qualformat_to_quality_encoding(s::Symbol) = QUALITY_ENCODINGS[Symbol(lowercase(String(s)))]

include("qualityscores.jl")
include("probability.jl")

"Used in place of QualityScores to denote lack of quality scores."
struct NoQuality end

"A constant instance of the type `NoQuality`."
const NO_QUALITY = NoQuality()

const QualityTypes = Union{NoQuality, QualityScores}