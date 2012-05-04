require 'rubygems'
require 'bundler/setup'

require 'pp'
require 'chronologic'

connection = Chronologic::Client::Connection.new('http://localhost:7979')

event = Chronologic::Client::Event.new
event.key = "story_6"
event.data = {
    "headline" => "First ever post in Chronologic!",
      "lede" => "A monumental occasion for housecats everywhere.",
        "body" => "There is currently a cat perched on my arm. This is normal, carry on!"
}
event.objects = {}
event.timelines = ['home']
pp event.to_transport
connection.publish(event)

feed = connection.timeline('home')

puts "We found #{feed['count']} events."
puts "That event looks just like this:"
pp feed['items'].first
