require "optarg"
require "./dialog"

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
        @argv = [] of String

        def initialize(argv)
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
            # ensures that no flag will be passed
            begin
                pos = PositionalArgumentsModel.parse(@argv)

            rescue Optarg::UnknownOption
                Dialog::CLI.unknown_option
            end

            # ensures that the first argument is a float number.
            begin
                amountd = pos.amount.to_f
                amountd = amountd * 100

            rescue ArgumentError
                Dialog::CLI.not_decimal(pos.amount)
            end

            if amountd == 0
                Dialog::CLI.zero_value
            end

            # Ensures that at least one target currency is defined
            if pos.targets.size == 0
                Dialog::CLI.no_target
            end

            return {
                "amount"  => amountd,
                "origin"  => pos.origin,
                "targets" => pos.targets
            }
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
