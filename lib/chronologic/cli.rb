require 'thor'
require 'thin'
require "cassandra"
require "chronologic"

module Chronologic
  class CLI < Thor
    desc "server", "starts the ChronoLogic server"
    method_option :port, :type => :numeric, :default => 7979, :required => true, :aliases => '-p'
    method_option :host, :type => :string, :default => '0.0.0.0', :required => true, :aliases => '-h'
    method_option :keyspace, :type => :string, :default => 'ChronologicTest', :required => true, :aliases => '-k'

    def server
      server = Thin::Server.new(options[:host], options[:port]) do
        keyspace = options[:keyspace]
        puts "Using #{keyspace}"
        Chronologic.connection = Cassandra.new(keyspace)
        logger = Logger.new(STDOUT)
        logger.level = Logger::DEBUG
        Chronologic::Service::App.logger = logger
        Chronologic::Service::Schema.logger = logger
        run Chronologic::Service::App.new
      end
      begin
        server.start!
      rescue AMQP::TCPConnectionFailed => e
        Firehose.logger.error "Unable to connect to AMQP, are you sure it's running?"
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
end
