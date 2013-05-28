require 'pry'

module CodeSync
  module Processors
    class JstProcessor
      def self.process contents,filename="adhoc",extension=".jst"
        contents.match(/\w+.JST\[(.*)\]/) do |match|
          if match[1]
            contents[match[1]] = "\"#{filename}\""
          end
        end

        contents
      end
    end
  end
end