require 'rbnacl'

## SecretBox Encryption
plaintext = 'This is my secret sauce'

key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
key.bytes

secret_box = RbNaCl::SecretBox.new(key)

nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
nonce.bytes

ciphertext = secret_box.encrypt(nonce, plaintext)
ciphertext.bytes

## Decryption with SecretBox
# retrieve earlier key and nonce
# key = ...
# nonce = ...

secret_box = RbNaCl::SecretBox.new(key)
decrypted_message = secret_box.decrypt(nonce, ciphertext)
decrypted_message.bytes

## Tampering with the ciphertext raises an exception
ciphertext[5] = '?'

decrypted_message = secret_box.decrypt(nonce, ciphertext)

# Depth
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
def xor(str1, str2)
  str1.bytes.zip(str2.bytes).map { |b1, b2| b1 ^ b2 }
end

# Lambda to xor bytes of two strings together
xor = ->(str1, str2) { str1.bytes.zip(str2.bytes).map { |b1, b2| b1 ^ b2 } }

xor.call(c1, c2)
xor.call(p1, p2)

## Authenticated Encryption
require 'rbnacl'

plaintext = 'This is my secret sauce'

key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
secret_box = RbNaCl::SecretBox.new(key)
nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
ciphertext = secret_box.encrypt(nonce, plaintext)

ciphertext.bytes.count - plaintext.bytes.length
