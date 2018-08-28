require_relative '../pages'

include Pages

class Language
  @@hyphdir = 'tex-hyphen/hyph-utf8/tex/generic/hyph-utf8/patterns/txt'
  attr_reader :bcp47

  def initialize(bcp47)
    @bcp47 = bcp47
  end

  def self.all
    @@languages ||= Dir.foreach(@@hyphdir).inject [] do |languages, file|
      languages << [$1, Language.new($1)] if file =~ /^hyph-(.*)\.pat\.txt$/

      languages
    end.to_h
  end

  def self.find_by_bcp47(bcp47)
    all[bcp47]
  end

  def patterns
    @patterns ||= File.read(File.join(@@hyphdir, "hyph-#{bcp47}.pat.txt")).split
  end

  def hyphenate(word)
    unless @hydra
      begin
        metadata = extract_metadata(File.join(@@hyphdir, '..', 'tex', 'hyph-' + bcp47 + '.tex'))
        @hydra = Hydra.new(patterns, :lax, '', metadata)
      rescue MetadataParseError
        @hydra = Hydra.new(patterns)
      end
    end

    @hydra.showhyphens(word)
  end
end
