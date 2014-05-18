# Parses the enamdict file
class EnamdictParser
  attr_reader :names

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
    @names = determine_names
  end

  def determine_names
    potential_names = find_potential_names
    suitable_names = potential_names.reject(&method(:unsuitable_name?))
    suitable_names.uniq
  end

  def find_potential_names
    names = []
    for line in @file.each_line
      name = parse_name_if_applicable(line)
      next if name.nil?
      names << name
    end
    names
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

  SPACE = ' '
  def unsuitable_name?(name)
    name.include?(SPACE)
  end

  OUTPUT_FILENAME = 'names.txt'
  def output
    output_text = @names.join("\n")
    File.write(OUTPUT_FILENAME, output_text)
  end
end
