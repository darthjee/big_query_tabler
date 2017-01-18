require 'json'
require './big_exporter/structure'

class BigExporter
  def file
    @file ||= File.open('sample.json')
  end

  def json
    @json ||= file.read
  end

  def hash
    @hash ||= JSON.parse(json)
  end

  def output
    @output ||= File.open('fields.json', 'w')
  end

  def export
    output.write(exported.to_json)
  end

  def exported
    @exported ||= Structure.new(hash)
  end
end

