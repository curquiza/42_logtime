require 'oauth2'

class API42Caller

  UID      = ENV['UID_42']
  SECRET   = ENV['SECRET_42']
  ENDPOINT = 'https://api.intra.42.fr'

  class << self

    def request_locations_for user, range
      get_request locations_url_for(user), range_param(range)
    end

    def get_request url, params = {}
      token = get_access_token
      response = token.get url, params: params
      response.parsed
    end

    private

    def get_access_token
      client = oauth2_connection
      client.client_credentials.get_token
    end

    def oauth2_connection
      OAuth2::Client.new(UID, SECRET, site: ENDPOINT)
    end

    def locations_url_for user
      "/v2/users/#{ user }/locations"
    end

    def range_param range
      { range: { begin_at: range } }
    end

  end
end
