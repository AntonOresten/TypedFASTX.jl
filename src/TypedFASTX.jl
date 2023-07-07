module TypedFASTX

    export
        # typedrecord.jl
        TypedRecord,
        StringRecord,
        DNARecord,
        RNARecord,
        AARecord,

        # qualityscores.jl
        QualityScores,

        # probability.jl
        error_prob_generator,
        error_probs,
        error_rate

    using FASTX
    using BioSequences
    import Statistics: mean

    include("quality/quality.jl")
    include("typedrecord.jl")
    include("fastx-conversion.jl")

end
