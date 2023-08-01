"""
    error_prob_generator(record::Record)

Creates a generator of error probabilities for each character in the sequence.
"""
error_prob_generator(record::Record) = error_prob_generator(record.quality)

"""
    error_probs(record::Record)

Creates a vector of error probabilities for each character in the sequence.
"""
error_probs(record::Record) = error_probs(record.quality)

import ..TypedFASTX: error_rate

"""
    error_rate(record::Record)

Calculates the error rate of the record.
"""
error_rate(record::Record) = error_rate(record.quality)
