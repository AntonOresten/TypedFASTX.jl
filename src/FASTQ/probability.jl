"""
    error_prob_generator(record::TypedFASTQ.Record)

Creates a generator of error probabilities for each character in the sequence.
"""
error_prob_generator(record::Record) = error_prob_generator(record.quality)

"""
    error_probs(record::TypedFASTQ.Record)

Creates a vector of error probabilities for each character in the sequence.
"""
error_probs(record::Record) = error_probs(record.quality)

"""
    error_rate(record::TypedFASTQ.Record)

Calculates the error rate of the record.
"""
error_rate(record::Record) = error_rate(record.quality)

"""
    error_count(record::TypedFASTQ.Record)

Returns the expected amount of errors in the sequence of a FASTQ record.
"""
error_count(record::TypedFASTQ.Record{T}) where T = sum(error_prob_generator(record.quality))