# Methods for converting between TypedRecord and FASTX records

function TypedRecord{T, NoQuality}(fasta_record::FASTARecord) where T
    id = identifier(fasta_record)
    seq = sequence(T, fasta_record)
    TypedRecord{T}(id, seq)
end

function TypedRecord{T, QualityScores}(::FASTARecord) where T
    error("Can't convert a `FASTX.FASTA.Record` to a `$(TypedRecord{T})` with quality.")
end

function TypedRecord{T}(fasta_record::FASTARecord) where T
    TypedRecord{T, NoQuality}(fasta_record)
end


function TypedRecord{T, NoQuality}(fastq_record::FASTQRecord) where T
    id = identifier(fastq_record)
    seq = sequence(T, fastq_record)
    TypedRecord{T}(id, seq)
end

function TypedRecord{T, QualityScores}(fastq_record::FASTQRecord, encoding::QualityEncoding = FASTQ.SANGER_QUAL_ENCODING) where T
    id = identifier(fastq_record)
    seq = sequence(T, fastq_record)
    qual = collect(quality_scores(fastq_record, encoding))
    TypedRecord{T}(id, seq, qual)
end

function TypedRecord{T, QualityScores}(fastq_record::FASTQRecord, encoding_name::Symbol) where T
    encoding = encoding_name_to_quality_encoding(encoding_name)
    id = identifier(fastq_record)
    seq = sequence(T, fastq_record)
    qual = collect(quality_scores(fastq_record, encoding))
    TypedRecord{T}(id, seq, qual)
end

function TypedRecord{T}(fastq_record::FASTQRecord) where T
    TypedRecord{T, QualityScores}(fastq_record)
end


function Base.convert(T::Type{<:TypedRecord}, record::FASTARecord)
    T(record)
end

function Base.convert(T::Type{<:TypedRecord}, record::FASTQRecord)
    T(record)
end


function FASTX.FASTA.Record(record::TypedRecord{T}) where T
    FASTX.FASTA.Record(identifier(record), sequence(record))
end


function FASTX.FASTX.FASTQ.Record(::TypedRecord{T, NoQuality}) where T
    error("Can't convert a `$(TypedRecord{T})` with no quality to a `FASTX.FASTQ.Record`.")
end

function FASTX.FASTQ.Record(record::TypedRecord{T, QualityScores}) where T
    FASTX.FASTQ.Record(identifier(record), sequence(record), quality_values(record), offset=record.quality.encoding.offset)
end

function Base.convert(::Type{FASTARecord}, record::TypedRecord)
    FASTARecord(record)
end

function Base.convert(::Type{FASTQRecord}, record::TypedRecord)
    FASTQRecord(record)
end