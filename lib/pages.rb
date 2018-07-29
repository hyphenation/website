require 'yaml'

class Array
  def choose
    self[rand(self.count)]
  end
end

module Pages
  def mainpage
    eohmarker = '=' * 42
    texfiles = File.expand_path('../../tex-hyphen/hyph-utf8/tex/generic/hyph-utf8/patterns/tex/hyph-*.tex', __FILE__)
    @languages = []

    Dir.glob(texfiles) do |texfile|
      next unless texfile =~ /.*hyph-(.*)\.tex$/
      bcp47 = $1
      header = ''
      File.read(texfile).each_line do |line|
        break if line =~ /\\patterns|#{eohmarker}/
        header += line.gsub(/^% /, '').gsub(/%.*/, '')
      end
      begin
        metadata = YAML::load(header)
      rescue Psych::SyntaxError
        next
      end
      next unless metadata['licence']
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
      @languages << {
        bcp47: bcp47,
        name: name,
        code: name.downcase,
        texfile:
        "https://github.com/hyphenation/tex-hyphen/tree/master/hyph-utf8/tex/generic/hyph-utf8/patterns/tex/hyph-#{bcp47}.tex",
        licences: if lics.empty? then ['<i>custom</i>'] else lics end,
        lefthyphenmin: lefthmin,
        righthyphenmin: righthmin,
        :'8bitenc' => ['EC', 'QX', 'T2M', 'T2X', 'L4'].choose,
        authors: authors
      }
    end
  end
end
