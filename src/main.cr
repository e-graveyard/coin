require "optarg"
require "colorize"

TERMINATION_ERROR   = 1
TERMINATION_SUCCESS = 0

class OptionalArgumentsModel < Optarg::Model
    bool "-h"
    bool "--help"
    bool "-v"
    bool "--version"
end

class PositionalArgumentsModel < Optarg::Model
    arg "amount"
    arg "origin"
    arg_array "targets"
end

class Parser
    @argv = [] of String

    def initialize(argv)
        @argv = argv
    end

    def run
        die("missing operand.") if @argv.size == 0

        if @argv.size == 1
            parse_and_perform_optional_args
            exit TERMINATION_SUCCESS
        end

        parse_positional
        exit TERMINATION_SUCCESS
    end

    private def parse_and_perform_optional_args
        error = false

        begin
            opt = OptionalArgumentsModel.parse(@argv)
            if opt.h? || opt.help?
                show_help

            elsif opt.v? || opt.version?
                show_version

            else
                error = true
            end

        rescue Optarg::UnknownOption
            error = true
        end

        die("unknown option.") if error
    end

    private def parse_positional
    end

    private def show_usage
        "#{bold("usage: coin [-h] [-v] amount origin <target, ...>")}"
    end

    private def show_help
        usage = <<-EOP
        #{show_usage}

        Positional arguments:
            #{blue("amount")}             The amount of money to be converted
            #{blue("origin")}             The origin currency used as base for conversion
            #{blue("target")}             Each of the target currencies for conversion

        Optional arguments:
            #{blue("-h, --help")}         Show this help message and exit
            #{blue("-v, --version")}      Show the program version and exit

        Examples:
            $ #{green("coin 1 usd brl")}
            # => converts 1 us dollar to brazilian real

            $ #{green("coin 2.5 eur rub jpy")}
            # => converts 2.5 euro to russian rouble and japanese yen

        This is free and open source software (FOSS).
        Licensed under the MIT license.

        #{bold("Project page: <github.com/caian-org/coin>")}
        EOP

        puts usage
    end

    private def show_version
        puts "coin v0.1.0"
    end

    private def bold(txt)
        txt.colorize.mode(:bold)
    end

    private def blue(txt)
        txt.colorize(:light_blue)
    end

    private def green(txt)
        txt.colorize(:light_green)
    end

    private def die(txt)
        msg = <<-EOP
        #{"Error:".colorize(:light_red)} #{txt}

        #{show_usage}
        EOP

        puts msg
        exit TERMINATION_ERROR
    end
end

parser = Parser.new(ARGV)
parser.run
