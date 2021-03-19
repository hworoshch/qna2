module OmniauthHelpers
  def mock_auth(provider, email = nil)
    hash = {
      'provider' => provider.to_s,
      'uid' => '123'
    }

    hash.merge!('info' => { 'email' => email }) if email
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(hash)
  end
end
