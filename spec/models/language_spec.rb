require 'spec_helper'
require 'byebug'

describe Language do
  describe '.all' do
    it "sets the languages class variable" do
      expect(Language.class_variable_get(:@@languages)).to be_nil
      all_languages = Language.all
      expect(Language.class_variable_get(:@@languages)).to be_an Hash
      expect(all_languages.count).to eq 75
    end

    it "lists all languages" do
      expect(Language.all).to be_an Array
      expect(Language.all.count).to eq 75
    end
  end

  describe '.find_by_bcp47' do
    it "finds the language for that BCP47 tag" do
      sv = Language.find_by_bcp47('sv')
      expect(sv).to be_a Language
    end
  end

  describe '.new' do
    it "creates a new Language instance" do
      fi = Language.new('fi')
      expect(fi).to be_a Language
    end

    it "sets the BCP47 tag" do
      et = Language.new('et')
      expect(et.bcp47).to eq 'et'
    end
  end

  describe '#bcp47' do
    it "returns the BCP47 tag of the language" do
      nl = Language.find_by_bcp47('nl')
      expect(nl.bcp47).to eq 'nl'
    end

    it "calls Language.all first" do
      expect(Language).to receive(:all)
      dk = Language.find_by_bcp47('dk')
    end
  end

  describe '#patterns' do
    it "returns the patterns" do
      sl = Language.find_by_bcp47('sl')
      expect(sl.patterns.count).to eq 1068
    end

    it "loads the patterns first" do
      hr = Language.find_by_bcp47('hr')
      expect(hr.patterns).to be_an Array
    end
  end

  describe '#hyphenate' do
    it "hyphenates" do
      de1996 = Language.find_by_bcp47('de-1996')
      expect(de1996.hyphenate('Zwangsvollstreckungsmaßnahme')).to eq 'zwangs-voll-stre-ckungs-maß-nah-me'
    end

    it "initialises the hydra if needed" do
      de1901 = Language.find_by_bcp47('de-1901')
      expect(de1901.instance_variable_get(:@hydra)).to be_nil
      hyph = de1901.hyphenate('Zwangsvollstreckungsmaßnahme')
      expect(de1901.instance_variable_get(:@hydra)).to be_a Hydra
      expect(hyph).to eq 'zwangs-voll-streckungs-maß-nah-me'
    end
  end

  # TODO set hyphenmins
end
