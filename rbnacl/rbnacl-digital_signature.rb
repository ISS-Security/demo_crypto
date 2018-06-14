# frozen_string_literal: true

require 'rbnacl/libsodium'
require 'base64'
require 'json'

# 0. Create and store private/public keys for digital signing
signing_key = RbNaCl::SigningKey.generate
verify_key = signing_key.verify_key

SIGNING_KEY = Base64.strict_encode64(signing_key.to_s)
VERIFY_KEY = Base64.strict_encode64(verify_key.to_s)

# 1. Client app: signs messages being sent to API
#    requires: SIGNING_KEY
message = { auth_token: '9u02oiwf9u02' }.to_json
signer = RbNaCl::SigningKey.new(Base64.strict_decode64(SIGNING_KEY))
signature = Base64.strict_encode64( signer.sign(message) )
payload = { data: message, signature: signature }.to_json

# 2. API: verifies message signature before using message
#    requires: VERIFY_KEY, payload with (signature, message)
parsed = JSON.parse(payload)
signature_raw = Base64.strict_decode64(parsed['signature'])
message = parsed['data']

verifier = RbNaCl::VerifyKey.new(Base64.strict_decode64(VERIFY_KEY))
verifier.verify(signature_raw, message)


verifier.verify(signature_raw, message + 'x')

