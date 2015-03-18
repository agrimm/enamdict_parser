require 'set'
require 'forwardable'

# Parses the enamdict file
class EnamdictParser
  extend Forwardable

  def_delegators :@name_list, :names, :add_name, :output

  ENAMDICT_FILENAME = 'data/JMnedict.xml'
  def self.run
    enamdict_parser = parse(ENAMDICT_FILENAME)
    enamdict_parser.output
  end

  def self.parse(filename)
    file = File.open(filename)
    new(file)
  end

  def initialize(file)
    @file = file
    @name_list = NameList.new
    parse_file
  end

  def parse_file
    for line in @file.each_line
      check_for_katakana_status(line)
      name = parse_name_if_applicable(line)
      next if name.nil?
      add_name(name, @katakana_entry)
    end
  end

  REB_ELEMENT_START = '<reb>'
  REB_ELEMENT_END = '</reb>'
  REB_START_LENGTH = REB_ELEMENT_START.length
  REB_END_LENGTH = REB_ELEMENT_END.length
  def check_for_katakana_status(line)
    return unless line.include?(REB_ELEMENT_START)
    fail 'Assumption broken' unless line.include?(REB_ELEMENT_END)
    reb_content = line[(REB_START_LENGTH)...(-REB_END_LENGTH - 1)]
    @katakana_entry = (reb_content =~ /\p{Katakana}/)
  end

  TRANS_DET_ELEMENT_START = '<trans_det>'
  TRANS_DET_ELEMENT_END = '</trans_det>'
  TRANS_DET_START_LENGTH = TRANS_DET_ELEMENT_START.length
  TRANS_DET_END_LENGTH = TRANS_DET_ELEMENT_END.length
  def parse_name_if_applicable(line)
    return unless line.include?(TRANS_DET_ELEMENT_START)
    fail 'Assumption broken' unless line.include?(TRANS_DET_ELEMENT_END)
    line[(TRANS_DET_START_LENGTH)...(-TRANS_DET_END_LENGTH - 1)]
  end
end

# List of names
class NameList
  attr_reader :names

  def initialize
    @names = Set.new
  end

  def add_name(name, katakana_entry)
    return if unsuitable_name?(name)
    return if katakana_entry
    @names << name
  end

  SPACE = ' '
  def unsuitable_name?(name)
    name.include?(SPACE)
  end

  OUTPUT_FILENAME = 'names.txt'
  def output
    output_text = @names.to_a.join("\n")
    File.write(OUTPUT_FILENAME, output_text)
  end
end
