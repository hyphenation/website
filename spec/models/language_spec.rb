require 'spec_helper'

describe Language do
  describe '.all' do
    it "lists all languages" do
      expect(Language.all.count).to eq 74
    end
  end

  describe '.find_by_bcp47' do
    it "finds the language for that BCP47 tag" do
      sv = Language.find_by_bcp47('sv')
      expect(sv).to be_a Language
    end
  end

  describe '#bcp47' do
    it "returns the BCP47 tag of the language" do
      nl = Language.find_by_bcp47('nl')
      expect(nl.bcp47).to eq 'nl'
    end
  end

  describe '#patterns' do
    it "returns the patterns" do
      sl = Language.find_by_bcp47('sl')
      expect(sl.patterns.count).to eq 1068
    end
  end

  describe '#hyphenate' do
    it "hyphenates" do
      de1996 = Language.find_by_bcp47('de-1996')
      expect(de1996.hyphenate('Zwangsvollstreckungsmaßnahme')).to eq 'zwangs-voll-stre-ckungs-maß-nah-me'
    end

    it "loads the patterns if needed" do
      de1901 = Language.find_by_bcp47('de-1901')
      expect(de1901.instance_variable_get(:@hydra)).to be_nil
      hyph = de1901.hyphenate('Zwangsvollstreckungsmaßnahme')
      expect(de1901.instance_variable_get(:@hydra)).to be_a Hydra
      expect(hyph).to eq 'zwangs-voll-streckungs-maß-nah-me'
    end
  end
end
