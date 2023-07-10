module TypedFASTX

    export
        # probability.jl
        error_prob_generator,
        error_probs,

        # quality.jl
        NoQuality,
        NO_QUALITY,

        # qualityscores.jl
        QualityScores,

        # typedrecord.jl
        TypedRecord,
        StringRecord,
        DNARecord,
        RNARecord,
        AARecord,

        identifier,
        sequence,
        quality,
        quality_values


    using FASTX
    using BioSequences

    include("quality/quality.jl")
    include("record.jl")
    include("fastx-conversion.jl")

end
