# rubocop:disable all

require 'rbnacl'

# PERSON A SETUP
## Generate own keys
A_private_key = RbNaCl::PrivateKey.generate
A_public_key  = A_private_key.public_key

# PERSON B SETUP
## Generate own keys
B_private_key = RbNaCl::PrivateKey.generate
B_public_key  = B_private_key.public_key

# PERSON A - ENCRYPT Message
message = "secret"
personA_box = RbNaCl::Box.new(B_public_key,
                              A_private_key)
nonce = RbNaCl::Random.random_bytes(personA_box.nonce_bytes)
ciphertext = personA_box.encrypt(nonce, message)
# send nonce and ciphertext to personB

# PERSONA A - DECRYPT Message
# receive nonce and ciphertext from personA
personB_box = RbNaCl::Box.new(A_public_key,
                              B_private_key)
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
