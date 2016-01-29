require 'json'
require 'optparse'
require 'httparty'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: opt_parser COMMAND [OPTIONS]'
  opt.separator ''
  opt.separator 'Commands'
  opt.separator '     start: start data migration'
  #opt.separator  '     stop: stop migration'
  #opt.separator  '     restart: restart migration'
  opt.separator ''
  opt.separator 'Options'

  opt.on('-a', '--cloudmine-appid APPID', 'which environment you want server run') do |appid|
    options['appid'] = appid
  end

  opt.on('-k', '--cloudmine-master-key MASTERKEY', 'CloudMine master API key') do |key|
    options['masterkey'] = key
  end

  opt.on('-f', '--data-file DATAFILEPATH', 'Parse exported data file path to process') do |src|
    options['src'] = src
  end

  opt.on('-h', '--help', 'help') do
    puts opt_parser
  end
end

opt_parser.parse!

def migrate_data options
  file = File.read(options['src'])
  data_hash = JSON.parse(file)

  if data_hash and not data_hash.empty?
    # add counter here which dumps to command line
    data_hash['results'].each { |parse_shape|
      cm_object = transform_object File.basename(options['src'], '.json'), parse_shape
      send_cm_object cm_object, options['appid'], options['masterkey']
    }
  end
end

def transform_object class_name, parse_hash
  transform_hash = parse_hash
  # TODO: inspect the ACL and create for user where needed
  transform_hash['__class__'] = class_name # set the class for CM indexing
  transform_hash['__id__'] = parse_hash['objectId'] # transform the ID to CM __id__
  transform_hash
end

def send_cm_object cm_object, app_id, master_key
  headers = {
    "Content-Type" => "application/json",
    "X-CloudMine-ApiKey" => master_key
  }

  object_body = {
    cm_object['__id__'] => cm_object
  }.to_json

  response = HTTParty.put(
    "https://api.cloudmine.me/v1/app/#{app_id}/text",
    {
      headers: headers,
      body: object_body
    })
  puts "object: #{cm_object['__id__']} status: #{response.code}"
end

case ARGV[0]
  when 'start'
    'starting migration'
    migrate_data options
  else
    puts opt_parser
end