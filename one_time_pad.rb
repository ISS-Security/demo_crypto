# Demonstrating the One-Time Pad
def one_time_pad(plain_ints, key_ints)
  xor_pairs = plain_ints.zip key_ints
  xor_pairs.map { |p, k| p ^ k }
end

plain = 'bad'.bytes
key   = 'hog'.bytes
cipher_b = one_time_pad(plain, key)

one_time_pad(cipher_b, key)

## DANGER IN REUSING KEYS
p1 = 'tin'.bytes
p2 = 'pot'.bytes
p3 = 'eye'.bytes

# Alice reuses keys!
c1 = one_time_pad(p1, key)
c2 = one_time_pad(p2, key)
c3 = one_time_pad(p3, key)

# Eve sees c1, c2, c3
p1_guess = 'tin'.bytes

# Can we extract plaintext _without_ the key?
one_time_pad(one_time_pad(c1, c2), p1_guess)
one_time_pad(one_time_pad(c1, c3), p1_guess)
