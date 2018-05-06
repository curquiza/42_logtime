require_relative 'oauth2_caller'

class API42Caller < OAuth2Caller

  UID      = ENV['UID_42']
  SECRET   = ENV['SECRET_42']
  ENDPOINT = 'https://api.intra.42.fr'

  def request_locations_for user, range
    get_request locations_url_for(user), range_param(range)
  end

  private

  def locations_url_for user
    "/v2/users/#{ user }/locations"
  end

  def range_param range
    { range: { begin_at: range } }
  end

end
