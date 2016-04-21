require 'rbnacl/libsodium'

## SecretBox Encryption
message = 'This is my secret sauce'
# => "This is my secret sauce"

key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
key.bytes
# => [2, 160, 76, 186, 1, 16, 157, 214, 114, 167, 214, 105, 189, 77, 218, 222,
#     198, 23, 143, 129, 214, 146, 79, 13, 181, 91, 0, 45, 45, 106, 47, 198]

secret_box = RbNaCl::SecretBox.new(key)
nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
nonce.bytes
# => [111, 109, 99, 174, 177, 86, 173, 71, 166, 199, 100, 19, 12, 218, 111, 173,
#     39, 44, 138, 205, 3, 180, 56, 90]

ciphertext = secret_box.encrypt(nonce, message)
ciphertext.bytes
# => [90, 231, 138, 178, 38, 60, 103, 91, 99, 91, 214, 30, 90, 235, 183, 161,
#     38, 1, 2, 234, 117, 106, 119, 215, 136, 117, 177, 141, 48, 93, 175, 147,
#     19, 128, 51, 56, 118, 67, 188]


## Decryption with SecretBox
# retrieve earlier key and nonce
# key = ...
# nonce = ...

secret_box = RbNaCl::SecretBox.new(key)
decrypted_message = secret_box.decrypt(nonce, ciphertext)
# => "This is my secret sauce"


## Tampering with the ciphertext raises an exception
ciphertext[5] = '?'

decrypted_message = desecret_box.decrypt(nonce, ciphertext)
# RbNaCl::CryptoError: Decryption failed. Ciphertext failed verification.
# from /Users/soumyaray/.rvm/gems/ruby-2.2.0/gems/rbnacl-3.1.2/lib/rbnacl/secret_boxes/xsalsa20poly1305.rb:94:in `open'


# Depth
key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
secret_box = RbNaCl::SecretBox.new(key)
nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)

m1 = 'This is my secret sauce'
m2 = 'This is another message'

c1 = secret_box.encrypt(nonce, m1)
c2 = secret_box.encrypt(nonce, m2)

c1.bytes.map.with_index { |b1, i| (b1 ^ c2.bytes[i]).chr }.join
