require 'openssl'

# RSA ciphers
rsa_private = OpenSSL::PKey::RSA.generate 2048
rsa_private.to_pem

rsa_public = rsa_private.public_key
rsa_public.to_pem

# RSA Encryption and decryption
plaintext = 'Hello darkness my old friend'

rsa_ciphertext = rsa_public.public_encrypt plaintext
puts Base64.strict_encode64(rsa_ciphertext)

puts rsa_private.private_decrypt(rsa_ciphertext)

# Limits of plaintext size
def random_str(n = 10)
  letters = ('a'..'z').to_a + ('A'..'Z').to_a
  (1..n).map { letters.sample }.join
end

rsa_public.public_encrypt random_str(500)
