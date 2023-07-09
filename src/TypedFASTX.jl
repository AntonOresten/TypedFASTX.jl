module TypedFASTX

    export
        # probability.jl
        error_prob_generator,
        error_probs,
        error_rate,

        # quality.jl
        NoQuality,

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
    import Statistics: mean

    include("quality/quality.jl")
    include("record.jl")
    include("fastx-conversion.jl")

end
