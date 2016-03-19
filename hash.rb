require 'openssl'
def openssl_hash_sha256(plaintext)
  OpenSSL::Digest::SHA256.digest(plaintext).unpack('H*')
end

def openssl_hash_sha1(plaintext)
  OpenSSL::Digest::SHA1.digest(plaintext).unpack('H*')
end

def openssl_hash_md5(plaintext)
  OpenSSL::Digest::MD5.digest(plaintext).unpack('H*')
end

require 'digest'
def hash_sha256(plaintext)
  Digest::SHA256.digest(plaintext).unpack('H*')
end

def hash_sha1(plaintext)
  Digest::SHA1.digest(plaintext).unpack('H*')
end

def hash_md5(plaintext)
  Digest::MD5.digest(plaintext).unpack('H*')
end

def git_blob(file)
  "blob #{file.size}\0#{file}"
end

msg = "Hello, World!\n"

hash_sha1(git_blob(msg))
# => ["8ab686eafeb1f44702738c8b0f24f2567c36da6d"]
