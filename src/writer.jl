# typed writers have sequence types for type stability
abstract type AbstractWriter{T} end

Base.close(w::AbstractWriter) = close(w.io)