require "./cli"

def main
    parser = Parser.new(ARGV)
    parser.run
end

main
