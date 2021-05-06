# rubocop:disable all

require 'rbnacl'

# KEY CREATION
# Alice creates keypair
A_private_key = RbNaCl::PrivateKey.generate
A_public_key  = A_private_key.public_key

# Bob creates keypair
B_private_key = RbNaCl::PrivateKey.generate
B_public_key  = B_private_key.public_key

# KEY EXCHANGE
# Alice creates SimpleBox
A_box = RbNaCl::SimpleBox.from_keypair(
  B_public_key,
  A_private_key
)

# Bob creates SimpleBox
B_box = RbNaCl::SimpleBox.from_keypair(
  A_public_key,
  B_private_key
)

# Alice SENDING
message = "secret"
ciphertext = A_box.encrypt(message)

# Bob RECEIVING
plaintext = B_box.decrypt(ciphertext)
