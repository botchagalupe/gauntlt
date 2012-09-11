require 'httparty'

module Gauntlt
  module Support
    module CookieHelper
      def cookies_for(hostname)
        url = URI::Generic.build(
          :scheme => 'http',  # allow this to be set
          :host   => hostname
        ).to_s

        resp = HTTParty.get(url)

        resp.get_fields('Set-Cookie').map do |cookie_string|
          "#{$1}=#{$2}" if cookie_string =~ /^([^=]+)=([^;]+;)/
        end
      end

      def cookies
        raise "No cookies set" if @cookies.nil?

        @cookies
      end

      def set_cookies(a)
        @cookies = a
      end
    end
  end
end

World(Gauntlt::Support::CookieHelper)