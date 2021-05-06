# Password security
require 'rbnacl'
require 'base64'

password1 = 'cantguessthis'
password2 = 'cantguessthis'

# Hash Only
def only_hash(password)
  Base64.strict_encode64 RbNaCl::Hash.sha256(password)
end

only_hash(password1)
only_hash(password2)

# Salt + Hash
def salted_hash(password)
  salt = RbNaCl::Random.random_bytes
  hashed = RbNaCl::Hash.sha256(password + salt)
  { salt:   Base64.strict_encode64(salt),
    digest: Base64.strict_encode64(hashed) }
end

salted_hash(password1)
salted_hash(password2)

# Salt + Hash + Keystretching
def hard_hash(password)
  opslimit = 2**20
  memlimit = 2**24
  digest_size = 64

  salt = RbNaCl::Random.random_bytes(RbNaCl::PasswordHash::SCrypt::SALTBYTES)
  digest = RbNaCl::PasswordHash.scrypt(password, salt,
                                       opslimit, memlimit, digest_size)
  [Base64.strict_encode64(digest), Base64.strict_encode64(salt)].join("\n")
end

hard_hash(password1)

require 'benchmark'

Benchmark.bm do |bench|
  n = 1000
  bench.report('sha256') do
    n.times { salted_hash(password1) }
  end

  bench.report('scrypt') do
    n.times { hard_hash(password1) }
  end
end;
