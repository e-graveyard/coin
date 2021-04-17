require "spec"
require "../src/coin/*"

def perform_cmd?(arg : String, *argv)
  args = Array.new 1, arg

  if argv.first?
    args.concat argv.to_a
  end

  flag = true
  begin
    parser = CLI::Parser.new args
    parser.act
  rescue CLI::Exception
    flag = false
  end

  flag
end
