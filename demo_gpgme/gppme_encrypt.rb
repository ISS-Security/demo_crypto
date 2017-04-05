require 'gpgme'

message = 'testing testing'

key = File.read('CE510594.asc');
GPGME::Key.import key
crypto = GPGME::Crypto.new always_trust: true, armor: true
ciphertext = crypto.encrypt message, recipients: 'soumya.ray@gmail.com'
# => #<GPGME::Data:0x007fe753c27b48>
puts ciphertext

plaintext = crypto.decrypt ciphertext
plaintext
# => #<GPGME::Data:0x007fe755b69ba0>
puts plaintext
# testing testing
