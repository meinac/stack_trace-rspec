# frozen_string_literal: true

require_relative "rspec/version"

require "stack_trace/viz"
require "pathname"
require "securerandom"

RSpec.configuration.after(:suite) do
  StackTrace::Rspec.finish_tracing
end

RSpec.configuration.around(:each) do |example|
  StackTrace.trace { example.run }

  StackTrace::Rspec.store_trace(StackTrace.current, example)
end

module StackTrace
  module Rspec
    EXAMPLE_META_KEYS = %i[file_path line_number scoped_id description full_description].freeze
    FINAL_MESSAGE = <<~TEXT
      \e[1m
      StackTrace:

      Trace information is saved into \e[32m%<file_path>s\e[0m
      \e[22m
    TEXT

    class << self
      def finish_tracing
        ensure_path_is_created!

        html.save(file_path)
            .then { |path| print_message(path) }
      end

      def store_trace(trace, example)
        html.add(trace, **example.metadata.slice(*EXAMPLE_META_KEYS))
      end

      private

      def ensure_path_is_created!
        Dir.mkdir(file_dir) unless File.directory?(file_dir)
      end

      def html
        @html ||= StackTrace::Viz::HTML.new
      end

      def print_message(path)
        puts format(FINAL_MESSAGE, file_path: path)
      end

      def file_path
        file_dir.join("#{SecureRandom.uuid}.html")
      end

      def file_dir
        Pathname.new(RSpec.configuration.default_path)
                .join("stack_trace")
      end
    end
  end
end
