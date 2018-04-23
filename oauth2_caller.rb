require 'oauth2'

class OAuth2Caller

  attr_reader :token

  def initialize
    @token = get_access_token
  end

  def get_request url, params = {}
    response = token.get url, params: params
    response.parsed
  end

  private

  def get_access_token
    oauth2_connection.client_credentials.get_token
  end

  def oauth2_connection
    OAuth2::Client.new(self.class::UID, self.class::SECRET, site: self.class::ENDPOINT)
  end

end
