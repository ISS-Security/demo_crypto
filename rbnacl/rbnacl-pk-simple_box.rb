# rubocop:disable all

require 'rbnacl'

# KEY CREATION
# personA creates keypair
personA_private_key = RbNaCl::PrivateKey.generate
personA_public_key  = personA_private_key.public_key

# personb creates keypair
personB_private_key = RbNaCl::PrivateKey.generate
personB_public_key  = personB_private_key.public_key

# KEY EXCHANGE
# personA creates SimpleBox
personA_box = RbNaCl::SimpleBox.from_keypair(
  personB_public_key,
  personA_private_key
)

# personB creates SimpleBox
personB_box = RbNaCl::SimpleBox.from_keypair(
  personA_public_key,
  personB_private_key
)

# personA SENDING
message = "secret"
ciphertext = personA_box.encrypt(message)

# personB RECEIVING
plaintext = personB_box.decrypt(ciphertext)
