require 'rbnacl/libsodium'

# KEY CREATION
personA_private_key = RbNaCl::PrivateKey.generate
personA_public_key  = personA_private_key.public_key

personB_private_key = RbNaCl::PrivateKey.generate
personB_public_key  = personB_private_key.public_key

# KEY EXCHANGE
personA_box = RbNaCl::SimpleBox.from_keypair(
  personB_public_key,
  personA_private_key
)

personB_box = RbNaCl::SimpleBox.from_keypair(
  personA_public_key,
  personB_private_key
)

# SENDING
message = "secret"
ciphertext = personA_box.encrypt(message)

# RECEIVING
plaintext = personB_box.decrypt(ciphertext)
