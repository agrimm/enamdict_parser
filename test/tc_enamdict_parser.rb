$LOAD_PATH << File.join(__dir__, '..', 'lib')

require 'bundler/setup'

require 'test/unit'
require 'enamdict_parser'

# Test for EnamdictParser
class TestEnamdictParser < Test::Unit::TestCase
  def test_parse_file
    filename = 'data/tinyJMnedict.xml'
    assert_nothing_raised('It blew up') do
      EnamdictParser.parse(filename)
    end
  end
end
