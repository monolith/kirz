# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kirz_session',
  :secret      => '60ec4e277faf994ef279f01ece946d5642da9672e75289fad299bc6f98e1b19a139fdf85f59dca4244fa23a36d8531ef46f8eb91063284f51ffd3d2004813f6b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
