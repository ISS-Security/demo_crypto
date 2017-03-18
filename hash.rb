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


## Hashing Git Commit Blobs
def git_blob(file)
  "blob #{file.size}\0#{file}"
end

msg = "Hello, World!\n"

git_blob(msg)
# => "blob 14\u0000Hello, World!\n"

print Digest::SHA1.digest(git_blob(msg)).bytes
# [138, 182, 134, 234, 254, 177, 244, 71, 2, 115, 140, 139, 15, 36, 242, 86,
#  124, 54, 218, 109]
