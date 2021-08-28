class JsonStringValidator < ActiveModel::EachValidator
  JSON_DATA_TYPES = [NilClass, TrueClass, FalseClass, String, Integer, Float, Hash, Array]
  ERROR_MSG = "is not a valid json string"


  def validate_each(record, attribute, value)
    check_options
    return if options[:allow_nil] && value.blank?

    unless valid_json? value
      return record.errors.add attribute, ERROR_MSG
    end

    if options[:parses_to].present? && !valid_type?(value)
      return record.errors.add attribute, ERROR_MSG
    end

    if options.has_key?(:parses_to_blank) && options[:parses_to_blank] == false
      return record.errors.add(attribute, ERROR_MSG) if parses_to_blank?(value)
    end
  end


  private

    def valid_json?(value)
      begin
        JSON.parse(value)
      rescue
        false
      end
    end

    def valid_type?(value)
      JSON.parse(value).class.in? options[:parses_to]
    end

    def parses_to_blank?(value)
      JSON.parse(value).blank?
    end

    def check_options
      check_illegal_options
      check_parses_to_options if options.has_key? :parses_to
      check_parses_to_blank_options if options.has_key? :parses_to_blank
    end

    def check_illegal_options
      illegal_opts = options.keys.without(:allow_nil, :parses_to, :parses_to_blank)
      raise ArgumentError.new(
        "Invalid option :#{illegal_opts.first} for date validation"
      ) if illegal_opts.present?
    end

    def check_parses_to_options
      raise ArgumentError.new(
        "Invalid option parses_to: #{options[:parses_to]} - must be an array"
      ) if options[:parses_to].class != Array

      options[:parses_to].each do |opt|
        raise ArgumentError.new(
          "Invalid option parses_to: #{opt} - not a valid JSON data type"
        ) if !opt.in? JSON_DATA_TYPES
      end
    end

    def check_parses_to_blank_options
      raise ArgumentError.new(
        "Invalid option parses_to_blank: #{options[:parses_to_blank]} - must be boolean"
      ) if !options[:parses_to_blank].class.in? [TrueClass, FalseClass]
    end
end
