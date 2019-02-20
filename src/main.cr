require "admiral"
require "colorize"

TERMINATION_ERROR   = 1
TERMINATION_SUCCESS = 0

class CLI < Admiral::Command
    define_argument amount : Float64, required: true
    define_argument origin : String, required: true
    define_argument target : String, required: true

    define_version "coin v0.1.0"
    define_help custom: <<-EOP
    #{bold("Usage: coin [--help] [--version] amount origin target")}

    Positional arguments:
        #{blue("amount")}      A
        #{blue("origin")}      A
        #{blue("target")}      A

    Optional arguments:
        #{blue("--help")}      A
        #{blue("--version")}   A

    Examples:
        $ coin 1 usd brl
        # => converts 1 us dollar to brazilian real

    This is free and open source software (FOSS).
    Licensed under the MIT license.

    Project page: <github.com/caian-org/coin>
    EOP

    def run
        begin
            arguments.amount
            arguments.origin
            arguments.target

        rescue NilAssertionError
            die("one or more arguments are missing.")

        rescue ArgumentError
            die("amount is not of type float.")
        end

        exit TERMINATION_SUCCESS
    end

    private def bold(txt)
        txt.colorize.mode(:bold)
    end

    private def blue(txt)
        txt.colorize(:light_blue)
    end

    private def die(txt)
        puts "#{"Error: ".colorize(:light_red)} #{txt}"
        exit TERMINATION_ERROR
    end
end

CLI.run
