require 'json'
require 'optparse'
require 'httparty'
require 'active_support/all'
require 'securerandom'

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

  opt.on('-f', '--data-file DATAFILEPATH', 'Parse exported _User file path to process') do |src|
    options['src'] = src
  end

  opt.on('-h', '--help', 'help') do
    puts opt_parser
  end
end

opt_parser.parse!

def migrate_users options
  file = File.read(options['src'])
  data_hash = JSON.parse(file)

  if data_hash and not data_hash.empty?
    # add counter here which dumps to command line
    data_hash['results'].each { |parse_shape|
      cm_user = transform_user parse_shape
      # dump collection the objectId to CM user id for future ACL reference
      create_cm_user cm_user, options['appid'], options['masterkey']
    }
  end
end

def transform_user user_hash
  # password is a random generated GUID with the intention of firing a password reset request for each user
  cm_user = {
    'credentials' => {
      'email' => user_hash['email'],
      'username' => user_hash['username'],
      'password' => SecureRandom.uuid
    },
    'profile' => user_hash.except('bcryptPassword', 'username', 'email')
  }
  cm_user
end

def create_cm_user cm_user, app_id, master_key
  headers = {
    "Content-Type" => "application/json",
    "X-CloudMine-ApiKey" => master_key
  }

  response = HTTParty.post(
    "https://api.cloudmine.me/v1/app/#{app_id}/account/create",
    {
      headers: headers,
      body: cm_user.to_json
    })
  puts "status: #{response.inspect}"
end

case ARGV[0]
  when 'start'
    'starting migration'
    migrate_users options
  else
    puts opt_parser
end