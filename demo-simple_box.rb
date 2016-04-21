require 'rbnacl/libsodium'

key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
simple_box = RbNaCl::SimpleBox.from_secret_key(key)
message = 'This is my secret sauce'

simple_ciphertext = simple_box.encrypt(message)
simple_ciphertext.bytes


# Compare output of SimpleBox to SecretBox
secret_box = RbNaCl::SecretBox.new(key)
nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
secret_ciphertext = secret_box.encrypt(nonce, message)

simple_ciphertext.length
[RbNaCl::SecretBox.nonce_bytes, secret_ciphertext.length]
