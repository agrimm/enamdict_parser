# Parses the enamdict file
class EnamdictParser
  attr_reader :names

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

  TRANS_DET_ELEMENT_START = '<trans_det>'
  TRANS_DET_ELEMENT_END = '</trans_det>'
  START_ELEMENT_LENGTH = TRANS_DET_ELEMENT_START.length
  END_ELEMENT_LENGTH = TRANS_DET_ELEMENT_END.length
  def find_potential_names
    names = []
    for line in @file.each_line
      next unless line.include?(TRANS_DET_ELEMENT_START)
      fail 'Assumption broken' unless line.include?(TRANS_DET_ELEMENT_END)
      name = line[(START_ELEMENT_LENGTH)...(-END_ELEMENT_LENGTH - 1)]
      names << name
    end
    names
  end

  SPACE = ' '
  def unsuitable_name?(name)
    name.include?(SPACE)
  end
end
