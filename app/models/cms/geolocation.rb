module Cms
  class Geolocation
    @@format = 'json'

    def self.data(ip,type)
      totalUrl = "http://freegeoip.net/#{@@format}/#{ip}"
      response = Net::HTTP.get_response(URI.parse(totalUrl)).body
      info = response = JSON.parse(response)
      return info[:country_code]
    end

    def self.countryWarningList(ip)
      show = []
      show = %w[ GB ]
      return show
    end
  end
end
