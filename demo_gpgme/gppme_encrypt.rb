require 'gpgme'

key = File.read('CE510594.asc')
GPGME::Key.import key

crypto = GPGME::Crypto.new always_trust: true, armor: true
result = crypto.encrypt 'testing testing', recipients: 'soumya.ray@gmail.com'
puts result.to_s
