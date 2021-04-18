require "colorize"
require "./currency"

VERSION = "v0.2.0"

module CLI
  class Parser
    def initialize(argv : Array(String))
      @argv = argv
    end

    def version
      puts "coin #{VERSION}"
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

    def act
      if @argv.size == 0
        raise CLI::Exception.new "missing operand"
      end

      if @argv.size == 1
        case @argv[0].downcase
        when "-h", "--help"
          help
        when "-v", "--version"
          version
        else
          raise CLI::Exception.new "unknown option"
        end

        return empty
      end

      if @argv.size < 3
        raise CLI::Exception.new "needs at least 3 positional arguments"
      end

      return parse_positional
    end

    private def empty
      {0, "", [] of String}
    end

    private def parse_positional
      # expected positional arguments
      amount = Int32
      origin = String
      targets = [] of String

      argv_upcased = [] of String

      @argv.each do |arg|
        # ensures that no flag will be passed as an argument
        if arg.starts_with?("-") || arg.starts_with?("--")
          raise CLI::Exception.new "unknown option"
        end

        # upcase all symbols
        argv_upcased << arg.upcase
      end

      amount = argv_upcased[0]
      origin = argv_upcased[1]
      targets = argv_upcased[2..]

      # ensures that the first argument is a decimal greater then zero
      begin
        amountf = amount.to_f
        amountf = amountf * 100
      rescue ArgumentError
        raise CLI::Exception.new "value \"#{amount}\" is not a decimal number"
      end

      amount = amountf.to_i
      if amountf == 0
        raise CLI::Exception.new "cannot convert zero"
      end

      # ensures that the origin and target currency symbols are valid
      symbols = [origin]
      symbols.concat targets

      symbols.each do |value|
        unless Currency::SYMBOLS.has_key? value
          raise CLI::Exception.new "\"#{value}\" is not a valid currency symbol"
        end
      end

      # ensures that the origin currency symbol is not amongst the targets
      if targets.includes? origin
        raise CLI::Exception.new "cannot convert \"#{origin}\" to itself"
      end

      return amount, origin, targets
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
      puts "#{Style.blue "\nConversion of #{amount / 100.0} #{origin}\n"}"

      max_padding = 0
      results.each do |r|
        len = "#{Style.nine_dec_places r}".size
        max_padding = len if len > max_padding
      end

      targets.zip(results).each do |target, result|
        f = Style.nine_dec_places result
        padding = max_padding - "#{f}".size

        print " - #{Style.green f} #{" " * padding}"
        print "#{Style.dim "(#{target})"} #{Currency::SYMBOLS[target]}.\n"
      end

      print "\n"
    end
  end

  private class Style
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

    def self.nine_dec_places(value)
        sprintf "%.9f", value
    end
  end
end
