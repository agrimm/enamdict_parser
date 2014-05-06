require 'nokogiri'

# Parses the enamdict file
class EnamdictParser
  def self.parse(filename)
    file = File.open(filename)
    Nokogiri::XML(file)
    file.close
  end
end
