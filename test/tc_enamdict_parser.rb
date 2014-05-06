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

  def test_get_translation
    filename = 'data/smallJMnedict.xml'
    expected_name = 'Chusen'
    failure_message = "Can't get translations"

    enamdict_parser = EnamdictParser.parse(filename)

    assert_include enamdict_parser.names, expected_name, failure_message
  end
end
