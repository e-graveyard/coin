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

class Parser
    @argv = [] of String

    def initialize(argv)
        @argv = argv
    end

    def run
        Dialog.missing_operand if @argv.size == 0

        if @argv.size == 1
            parse_and_perform_optional_args
            exit 0
        end

        return parse_positional
    end

    private def parse_and_perform_optional_args
        error = false

        begin
            opt = OptionalArgumentsModel.parse(@argv)
            if opt.h? || opt.help?
                Dialog.help

            elsif opt.v? || opt.version?
                Dialog.version

            else
                error = true
            end

        rescue Optarg::UnknownOption
            error = true
        end

        Dialog.unknown_option if error
    end

    private def parse_positional
        # ensures that no flag will be passed
        begin
            pos = PositionalArgumentsModel.parse(@argv)

        rescue Optarg::UnknownOption
            Dialog.unknown_option
        end

        # ensures that the first argument is a float number.
        begin
            amountd = pos.amount.to_f
            amountd = amountd * 100

        rescue ArgumentError
            Dialog.not_decimal(pos.amount)
        end

        if amountd == 0
            Dialog.zero_value
        end

        # Ensures that at least one target currency is defined
        if pos.targets.size == 0
            Dialog.no_target
        end

        return {
            "amount"  => amountd,
            "origin"  => pos.origin,
            "targets" => pos.targets
        }
    end
end
