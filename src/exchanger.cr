require "json"
require "http/client"
require "./currency"
require "./dialog"


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

        def to_large_int(value)
            begin
                return value.as_f * 1000000.0

            rescue TypeCastError
                return (value.as_i * 1000000).to_f
            end
        end

        def to_money(base, target)
            rate = target / base
            value = (@amount * rate) / 100

            (value * 100).round / 100.0
        end

        def convert
            params = HTTP::Params.encode({
                "access_key" => (@token || "")
            })

            body = ""
            begin
                body = ( HTTP::Client.get "#{@endpoint}?#{params}" ).body

            rescue Socket::Addrinfo::Error
                Dialog::Error.cant_connect
            end

            response = JSON.parse(body)
            if response["success"] == false
                code = response["error"]["code"]

                if code == 101
                    Dialog::Error.invalid_key
                end
            end

            rates = response["rates"]
            base = to_large_int(rates[@origin])

            puts "$#{@amount / 100} #{@origin}\n\n"
            @targets.each do |symbol|
                target = to_large_int(rates[symbol])
                puts " -> $%.2f #{symbol}" % to_money(base, target)
            end
        end
    end
end
