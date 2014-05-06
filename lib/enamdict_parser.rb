require 'nokogiri'

# Parses the enamdict file
class EnamdictParser
  attr_reader :names

  def self.parse(filename)
    text = File.read(filename)
    nokogiri = Nokogiri::XML(text)
    new(nokogiri)
  end

  ENTRY_NODE_XPATH = '/JMnedict/entry'
  def initialize(nokogiri)
    @nokogiri = nokogiri
    @entry_nodes = @nokogiri.xpath(ENTRY_NODE_XPATH)
    @names = determine_names
  end

  def determine_names
    names = @entry_nodes.map(&method(:determine_name))
    suitable_names = names.reject(&method(:unsuitable_name?))
    suitable_names.uniq
  end

  TRANS_DET_XPATH = 'trans/trans_det'
  def determine_name(node)
    trans_det_node = node.xpath(TRANS_DET_XPATH).first
    trans_det_node.content
  end

  SPACE = ' '
  def unsuitable_name?(name)
    name.include?(SPACE)
  end
end
