require "./cli"
require "./exchanger"

def main
    parser = CLI::Parser.new(ARGV)
    amount, origin, targets = parser.act

    fixer = Exchanger::Fixer.new(amount, origin, targets)
    return 0
end

exit main
