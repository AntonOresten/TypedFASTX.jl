"""
    AbstractRecord{T}

Abstract type for typed FASTX records.
"""
abstract type AbstractRecord{T} end

"""
    StringRecord

Alias for `AbstractRecord{String}`. Can be used for constructing TypedFASTA.Record{String} and TypedFASTQ.Record{String} instances. 
"""
const StringRecord = AbstractRecord{String}

"""
    DNARecord

Alias for `AbstractRecord{LongDNA{4}}`. Can be used for constructing TypedFASTA.Record{LongDNA{4}} and TypedFASTQ.Record{LongDNA{4}} instances. 
"""
const DNARecord = AbstractRecord{LongDNA{4}}

"""
    RNARecord

Alias for `AbstractRecord{LongRNA{4}}`. Can be used for constructing TypedFASTA.Record{LongRNA{4}} and TypedFASTQ.Record{LongRNA{4}} instances. 
"""
const RNARecord = AbstractRecord{LongRNA{4}}

"""
    AARecord

Alias for `AbstractRecord{LongAA}`. Can be used for constructing TypedFASTA.Record{LongAA} and TypedFASTQ.Record{LongAA} instances. 
"""
const AARecord = AbstractRecord{LongAA}

@inline Base.length(record::AbstractRecord) = length(record.sequence)
@inline Base.isless(r1::AbstractRecord, r2::AbstractRecord) = isless(r1.sequence, r2.sequence)

import FASTX: description, identifier, sequence

"""
    description(record::AbstractRecord)::String

Get the entire description of `record`. Returns a String.
"""
@inline description(record::AbstractRecord) = record.description

"""
    identifier(record::AbstractRecord)::SubString{String}

Get the identifier of `record`. The identifier is the first "word" of the description. Returns a SubString{String}.
"""
@inline identifier(record::AbstractRecord) = first(split(record.description, ' ', limit=2))

"""
    sequence(record::AbstractRecord{T})::T

Returns the sequence of `record`.
"""
@inline sequence(record::AbstractRecord{T}) where T= record.sequence


"""
    sequence(T, record::AbstractRecord)::T

Returns the sequence of `record`, converted to type T.
"""
@inline sequence(::Type{T}, record::AbstractRecord) where T = T(record.sequence)
# case when conversion isn't necessary
@inline sequence(::Type{T}, record::AbstractRecord{T}) where T = record.sequence

function Base.summary(R::AbstractRecord)
    string(typeof(R))
end


function Base.convert(::Type{FASTX.FASTA.Record}, record::AbstractRecord{T}) where T
    FASTX.FASTA.Record(
        description(record),
        sequence(String, record))
end