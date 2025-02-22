# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `scrypt` gem.
# Please instead update this file by running `bin/tapioca gem scrypt`.


# source://scrypt//lib/scrypt/errors.rb#3
module SCrypt; end

# source://scrypt//lib/scrypt/engine.rb#22
class SCrypt::Engine
  class << self
    # Autodetects the cost from the salt string.
    #
    # source://scrypt//lib/scrypt/engine.rb#139
    def autodetect_cost(salt); end

    # Returns the cost value which will result in computation limits less than the given options.
    #
    # Options:
    # <tt>:max_time</tt> specifies the maximum number of seconds the computation should take.
    # <tt>:max_mem</tt> specifies the maximum number of bytes the computation should take. A value of 0 specifies no upper limit. The minimum is always 1 MB.
    # <tt>:max_memfrac</tt> specifies the maximum memory in a fraction of available resources to use. Any value equal to 0 or greater than 0.5 will result in 0.5 being used.
    #
    # Example:
    #
    #   # should take less than 200ms
    #   SCrypt::Engine.calibrate(:max_time => 0.2)
    #
    # source://scrypt//lib/scrypt/engine.rb#121
    def calibrate(options = T.unsafe(nil)); end

    # Calls SCrypt::Engine.calibrate and saves the cost string for future calls to
    # SCrypt::Engine.generate_salt.
    #
    # source://scrypt//lib/scrypt/engine.rb#128
    def calibrate!(options = T.unsafe(nil)); end

    # Generates a random salt with a given computational cost.  Uses a saved
    # cost if SCrypt::Engine.calibrate! has been called.
    #
    # Options:
    # <tt>:cost</tt> is a cost string returned by SCrypt::Engine.calibrate
    #
    # source://scrypt//lib/scrypt/engine.rb#82
    def generate_salt(options = T.unsafe(nil)); end

    # Given a secret and a valid salt (see SCrypt::Engine.generate_salt) calculates an scrypt password hash.
    #
    # @raise [Errors::InvalidSecret]
    #
    # source://scrypt//lib/scrypt/engine.rb#60
    def hash_secret(secret, salt, key_len = T.unsafe(nil)); end

    # Computes the memory use of the given +cost+
    #
    # source://scrypt//lib/scrypt/engine.rb#133
    def memory_use(cost); end

    # source://scrypt//lib/scrypt/engine.rb#41
    def scrypt(secret, salt, *args); end

    # Returns true if +cost+ is a valid cost, false if not.
    #
    # @return [Boolean]
    #
    # source://scrypt//lib/scrypt/engine.rb#95
    def valid_cost?(cost); end

    # Returns true if +salt+ is a valid salt, false if not.
    #
    # @return [Boolean]
    #
    # source://scrypt//lib/scrypt/engine.rb#100
    def valid_salt?(salt); end

    # Returns true if +secret+ is a valid secret, false if not.
    #
    # @return [Boolean]
    #
    # source://scrypt//lib/scrypt/engine.rb#105
    def valid_secret?(secret); end

    private

    # source://scrypt//lib/scrypt/engine.rb#145
    def __sc_calibrate(max_mem, max_memfrac, max_time); end

    # source://scrypt//lib/scrypt/engine.rb#156
    def __sc_crypt(secret, salt, n, r, p, key_len); end
  end
end

# source://scrypt//lib/scrypt/engine.rb#34
class SCrypt::Engine::Calibration < ::FFI::Struct; end

# source://scrypt//lib/scrypt/engine.rb#24
SCrypt::Engine::DEFAULTS = T.let(T.unsafe(nil), Hash)

# source://scrypt//lib/scrypt/errors.rb#4
module SCrypt::Errors; end

# The hash parameter provided is invalid.
#
# source://scrypt//lib/scrypt/errors.rb#9
class SCrypt::Errors::InvalidHash < ::StandardError; end

# The salt parameter provided is invalid.
#
# source://scrypt//lib/scrypt/errors.rb#6
class SCrypt::Errors::InvalidSalt < ::StandardError; end

# The secret parameter provided is invalid.
#
# source://scrypt//lib/scrypt/errors.rb#12
class SCrypt::Errors::InvalidSecret < ::StandardError; end

# source://scrypt//lib/scrypt/scrypt_ext.rb#7
module SCrypt::Ext
  extend ::FFI::Library

  def crypto_scrypt(*_arg0); end
  def sc_calibrate(*_arg0); end

  class << self
    def crypto_scrypt(*_arg0); end
    def sc_calibrate(*_arg0); end
  end
