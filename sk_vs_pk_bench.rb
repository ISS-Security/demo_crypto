require 'openssl'
require 'benchmark'

# Setup basic parameters
plaintext = 'Hello darkness my old friend'
n = 100_000

# Setup AES ciphers
aes_cipher = OpenSSL::Cipher::AES.new(128, :CBC).encrypt
key = aes_cipher.random_key
iv = aes_cipher.random_iv
aes_ciphertext = aes_cipher.update(plaintext) + aes_cipher.final

aes_decipher = OpenSSL::Cipher::AES.new(128, :CBC).decrypt
aes_decipher.key = key
aes_decipher.iv = iv

# Setup RSA ciphers
rsa_private = OpenSSL::PKey::RSA.generate 2048
rsa_ciphertext = rsa_private.public_encrypt plaintext
rsa_public = rsa_private.public_key

# Benchmark AES vs. RSA, encrypt vs. decrypt
results = Benchmark.bm(15) do |bench|
  bench.report('AES encrypt') do
    n.times { aes_cipher.update(plaintext) + aes_cipher.final }
  end

  bench.report('AES decrypt') do
    n.times { aes_decipher.update(aes_ciphertext) + aes_decipher.final }
  end

  puts '-' * 61

  bench.report('RSA encrypt') do
    n.times { rsa_public.public_encrypt plaintext }
  end

  bench.report('RSA decrypt') do
    n.times { rsa_private.private_decrypt rsa_ciphertext }
  end
end

puts "SK encryption faster by: #{results[2].utime / results[0].utime}"
puts "SK encryption faster by: #{results[3].utime / results[1].utime}"
