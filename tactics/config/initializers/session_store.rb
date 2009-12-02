# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tactics_session',
  :secret      => '51b3fa56506c639ce509d8b99ebb9bd14a94525cabf9939d7cb79bfdd89c5f1482db322e613b41a7b3bd231f53f3526ffd76470484f80436689551b0e17a43ca'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
