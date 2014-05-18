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

  def test_dont_include_katakana_names
    filename = 'data/smallJMnedict.xml'
    unexpected_name = 'Irwin'
    failure_message = "Can't exclude katakana (presumably foreign) names"

    enamdict_parser = EnamdictParser.parse(filename)

    refute_includes enamdict_parser.names, unexpected_name, failure_message
  end
end
