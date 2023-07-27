module TypedFASTX

    export
        # probability.jl
        error_prob_generator,
        error_probs,

        # quality.jl
        AbstractQuality,
        NoQuality,
        NO_QUALITY,

        # qualityscores.jl
        QualityScores,

        # record.jl
        TypedRecord,
        StringRecord,
        DNARecord,
        RNARecord,
        AARecord,

        description,
        identifier,
        sequence,
        quality,
        has_quality,
        quality_values,

        # reader.jl
        TypedReader,
        has_index,
        seekrecord,
        index!,
        StringReader,
        DNAReader,
        RNAReader,
        AAReader,

        # writer.jl
        TypedWriter

    using FASTX
    using BioSequences

    include("quality/quality.jl")
    include("record.jl")
    include("conversion.jl")
    include("reader.jl")
    include("writer.jl")

end
