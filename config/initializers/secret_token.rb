# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
TaskManager::Application.config.secret_key_base = '43b3ae241c92ee2752524424decf2170e53bf85b2e8808ced4323ba5285de1082d2551a83cae9a075776b505c3ef81a3aaf87c91730107ab3a6ea2284bfeccc7'
