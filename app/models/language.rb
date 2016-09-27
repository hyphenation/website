class Language
  @@languages = nil
  @@hyphdir = 'tex-hyphen/hyph-utf8/tex/generic/hyph-utf8/patterns/txt'
  attr_reader :bcp47

  def self.all
    unless @@languages
      @@languages = { }
      Dir.foreach(@@hyphdir) do |file|
        next unless file =~ /^hyph-(.*)\.pat\.txt$/
        @@languages[$1] = Language.new($1)
      end
    end

    @@languages
  end

  def self.find_by_bcp47(bcp47)
    Language.all
    @@languages[bcp47]
  end

  def initialize(bcp47)
    @bcp47 = bcp47
  end

  def patterns
    @patterns ||= File.read(File.join(@@hyphdir, "hyph-#{bcp47}.pat.txt")).split
  end

  def hyphenate(word)
    unless @hydra
      @hydra = Hydra.new(patterns)
    end

    @hydra.showhyphens(word)
  end
end
