require 'nokogiri'
require 'open-uri'

class MacbethAnalyzer

  DOC = "http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml"

  attr_reader :play, :speech_count

  def initialize(doc = DOC)
    @play = Nokogiri::HTML(open(doc))
    @speech_count = Hash.new(0)
  end

  def get_character_lines
    @play.xpath('//speech').each do |speech|
      get_characters(speech).each do |character|
        @speech_count[character] += count_lines(speech)
      end
    end
    @speech_count
  end

  def get_characters(speech)
    speech.xpath(".//speaker").map(&:text)
  end

  def count_lines(speech)
    speech.xpath(".//line").count
  end

  def print_speeches
    get_character_lines.each { |key, value| puts "#{key}: #{value}" }
  end

end
