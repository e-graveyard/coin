require "./cli"
require "./exchanger"


def main
    parser = CLI::Parser.new(ARGV)
    amount, origin, targets = parser.act

    token = (t = ENV["FIXER_API_TOKEN"]?) ? t : ""

    fixer = Exchanger::Fixer.new(amount, origin, targets)
    fixer.set_token(token)
    fixer.convert
end

main
