require "colorize"

module Dialog
    def self.die(txt)
        puts "#{"Error:".colorize(:light_red)} #{txt}."
        exit 1
    end

    class CLI
        def self.usage
            "#{Style.bold("Usage: coin [-h] [-v] amount origin <target, ...>")}"
        end

        def self.help
            msg = <<-EOP
            #{usage}

            Positional arguments:
                #{Style.blue("amount")}             The amount of money to be converted
                #{Style.blue("origin")}             The origin currency used as base for conversion
                #{Style.blue("target")}             Each of the target currencies for conversion

            Optional arguments:
                #{Style.blue("-h, --help")}         Show this help message and exit
                #{Style.blue("-v, --version")}      Show the program version and exit

            Examples:
                $ #{Style.green("coin 1 usd brl")}
                # => converts 1 us dollar to brazilian real

                $ #{Style.green("coin 2.5 eur rub jpy")}
                # => converts 2.5 euro to russian rouble and japanese yen

            This is free and open source software (FOSS).
            Licensed under the MIT license.

            #{Style.bold("Project page: <github.com/caian-org/coin>")}
            EOP

            puts msg
        end

        def self.version
            puts "coin v0.1.0"
        end

        def self.missing_operand
            Dialog.die("missing operand")
        end

        def self.unknown_option
            Dialog.die("unknown option")
        end

        def self.not_decimal(val)
            Dialog.die("value \"#{val}\" is not a decimal number")
        end

        def self.zero_value
            Dialog.die("cannot convert zero")
        end

        def self.no_target
            Dialog.die("at least one target currency is required for convertion")
        end
    end

    class Style
        def self.bold(txt)
            txt.colorize.mode(:bold)
        end

        def self.blue(txt)
            txt.colorize(:light_blue)
        end

        def self.green(txt)
            txt.colorize(:light_green)
        end

        def self.green(txt)
            txt.colorize(:light_green)
        end
    end
end