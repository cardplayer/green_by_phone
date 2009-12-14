require 'rubygems'
require 'test/unit'
require 'activesupport'
require 'shoulda'
require 'erb'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'green_by_phone'

class Test::Unit::TestCase
  FakeWeb.allow_net_connect = false

  def fixture(key)
    yaml_data = YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), 'data.yml'))).result)
    symbolize_keys(yaml_data)
    yaml_data[key]
  end

  def symbolize_keys(hash)
    return unless hash.is_a?(Hash)
    hash.symbolize_keys!
    hash.each { |k,v| symbolize_keys(v) }
  end
end
