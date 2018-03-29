require 'rbnacl/libsodium'

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

c1 = secret_box.encrypt(nonce, p1)
c2 = secret_box.encrypt(nonce, p2)

print c1.bytes.map.with_index { |b1, i| (b1 ^ c2.bytes[i]).chr }.map(&:ord)

print p1.bytes.map.with_index { |b1, i| (b1 ^ p2.bytes[i]).chr }.map(&:ord)


## Authenticated Encryption
require 'rbnacl/libsodium'

plaintext = 'This is my secret sauce'

key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
secret_box = RbNaCl::SecretBox.new(key)
nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
ciphertext = secret_box.encrypt(nonce, plaintext)

ciphertext.bytes.count - plaintext.bytes.length
