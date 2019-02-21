require "./cli"
require "./exchanger"

def main
    parser = CLI::Parser.new(ARGV)
    args = parser.act

    amount = args["amount"]
    origin = args["origin"]
    targets = args["targets"]

    fixer = Exchanger::Fixer.new(amount, origin, targets)
end

main
