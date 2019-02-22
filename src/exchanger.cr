require "./currency"

module Exchanger
    class Fixer
        def initialize(amount : Int32, origin : String, targets : Array(String))
            @amount = amount
            @origin = origin
            @targets = targets
        end
    end
end
