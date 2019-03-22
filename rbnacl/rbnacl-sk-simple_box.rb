require 'rbnacl'

## Encrypt with SimpleBox
key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
simple_box = RbNaCl::SimpleBox.from_secret_key(key)
message = 'This is my secret sauce'

simple_ciphertext = simple_box.encrypt(message)
simple_ciphertext.bytes
# => [98, 187, 180, 210, 126, 114, 215, 97, 126, 9, 110, 31, 123, 230, 95, 7,
#     99, 53, 69, 43, 48, 58, 51, 80, 176, 14, 183, 185, 104, 204, 48, 240, 45,
#     16, 109, 9, 239, 204, 55, 205, 239, 93, 127, 237, 116, 142, 221, 94, 151,
#     170, 219, 23, 101, 11, 51, 246, 49, 212, 7, 110, 7, 255, 223]

simple_ciphertext = simple_box.encrypt(message)
simple_ciphertext.bytes
# => [147, 104, 203, 98, 137, 42, 242, 215, 244, 249, 107, 235, 145, 22, 148,
#     144, 6, 161, 248, 212, 128, 20, 35, 203, 123, 230, 96, 252, 144, 41, 126,
#     199, 138, 61, 73, 176, 164, 74, 80, 184, 25, 102, 63, 117, 41, 186, 174,
#     217, 115, 191, 67, 11, 210, 250, 175, 132, 251, 115, 31, 217, 141, 30,
#     231]

## Decrypt with SimpleBox
simple_box = RbNaCl::SimpleBox.from_secret_key(key)
decrypted_text = simple_box.decrypt(simple_ciphertext)
# => "This is my secret sauce"

## Compare SimpleBox to SecretBox
secret_box = RbNaCl::SecretBox.new(key)
nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
secret_ciphertext = secret_box.encrypt(nonce, message)
secret_ciphertext.bytes
# => [63, 123, 249, 24, 2, 194, 14, 101, 151, 28, 251, 48, 115, 58, 34, 201,
#     216, 218, 223, 213, 92, 150, 50, 125, 98, 71, 54, 209, 23, 22, 98, 37,
#     156, 196, 100, 229, 132, 125, 31]

simple_ciphertext.length
# => 63
[RbNaCl::SecretBox.nonce_bytes, secret_ciphertext.length]
# => [24, 39]
