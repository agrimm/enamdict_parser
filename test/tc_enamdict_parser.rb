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

    assert_include enamdict_parser.japanese_names, expected_name, failure_message
  end

  def test_dont_include_katakana_names
    filename = 'data/smallJMnedict.xml'
    unexpected_name = 'Irwin'
    failure_message = "Can't exclude katakana (presumably foreign) names"

    enamdict_parser = EnamdictParser.parse(filename)

    refute_includes enamdict_parser.japanese_names, unexpected_name, failure_message
  end

  def test_list_katakana_names_as_non_japanese
    filename = 'data/smallJMnedict.xml'
    expected_name = 'Irwin'
    failure_message = "Can't list non-Japanese names"

    enamdict_parser = EnamdictParser.parse(filename)

    assert_include enamdict_parser.non_japanese_names, expected_name, failure_message
  end

  def test_does_not_include_names_with_spaces
    filename = 'data/smallJMnedict.xml'
    unexpected_name = 'Aika Shun (1984.12.8-)'
    failure_message = "Can't exclude names with spaces"

    enamdict_parser = EnamdictParser.parse(filename)

    refute_includes enamdict_parser.japanese_names, unexpected_name, failure_message
  end
end
