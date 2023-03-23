# rubocop:disable all

require 'rbnacl'

# KEY CREATION
# Alice creates keypair
alice_private_key = RbNaCl::PrivateKey.generate
alice_public_key  = alice_private_key.public_key

# Bob creates keypair
bob_private_key = RbNaCl::PrivateKey.generate
bob_public_key  = bob_private_key.public_key

# KEY EXCHANGE
# Alice creates SimpleBox
alice_box = RbNaCl::SimpleBox.from_keypair(
  bob_public_key,
  alice_private_key
)

# Bob creates SimpleBox
bob_box = RbNaCl::SimpleBox.from_keypair(
  alice_public_key,
  bob_private_key
)

# Alice SENDING
message = 'secret'
ciphertext = alice_box.encrypt(message)

# Bob RECEIVING
plaintext = bob_box.decrypt(ciphertext)
