# Password security
require 'rbnacl/libsodium'
require 'base64'

password1 = 'cantguessthis'
password2 = 'cantguessthis'

def only_hash(password)
  Base64.strict_encode64 RbNaCl::Hash.sha256(password)
end

only_hash(password1)
# => "1h/i4qlz3vZmKdhdYgN0SEO1gRI7O7Jmo7CAMZG5TJU="
only_hash(password2)
# => "1h/i4qlz3vZmKdhdYgN0SEO1gRI7O7Jmo7CAMZG5TJU="

def salted_hash(password)
  salt = RbNaCl::Random.random_bytes
  Base64.strict_encode64 RbNaCl::Hash.sha256(password + salt)
end

salted_hash(password1)
# => "r4+1J4wJDDrb6FmvF6MqmUl3PX2ldJA5TwYD9g08agI="
salted_hash(password2)
# => "nY3ENXOjHJsP4+FwhaHEXWH73Me7iPnNodDkzUDwT38="

def hard_hash(password)
  opslimit = 2**20
  memlimit = 2**24
  digest_size = 64

  salt = Base64.strict_encode64(
    RbNaCl::Random.random_bytes(RbNaCl::PasswordHash::SCrypt::SALTBYTES)
  )
  digest = RbNaCl::PasswordHash.scrypt(password, Base64.strict_decode64(salt),
                                       opslimit, memlimit, digest_size)
  [Base64.strict_encode64(digest), Base64.strict_encode64(salt)].join("\n")
end

hard_hash(password1)
hard_hash(password2)

require 'benchmark'

Benchmark.bm do |bench|
  n = 100
  bench.report('sha256') do
    n.times { salted_hash(password1) }
  end

  bench.report('scrypt') do
    n.times { hard_hash(password1) }
  end
end;
