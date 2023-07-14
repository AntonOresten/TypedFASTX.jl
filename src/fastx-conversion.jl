# Methods for converting between TypedRecord and FASTX records

# FASTA

function TypedRecord{T}(fasta_record::FASTARecord) where T
    id = identifier(fasta_record)
    seq = sequence(T, fasta_record)
    TypedRecord{T}(id, seq)
end

function TypedRecord{T, NoQuality}(fasta_record::FASTARecord) where T
    TypedRecord{T}(fasta_record)
end

function FASTA.Record(record::TypedRecord)
    # Ignore the "Possible method call error." -- everything is fine.
    FASTA.Record(identifier(record), sequence(record))
end

# FASTQ

function TypedRecord{T, NoQuality}(fastq_record::FASTQRecord) where T
    id = identifier(fastq_record)
    seq = sequence(T, fastq_record)
    TypedRecord{T}(id, seq)
end

function TypedRecord{T, QualityScores}(fastq_record::FASTQRecord, encoding_name::Symbol = :sanger) where T
    encoding = encoding_name_to_quality_encoding(encoding_name)
    id = identifier(fastq_record)
    seq = sequence(T, fastq_record)
    qual = collect(quality_scores(fastq_record, encoding))
    TypedRecord{T}(id, seq, qual)
end

function TypedRecord{T}(fastq_record::FASTQRecord) where T
    TypedRecord{T, QualityScores}(fastq_record)
end

function FASTQ.Record(::TypedRecord{T, NoQuality}) where T
    error("Can't convert a `TypedRecord` with no quality to a `FASTX.FASTQ.Record`.")
end

function FASTQ.Record(record::TypedRecord{T, QualityScores}) where T
    FASTQ.Record(identifier(record), sequence(record), quality_values(record), offset=record.quality.encoding.offset)
end

