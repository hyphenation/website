require 'yaml'

class Array
  def choose
    self[rand(self.count)]
  end
end

class MetadataParseError < StandardError; end

module Pages
  @@eohmarker = '=' * 42

  def mainpage
    # puts ".mainpage called."
    texfiles = File.expand_path('../../tex-hyphen/hyph-utf8/tex/generic/hyph-utf8/patterns/tex/hyph-*.tex', __FILE__)
    @languages = []

    Dir.glob(texfiles) do |texfile|
      next unless texfile =~ /.*hyph-.*\.tex$/
      begin
        language = parse_tex_file(texfile)
        # puts "Adding language #{language}"
        @languages << language
      rescue MetadataParseError
        next
      end
    end

    # byebug
    @languages.sort! do |a, b|
      a[:name] <=> b[:name]
    end
    # puts ".mainpage returning."
  end

  def parse_tex_file(texfile)
    bcp47 = texfile.gsub(/^.*\/hyph-/, '').gsub(/\.tex$/, '')
    header = ''
    # raise MetadataParseError unless bcp47 == 'de-1996'
    # puts "Reading TeX file #{texfile}."
    # byebug
    File.read(texfile).each_line do |line|
      break if line =~ /\\patterns|#{@@eohmarker}/
      # puts "Read line #{line}."
      header += line.gsub(/^% /, '').gsub(/%.*/, '')
    end
    # byebug
    begin
      metadata = YAML::load(header)
    rescue Psych::SyntaxError
      raise MetadataParseError
    end
    raise MetadataParseError unless metadata && metadata['licence']
    name = metadata['language'] && metadata['language']['name'] || ""
    lic = metadata['licence']
    if lic.is_a? Array
      lics = lic.map { |l| l['name'] }
    else
      lics = [lic['name']]
    end
    lics.compact!
    if metadata['hyphenmins'] && hmins = metadata['hyphenmins']['typesetting']
      lefthmin = hmins['left']
      righthmin = hmins['right']
    else
      lefthmin, righthmin = 1 + rand(2), rand(3) + 1
    end
    if metadata['authors']
      authors = metadata['authors'].map { |author| author['name'] }
    else
      authors = []
    end

    {
      bcp47: bcp47,
      name: name,
      code: name.downcase,
      texfile:
      "https://github.com/hyphenation/tex-hyphen/tree/master/hyph-utf8/tex/generic/hyph-utf8/patterns/tex/hyph-#{bcp47}.tex",
      licences: if lics.empty? then ['<em>custom</em>'] else lics end,
      lefthyphenmin: lefthmin,
      righthyphenmin: righthmin,
      :'8bitenc' => ['EC', 'QX', 'T2M', 'T2X', 'L4'].choose,
      authors: authors
    }
  end
end
