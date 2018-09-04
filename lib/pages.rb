require 'yaml'

include TeX::Hyphen

module Pages
  def mainpage
    @languages = Language.all.values.select do |language|
      begin
        language.extract_metadata
        language.licences && language.authors
      rescue InvalidMetadata
        false
      end
    end.sort
  end
end
