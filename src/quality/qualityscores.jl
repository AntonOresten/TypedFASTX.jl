# may be good to check quality values, although they'll most likely go through a FASTQRecord first
struct QualityScores
    values::Vector{Int8}
    encoding::QualityEncoding

    function QualityScores(values::Vector{Int8}, encoding::QualityEncoding = FASTQ.SANGER_QUAL_ENCODING)
        new(values, encoding)
    end

    function QualityScores(str::String, qualformat::Symbol = :sanger)
        values = Vector{Int8}(undef, lastindex(str))
        encoding = qualformat_to_quality_encoding(qualformat)
        for (i, x) in enumerate(codeunits(str))
            values[i] = FASTQ.decode_quality(encoding, x)
        end
        new(values, encoding)
    end
end

Base.hash(qs::QualityScores, h::UInt) = hash(qs.values, hash(qs.encoding, h))
Base.:(==)(qs1::QualityScores, qs2::QualityScores) = hash(qs1) == hash(qs2)

QualityScores(::Nothing) = nothing
QualityScores(qs::QualityScores) = qs
Base.length(qs::QualityScores) = length(qs.values)

encode_quality(qs::QualityScores) = qs.values .+ qs.encoding.offset
Base.String(qs::QualityScores) = String(UInt8.(encode_quality(qs)))

function Base.show(io::IO, qs::QualityScores)
    print(io, String(qs))
end