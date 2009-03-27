# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_boomhammer_session',
  :secret      => 'f74b75439d33464b961a9871714e3dd3d38067219200753a3c9e017f7c810980fdbef36023c4b4c7b419e1fcd8ed3148f2f984c6ab4ed93a5b75007102b57eda'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
