"""
    TypedRecord{T}

Abstract type for typed FASTX records.
"""
abstract type TypedRecord{T} end

"""
    StringRecord

Alias for `TypedRecord{String}`. Can be used for constructing TypedFASTA.Record{String} and TypedFASTQ.Record{String} instances. 
"""
const StringRecord = TypedRecord{String}

"""
    DNARecord

Alias for `TypedRecord{LongDNA{4}}`. Can be used for constructing TypedFASTA.Record{LongDNA{4}} and TypedFASTQ.Record{LongDNA{4}} instances. 
"""
const DNARecord = TypedRecord{LongDNA{4}}

"""
    RNARecord

Alias for `TypedRecord{LongRNA{4}}`. Can be used for constructing TypedFASTA.Record{LongRNA{4}} and TypedFASTQ.Record{LongRNA{4}} instances. 
"""
const RNARecord = TypedRecord{LongRNA{4}}

"""
    AARecord

Alias for `TypedRecord{LongAA}`. Can be used for constructing TypedFASTA.Record{LongAA} and TypedFASTQ.Record{LongAA} instances. 
"""
const AARecord = TypedRecord{LongAA}

@inline Base.length(record::TypedRecord) = length(record.sequence)
@inline Base.isless(r1::TypedRecord, r2::TypedRecord) = isless(r1.sequence, r2.sequence)

import FASTX: description, identifier, sequence

"""
    description(record::TypedRecord)::String

Get the entire description of `record`. Returns a String.
"""
@inline description(record::TypedRecord) = record.description

"""
    identifier(record::TypedRecord)::SubString{String}

Get the identifier of `record`. The identifier is the first "word" of the description. Returns a SubString{String}.
"""
@inline identifier(record::TypedRecord) = first(split(record.description, ' ', limit=2))

"""
    sequence(record::TypedRecord{T})::T

Returns the sequence of `record`.
"""
@inline sequence(record::TypedRecord{T}) where T= record.sequence


"""
    sequence(T, record::TypedRecord)::T

Returns the sequence of `record`, converted to type T.
"""
@inline sequence(::Type{T}, record::TypedRecord) where T = T(record.sequence)
# case when conversion isn't necessary
@inline sequence(::Type{T}, record::TypedRecord{T}) where T = record.sequence

function Base.summary(R::TypedRecord)
    string(typeof(R))
end


function Base.convert(::Type{FASTX.FASTA.Record}, record::TypedRecord{T}) where T
    FASTX.FASTA.Record(
        description(record),
        sequence(String, record))
end