end

# A password management class which allows you to safely store users' passwords and compare them.
#
# Example usage:
#
#   include "scrypt"
#
#   # hash a user's password
#   @password = Password.create("my grand secret")
#   @password #=> "2000$8$1$f5f2fa5fe5484a7091f1299768fbe92b5a7fbc77$6a385f22c54d92c314b71a4fd5ef33967c93d679"
#
#   # store it safely
#   @user.update_attribute(:password, @password)
#
#   # read it back
#   @user.reload!
#   @db_password = Password.new(@user.password)
#
#   # compare it after retrieval
#   @db_password == "my grand secret" #=> true
#   @db_password == "a paltry guess"  #=> false
#
# source://scrypt//lib/scrypt/password.rb#25
class SCrypt::Password < ::String
  # Initializes a SCrypt::Password instance with the data from a stored hash.
  #
  # @raise [Errors::InvalidHash]
  # @return [Password] a new instance of Password
  #
  # source://scrypt//lib/scrypt/password.rb#67
  def initialize(raw_hash); end

  # Compares a potential secret against the hash. Returns true if the secret is the original secret, false otherwise.
  #
  # source://scrypt//lib/scrypt/password.rb#76
  def ==(other); end

  # The cost factor used to create the hash.
  #
  # source://scrypt//lib/scrypt/password.rb#31
  def cost; end

  # The hash portion of the stored password hash.
  #
  # source://scrypt//lib/scrypt/password.rb#27
  def digest; end

  # Compares a potential secret against the hash. Returns true if the secret is the original secret, false otherwise.
  #
  # source://scrypt//lib/scrypt/password.rb#76
  def is_password?(other); end

  # The salt of the store password hash
  #
  # source://scrypt//lib/scrypt/password.rb#29
  def salt; end

  private

  # call-seq:
  #   split_hash(raw_hash) -> cost, salt, hash
  #
  # Splits +h+ into cost, salt, and hash and returns them in that order.
  #
  # source://scrypt//lib/scrypt/password.rb#92
  def split_hash(h); end

  # Returns true if +h+ is a valid hash.
  #
  # @return [Boolean]
  #
  # source://scrypt//lib/scrypt/password.rb#84
  def valid_hash?(h); end

  class << self
    # Hashes a secret, returning a SCrypt::Password instance.
    # Takes five options (optional), which will determine the salt/key's length and the cost limits of the computation.
    # <tt>:key_len</tt> specifies the length in bytes of the key you want to generate. The default is 32 bytes (256 bits). Minimum is 16 bytes (128 bits). Maximum is 512 bytes (4096 bits).
    # <tt>:salt_size</tt> specifies the size in bytes of the random salt you want to generate. The default and minimum is 8 bytes (64 bits). Maximum is 32 bytes (256 bits).
    # <tt>:max_time</tt> specifies the maximum number of seconds the computation should take.
    # <tt>:max_mem</tt> specifies the maximum number of bytes the computation should take. A value of 0 specifies no upper limit. The minimum is always 1 MB.
    # <tt>:max_memfrac</tt> specifies the maximum memory in a fraction of available resources to use. Any value equal to 0 or greater than 0.5 will result in 0.5 being used.
    # The scrypt key derivation function is designed to be far more secure against hardware brute-force attacks than alternative functions such as PBKDF2 or bcrypt.
    # The designers of scrypt estimate that on modern (2009) hardware, if 5 seconds are spent computing a derived key, the cost of a hardware brute-force attack against scrypt is roughly 4000 times greater than the cost of a similar attack against bcrypt (to find the same password), and 20000 times greater than a similar attack against PBKDF2.
    # Default options will result in calculation time of approx. 200 ms with 1 MB memory use.
    #
    # Example:
    #   @password = SCrypt::Password.create("my secret", :max_time => 0.25)
    #
    # source://scrypt//lib/scrypt/password.rb#48
    def create(secret, options = T.unsafe(nil)); end
  end
end

# source://scrypt//lib/scrypt/security_utils.rb#7
module SCrypt::SecurityUtils
  class << self
    # Constant time string comparison.
    #
    # The values compared should be of fixed length, such as strings
    # that have already been processed by HMAC. This should not be used
    # on variable length plaintext strings because it could leak length info
    # via timing attacks.
    #
    # source://scrypt//lib/scrypt/security_utils.rb#14
    def secure_compare(a, b); end
  end
end
