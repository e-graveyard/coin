require "colorize"
require "optarg"
require "./currency"


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


module CLI
    class Parser
        def initialize(argv : Array(String))
            @argv = argv
        end

        def version
            puts "coin v0.1.0"
        end

        def help
            msg = <<-EOP
            #{Style.bold "Usage: coin [-h] [-v] amount origin <target, ...>"}

            Positional arguments:
                #{Style.blue "amount"}             The amount of money to be converted
                #{Style.blue "origin"}             The origin currency used as base for conversion
                #{Style.blue "target"}             Each of the target currencies for conversion

            Optional arguments:
                #{Style.blue "-h, --help"}         Show this help message and exit
                #{Style.blue "-v, --version"}      Show the program version and exit

            Examples:
                $ #{Style.green "coin 1 usd brl"}
                # => converts 1 us dollar to brazilian real

                $ #{Style.green "coin 2.5 eur rub jpy"}
                # => converts 2.5 euro to russian rouble and japanese yen

            This project is dedicated to the Public Domain (CC0).

            #{Style.bold "Project page: <github.com/caian-org/coin>"}
            EOP

            puts msg
        end

        private def parse_and_perform_optional_args
            error = false

            begin
                opt = OptionalArgumentsModel.parse @argv
                if opt.h? || opt.help?
                    help

                elsif opt.v? || opt.version?
                    version

                else
                    error = true
                end

            rescue Optarg::UnknownOption
                error = true
            end

            if error
                raise CLI::Exception.new "unknown option"
            end
        end

        private def parse_positional
            # expected positional arguments
            amount = Int32
            origin = String
            targets = Array(String).new

            # ensures that no flag will be passed as an argument
            begin
                pos = PositionalArgumentsModel.parse @argv

            rescue Optarg::UnknownOption
                raise CLI::Exception.new "unknown option"
            end

            # upcase all symbols
            origin = pos.origin.upcase

            pos.targets.each do |value|
                targets << value.upcase
            end

            # ensures that the first argument is a decimal greater then zero
            begin
                amountf = pos.amount.to_f
                amountf = amountf * 100

            rescue ArgumentError
                raise CLI::Exception.new "value \"#{pos.amount}\" is not a decimal number"
            end

            amount = amountf.to_i
            if amountf == 0
                raise CLI::Exception.new "cannot convert zero"
            end

            # ensures that at least one target currency is defined
            if pos.targets.size == 0
                raise CLI::Exception.new "at least one target currency is required for convertion"
            end

            # ensures that the origin and target currency symbols are valid
            symbols = Array(String)
                .new
                .concat([origin])
                .concat(targets)

            symbols.each do |value|
                if ! Currency::SYMBOLS.has_key? value
                    raise CLI::Exception.new "\"#{value}\" is not a valid currency symbol"
                end
            end

            # ensures that the origin currency symbol is not amongst the targets
            if targets.includes? origin
                raise CLI::Exception.new "cannot convert \"#{origin}\" to itself"
            end

            return amount, origin, targets
        end

        def act
            if @argv.size == 0
                raise CLI::Exception.new "missing operand"
            end

            if @argv.size == 1
                parse_and_perform_optional_args
                exit 0
            end

            return parse_positional
        end
    end

    class Exception < Exception
    end

    class Dialog
        def self.die(txt)
            puts "#{Style.red "Error:"} #{txt}."
            exit 1
        end

        def self.present(amount : Int32, origin : String, targets : Array(String), results : Array(Float))
            puts "#{Style.blue "\nConversion of #{origin} #{amount / 100}.\n"}"

            max_padding = 0
            results.each do |r|
                len = "#{r}".size
                max_padding = len if len > max_padding
            end

            targets.zip(results).each do |target, result|
                padding = max_padding - "#{result}".size
                puts " - #{Style.green result} #{" " * padding} #{Style.dim "(#{target})"} #{Currency::SYMBOLS[target]}."
            end

            print "\n"
        end
    end

    class Style
        def self.bold(txt)
            txt.colorize.mode(:bold)
        end

        def self.dim(txt)
            txt.colorize.mode(:dim)
        end

        def self.blue(txt)
            txt.colorize(:light_blue)
        end

        def self.green(txt)
            txt.colorize(:light_green)
        end

        def self.red(txt)
            txt.colorize(:light_red)
        end
    end
end
