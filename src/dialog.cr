require "colorize"

class Dialog
    def self.usage
        "#{bold("Usage: coin [-h] [-v] amount origin <target, ...>")}"
    end

    def self.help
        msg = <<-EOP
        #{usage}

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

        puts msg
    end

    def self.version
        puts "coin v0.1.0"
    end

    def self.missing_operand
        die("missing operand")
    end

    def self.unknown_option
        die("unknown option")
    end

    def self.not_decimal(val)
        die("value \"#{val}\" is not a decimal number")
    end

    def self.zero_value
        die("cannot convert zero")
    end

    def self.no_target
        die("at least one target currency is required for convertion")
    end

    def self.die(txt)
        msg = <<-EOP
        #{"Error:".colorize(:light_red)} #{txt}.

        #{usage}
        EOP

        puts msg
        exit 1
    end

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
