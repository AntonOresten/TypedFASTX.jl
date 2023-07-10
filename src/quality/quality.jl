abstract type AbstractQuality end

struct NoQuality <: AbstractQuality end

const NO_QUALITY = NoQuality()

include("encodings.jl")
include("qualityscores.jl")
include("probability.jl")