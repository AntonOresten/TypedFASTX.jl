@inline phred_to_p(q::Int8) = exp10(q / -10.0)
@inline solexa_to_p(q::Int8) = 1 / (1 + exp10(q / 10.0))

@inline error_prob_function(qe::FASTX.FASTQ.QualityEncoding) = qe.low < qe.offset ? solexa_to_p : phred_to_p

@inline error_prob_generator(qs::QualityScores) = let q_to_p = error_prob_function(qs.encoding)
    (q_to_p(q) for q in qs.values)
end

@inline error_probs(qs::QualityScores) = error_prob_function(qs.encoding).(qs.values)

@inline error_rate(qs::QualityScores) = mean(error_prob_generator(qs))