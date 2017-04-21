# Password security
require 'rbnacl/libsodium'
require 'base64'

password = 'cantguessthis'
sameword = 'cantguessthis'
def only_hash(password)
  Base64.strict_encode64 RbNaCl::Hash.sha256(password)
end

only_hash(password)
# => "1h/i4qlz3vZmKdhdYgN0SEO1gRI7O7Jmo7CAMZG5TJU="
only_hash(sameword)
# => "1h/i4qlz3vZmKdhdYgN0SEO1gRI7O7Jmo7CAMZG5TJU="

def salted_hash(password)
  salt = RbNaCl::Random.random_bytes
  Base64.strict_encode64 RbNaCl::Hash.sha256(password + salt)
end

salted_hash(password)
# => "Ja0leWiUk4piW43r5tqFkb25FU5cGxcuwnJhRjCgiSc="
salted_hash(sameword)
# => "fNzWxHtVohPfKF7+7AoRqkIaBp6xQ/bO2UVVJi3hn+Q="

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

hard_hash(password)
# => "dX7g2Qf+3cS8eXq7VCBPpvKr076IpFpOr+O6D5tdMMCdpuyHSBgds5JPbc2FbMLl7MFZ+b0WJU6tWWign4hJTw==\n" +
# "bXhGWTZMUWV2Qm8ra0wybmZBY0JvWGtLMzJzcDNsczhmVXpzdnZWbFBaVT0="
hard_hash(sameword)
# => "MnPItHLr+UMzDk5pTkS8GEacQZdWa0NoWFdeEimMSa22U7KqII/3noeZO0r3YqDkdDt+WGYXBUGL0efHD0qFuA==\n" +
# "OW9PdTRWc0Rxb3UzT3doU0hOZmFhUVRxTlVmZ1RhdVFXYld4aVUzL3lTWT0="

require 'benchmark'

Benchmark.bm do |bench|
  n = 1000
  bench.report('sha256') do
    n.times { salted_hash(password) }
  end

  bench.report('scrypt') do
    n.times { hard_hash(password) }
  end
end;

#            user     system      total        real
# sha256  0.010000   0.000000   0.010000 (  0.006641)
# scrypt 50.470000   5.620000  56.090000 ( 56.143286)
