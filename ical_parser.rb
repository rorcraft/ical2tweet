#!/usr/bin/ruby -w
require 'open-uri'
require "icalendar"


if __FILE__ == $0
  raise "\n\nThis file is not meant to be run standalone.\n\n"
end

class IcalParser
  # attr_accessor :ical

  def initialize(url)
    @ical = Icalendar.parse(open(url)).first
  end
  
  def find_today_event     
    @ical.events.find_all do |e|  
      Date.parse(e.dtstart.to_s) == Date.today && e.status == "CONFIRMED"
    end
  end
  
end