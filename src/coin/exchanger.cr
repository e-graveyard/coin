require "json"
require "http/client"
require "./currency"

module Exchanger
  class Fixer
    @endpoint = "http://data.fixer.io/api/latest"

    def initialize(amount : Int32, origin : String, targets : Array(String))
      @amount = amount
      @origin = origin
      @targets = targets
    end

    def set_token(token : String)
      @token = token
    end

    def convert
      begin
        response = request
      rescue Socket::Addrinfo::Error
        raise Exchanger::Exception.new "cannot connect to the API endpoint"
      end

      unless response["success"].as_bool
        code = response["error"]["code"]

        if code == 101
          raise Exchanger::Exception.new "missing or invalid key"
        end
      end

      rates = response["rates"]
      base = to_large_int(rates[@origin])

      results = Array(Float64).new
      @targets.each do |symbol|
        target = to_large_int(rates[symbol])
        results << compute(base, target)
      end

      results
    end

    private def request
      params = HTTP::Params.encode({"access_key" => (@token || "")})
      body = (HTTP::Client.get "#{@endpoint}?#{params}").body
      return JSON.parse(body)
    end

    private def to_large_int(value)
      begin
        return value.as_f * 1000000.0
      rescue TypeCastError
        return (value.as_i * 1000000).to_f
      end
    end

    private def compute(base, target)
      multiplier = 100.0
      rate = target / base
      value = (@amount * rate) / multiplier

      (value * multiplier) / multiplier
    end
  end

  class Exception < Exception
  end
end
