abstract type AbstractRecord{T} end

const StringRecord = AbstractRecord{String}
const DNARecord = AbstractRecord{LongDNA{4}}
const RNARecord = AbstractRecord{LongRNA{4}}
const AARecord = AbstractRecord{LongAA}

@inline Base.isless(r1::AbstractRecord, r2::AbstractRecord) = isless(r1.sequence, r2.sequence)

@inline Base.length(record::AbstractRecord) = length(record.sequence)

import FASTX: description, identifier, sequence

@inline description(record::AbstractRecord) = record.description
@inline identifier(record::AbstractRecord) = first(split(record.description, ' ', limit=2))

@inline sequence(record::AbstractRecord) = record.sequence
@inline sequence(::Type{T}, record::AbstractRecord{T}) where T = record.sequence
@inline sequence(::Type{T}, record::AbstractRecord) where T = T(record.sequence)

function Base.summary(R::AbstractRecord)
    string(typeof(R))
end