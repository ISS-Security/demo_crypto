require 'base64'
def puts_bytes(description, str_utf8)
  puts "#{description} (ascii): #{str_utf8.inspect}"
  padding = ' ' * (description.length + 3)
  puts padding + "(dec): #{str_utf8.bytes.join(' ')}"
  puts padding + "(hex): #{str_utf8.unpack('H*').first}"
  puts padding + "(b64): #{Base64.strict_encode64(str_utf8)}"
  puts
end

data = (0..10).map { rand(0..2222).chr(Encoding::UTF_8) }.join
Base64.strict_encode64(data)

require 'openssl'
def aes_demo(plaintext)
  puts "PLAINTEXT: \"#{plaintext}\""

  cipher = OpenSSL::Cipher::AES.new(128, :CBC).encrypt
  key = cipher.random_key
  iv = cipher.random_iv
  puts_bytes('key', key)
  puts_bytes('IV', iv)

  ciphertext = cipher.update(plaintext) + cipher.final
  puts_bytes('ENCRYPTED', ciphertext)

  decipher = OpenSSL::Cipher::AES.new(128, :CBC).decrypt
  decipher.key = key
  decipher.iv = iv

  original = decipher.update(ciphertext) + decipher.final
  puts "DECRYPTED: \"#{original}\""
end

aes_demo('electric sheep')

# Examining the elements of OpenSSL's AES cipher
plaintext = ['Do ', 'androids ', 'dream ', 'of ', 'electric ', 'sheep?']
cipher = OpenSSL::Cipher::AES.new(128, :CBC).encrypt
key = cipher.random_key
iv = cipher.random_iv

crypt_blocks = plaintext.map do |plain|
  cipher.update(plain)
end
encrypted = crypt_blocks << cipher.final
ciphertext = encrypted.join

decipher = OpenSSL::Cipher::AES.new(128, :CBC).decrypt
decipher.key = key
decipher.iv = iv

# Decrypt the whole thing:
decrypted = decipher.update(ciphertext) + decipher.final

# Decrypt array piecewise:
decrypted = encrypted.map do |secret|
  secret.empty? ? '' : decipher.update(secret)
end << decipher.final

puts decrypted

## NOTES: making a base64 string with non-alphanumeric characters
loop do
  data = (1..5).map { rand(0..2222).chr(Encoding::UTF_8) }.join
  str = Base64.strict_encode64(data)
  break if %w(+ / =).all? { |c| str.include? c }
end
