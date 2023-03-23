# rubocop:disable all

require 'rbnacl'

# ALICE SETUP
## Generate own keys
alice_private_key = RbNaCl::PrivateKey.generate
alice_public_key  = alice_private_key.public_key

# BOB SETUP
## Generate own keys
bob_private_key = RbNaCl::PrivateKey.generate
bob_public_key  = bob_private_key.public_key

# ALICE - ENCRYPT Message
message = 'secret'
alice_box = RbNaCl::Box.new(bob_public_key, alice_private_key)
nonce = RbNaCl::Random.random_bytes(alice_box.nonce_bytes)
ciphertext = alice_box.encrypt(nonce, message)
# send nonce and ciphertext to Bob

# BOB - DECRYPT Message
# receive nonce and ciphertext from Alice
bob_box = RbNaCl::Box.new(alice_public_key, bob_private_key)
plaintext = bob_box.decrypt(nonce, ciphertext)

# BOX:
alice_box
# => #<RbNaCl::Boxes::Curve25519XSalsa20Poly1305:0x007fa1af1aeac0
#  @_key=
#   "\x1A#\xF5\xC0\x05Q\xA6\xD6? \xC5P\x06\x1Ct\x80YO\xD3\x8B9&\xD0\xDE\xED\xE8\xBB|\xBC\xF0\xB0\x03",
#  @private_key=
#   #<RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PrivateKey:e3ee8d6b>,
#  @public_key=
#   #<RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PublicKey:3f2ca66e>>
