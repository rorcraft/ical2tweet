#!/usr/bin/ruby -w

require 'rubygems'; require 'cgi'; require 'yaml'
require 'authenticate' 
require "ruby-debug"
require "ical_parser"

# configuration is done entirely through config.yaml
CONFIG_FILE = 'config.yaml'

if File.exist?(CONFIG_FILE) && File.ftype(CONFIG_FILE) == 'file'
  CONFIG = YAML::load(File.read('config.yaml'))
else
  abort "\n\nPlease edit config-example.yaml and save it as config.yaml\n\n"
end


DEBUG_MODE = false 

AUTH_MODE = CONFIG['auth_mode']
auth = Authenticate.new
twitter = nil;

if AUTH_MODE == 'basic'
  # OAuth mode automatically gets these gems from twitter_oauth.
  # require 'json'; require 'rest-open-uri'
  twitter = auth.use_basic_auth
elsif AUTH_MODE == 'oauth'
  require 'twitter_oauth'
  twitter = auth.use_oauth
else
  abort 'Invalid authentication mode. You must use basic or oauth.'
end


# read ical
ical = IcalParser.new(CONFIG['ical_url']) 
today_events  = ical.find_today_event
if today_events.empty?
  puts "No events found, aborting"
else
  today_events.each do |e|
    status = "#{e.summary} #{e.dtstart.strftime("%I:%M%p")} #{e.description}  #{e.location} #hkitevents"
    puts "Found Event: #{status}"
    twitter.update(status)     
  end
end
