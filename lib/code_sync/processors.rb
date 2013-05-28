require "code_sync/processors/jst_processor"

module CodeSync
  module Processors
    Map = {
      ".hamlc" => CodeSync::Processors::JstProcessor,
      ".jst.hamlc" => CodeSync::Processors::JstProcessor,
      ".jst.skim" => CodeSync::Processors::JstProcessor
    }
  end

  def self.lookup_processor_for_extension(extension)
    if processor = Processors::Map[extension]
      processor
    else
      CodeSync::Processors::Basic
    end
  end

end
