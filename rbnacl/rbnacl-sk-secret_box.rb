# frozen_string_literal: true

require 'rbnacl'

## SecretBox Encryption
plaintext = 'This is my secret sauce'

key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
RbNaCl::SecretBox.key_bytes
key.bytes

secret_box = RbNaCl::SecretBox.new(key)

nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
secret_box.nonce_bytes
nonce.bytes

ciphertext = secret_box.encrypt(nonce, plaintext)
ciphertext.bytes

## Decryption with SecretBox
# retrieve earlier key and nonce
# key = ...
# nonce = ...

secret_box = RbNaCl::SecretBox.new(key)
decrypted_message = secret_box.decrypt(nonce, ciphertext)

## Tampering with the ciphertext raises an exception
ciphertext[5] = '?'

decrypted_tampered = secret_box.decrypt(nonce, ciphertext)
decrypted_tampered

# Depth demonstration
key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
secret_box = RbNaCl::SecretBox.new(key)
nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)

p1 = 'This is my secret sauce'
p2 = 'This is another message'

# p1 = '123345567890'
# p2 = 'abcdefghijkl'

c1 = secret_box.encrypt(nonce, p1)
c2 = secret_box.encrypt(nonce, p2)

# XOR bytes of two strings together
def xor(bytes1, bytes2)
  bytes1.zip(bytes2).map { |b1, b2| b1 ^ b2 }
end

depth = xor(c1.bytes, c2.bytes)
p2_guess = "This is another message"
p1_crack = xor(p2_guess.bytes, depth[-23..-1]).map(&:chr).join

## Authenticated Encryption
require 'rbnacl'

plaintext = 'This is my secret sauce'

key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
secret_box = RbNaCl::SecretBox.new(key)
nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
ciphertext = secret_box.encrypt(nonce, plaintext)

ciphertext.bytes.count - plaintext.bytes.length
