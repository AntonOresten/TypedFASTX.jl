"""
    QualityScores

A type for storing FASTQ quality with different encodings.
"""
struct QualityScores
    values::Vector{Int8}
    encoding::FASTX.FASTQ.QualityEncoding

    function QualityScores(values::Vector{Int8}, encoding::FASTX.FASTQ.QualityEncoding = FASTX.FASTQ.SANGER_QUAL_ENCODING)
        new(values, encoding)
    end

    function QualityScores(str::String, encoding::FASTX.FASTQ.QualityEncoding = FASTX.FASTQ.SANGER_QUAL_ENCODING)
        values = Vector{Int8}(undef, lastindex(str))
        for (i, x) in enumerate(codeunits(str))
            values[i] = FASTX.FASTQ.decode_quality(encoding, x)
        end
        QualityScores(values, encoding)
    end
end

QualityScores(qs::QualityScores) = qs

Base.hash(qs::QualityScores, h::UInt) = hash(qs.values, hash(qs.encoding, h))
Base.:(==)(qs1::QualityScores, qs2::QualityScores) = hash(qs1) == hash(qs2)

Base.length(qs::QualityScores) = length(qs.values)
Base.getindex(qs::QualityScores, i::Integer) = qs.values[i]

encode_quality(qs::QualityScores) = qs.values .+ qs.encoding.offset
Base.String(qs::QualityScores) = String(UInt8.(encode_quality(qs)))

Base.reverse(qs::QualityScores) = QualityScores(reverse(qs.values), qs.encoding)

function Base.reverse!(qs::QualityScores)
    reverse!(qs.values)
    qs
end

function Base.summary(io::IO, ::QualityScores)
    print(io, "QualityScores")
end

function Base.show(io::IO, qs::QualityScores)
    print(io, String(qs))
end

function Base.show(io::IO, ::MIME"text/plain", qs::QualityScores)
    print(io, "$(summary(qs)):")
    print(io, "\n  encoding: ", qs.encoding)
    print(io, "\n    values: ", FASTX.truncate(string(qs.values), 40))
end

include("probability.jl")