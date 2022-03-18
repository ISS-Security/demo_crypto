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

# symkey = aes_key
# c1 = aes_encrypt(symkey, 'electric sheep')
# c2 = aes_encrypt(symkey, 'nosferetu lie')

# def str_xor(str1, str2)
#   bytezip = str1.bytes.zip(str2.bytes)
#   xored = bytezip.map { |b1, b2| b1 ^ b2 }
#   xored.map(&:chr).join
# end

# c1_xor_c2 = str_xor(c1, c2)
# str_xor('nosferetu lie', c1_xor_c2)
