require 'rbnacl/libsodium'

# PERSON A SETUP
## Generate own keys
personA_private_key = RbNaCl::PrivateKey.generate
personA_public_key  = personA_private_key.public_key

# PERSON B SETUP
## Generate own keys
personB_private_key = RbNaCl::PrivateKey.generate
personB_public_key  = personB_private_key.public_key

# BOX SETUP
personA_box = RbNaCl::Box.new(personB_public_key,
                              personA_private_key)
personB_box = RbNaCl::Box.new(personA_public_key,
                              personB_private_key)

# ENCRYPT Message
message = "secret"
nonce = RbNaCl::Random.random_bytes(personA_box.nonce_bytes)
ciphertext = personA_box.encrypt(nonce, message)
# send nonce and ciphertext to personB

# DECRYPT Message
# receive nonce and ciphertext from personA
plaintext = personB_box.decrypt(nonce, ciphertext)

# BOX:
personA_box
# => #<RbNaCl::Boxes::Curve25519XSalsa20Poly1305:0x007fa1af1aeac0
#  @_key=
#   "\x1A#\xF5\xC0\x05Q\xA6\xD6? \xC5P\x06\x1Ct\x80YO\xD3\x8B9&\xD0\xDE\xED\xE8\xBB|\xBC\xF0\xB0\x03",
#  @private_key=
#   #<RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PrivateKey:e3ee8d6b>,
#  @public_key=
#   #<RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PublicKey:3f2ca66e>>
