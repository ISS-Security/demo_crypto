require 'openssl'

def aes_key
  cipher = OpenSSL::Cipher::AES.new(128, :CBC).encrypt
  {
    key: cipher.random_key,
    iv:  cipher.random_iv
  }
end

def aes_encrypt(key, plaintext)
  cipher = OpenSSL::Cipher::AES.new(128, :CBC).encrypt
  cipher.key = key[:key]
  cipher.iv = key[:iv]
  cipher.update(plaintext) + cipher.final
end

def aes_decrypt(key, ciphertext)
  cipher = OpenSSL::Cipher::AES.new(128, :CBC).decrypt
  cipher.key = key[:key]
  cipher.iv = key[:iv]
  cipher.update(ciphertext) + cipher.final
end

symkey = aes_key
c1 = aes_encrypt(symkey, 'electric sheep')
aes_decrypt(symkey, c1) # => "electric sheep"
