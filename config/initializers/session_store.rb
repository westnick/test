# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test_session',
  :secret      => 'b677c359dcf30aaacb78d73ce0ff8669638e788f4ea62df5e6866f3a042212e10a42ee9ad53ed5164a7bea5f5536b9dd2bfad796582fa3031aa9517df4dcd389'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
