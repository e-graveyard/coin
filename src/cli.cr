require "optarg"
require "./dialog"
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

        private def parse_and_perform_optional_args
            error = false

            begin
                opt = OptionalArgumentsModel.parse(@argv)
                if opt.h? || opt.help?
                    Dialog::CLI.help

                elsif opt.v? || opt.version?
                    Dialog::CLI.version

                else
                    error = true
                end

            rescue Optarg::UnknownOption
                error = true
            end

            Dialog::CLI.unknown_option if error
        end

        private def parse_positional
            # expected positional arguments
            amount = Int32
            origin = String
            targets = Array(String).new

            # ensures that no flag will be passed as an argument
            begin
                pos = PositionalArgumentsModel.parse(@argv)

            rescue Optarg::UnknownOption
                Dialog::CLI.unknown_option
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
                Dialog::CLI.not_decimal(pos.amount)
            end

            amount = amountf.to_i

            if amountf == 0
                Dialog::CLI.zero_value
            end

            # ensures that at least one target currency is defined
            if pos.targets.size == 0
                Dialog::CLI.no_target
            end

            # ensures that the origin and target currency symbols are valid
            symbols = Array(String)
                .new
                .concat([origin])
                .concat(targets)

            symbols.each do |value|
                Dialog::CLI.invalid_symbol(value) if
                    !(Currency::SYMBOLS.has_key? value)
            end

            # ensures that the origin currency symbol is not amongst the targets
            Dialog::CLI.cannot_convert_itself(origin) if
                targets.includes? origin

            return amount, origin, targets
        end

        def act
            Dialog::CLI.missing_operand if @argv.size == 0

            if @argv.size == 1
                parse_and_perform_optional_args
                exit 0
            end

            return parse_positional
        end
    end
end
