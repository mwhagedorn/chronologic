require 'thor'
require 'thin'
require "cassandra"
require "chronologic"

module Chronologic
  class CLI < Thor
    desc "server", "starts the Chronologic server and connects to a Cassandra keyspace"
    method_option :port, :type => :numeric, :default => 7979, :required => true, :aliases => '-p', :banner => "port for Chronologic server"
    method_option :host, :type => :string, :default => '0.0.0.0', :required => true, :aliases => '-h', :banner => "host for Chronologic server"
    method_option :keyspace, :type => :string, :default => 'ChronologicTest', :required => true, :aliases => '-k', :banner => "Cassandra keyspace for Chronologic to connect to"

    def server
      begin
        keyspace = options[:keyspace]

        Chronologic.connection = Cassandra.new(keyspace)
        verify_cassandra_connectivity
        unless verify_cassandra_schema
          throw new Exception("keyspace #{keyspace} does not include all the appropriate column families.  Use the columnfamily command to build this schema")
        end
        set_chronologic_defaults
        puts "Using Cassandra Keyspace: #{keyspace}"

        server = Thin::Server.new(options[:host], options[:port]) do
          run Chronologic::Service::App.new
        end

        server.start!
      rescue CassandraThrift::InvalidRequestException => e
        if e.message =~ /is no ring for the keyspace:/
          puts "Unable to start Chronologic.  Cassandra keyspace #{options[:keyspace]} does not exist.  Look at examples/bootstrap.rb for how to create one or use the cassandra cli and enter: create keyspace #{options[:keyspace]}; or use the keyspace command"
        else
          puts "Unable to start Chronologic. Unknown Cassandra error:#{e.message}"
        end
      rescue CassandraThrift::Cassandra::Client::TransportException => e
        puts "Unable to start Chronologic. Unable to connect to Cassandra.  Are you sure its running?"
      rescue RuntimeError => e
        if e.message =~ /port is in use/
          puts "Unable to start Chronologic. Something else appears to be running on port #{options[:port]}.  Stop that process and try again"
        else
          puts e.message
        end
      rescue
        puts $!.inspect, $@
      end
    end

     desc "keyspace", "creates the keyspace in Cassandra.  Assumes Cassadra is running"
     method_option :keyspace, :type => :string, :default => 'ChronologicTest', :required => true, :aliases => '-k', :banner => "Create keyspace in Cassandra for Chronologic to connect to"

      def keyspace
        begin
          schema = Chronologic::SchemaHelper.new(options[:keyspace])
          schema.create_keyspace
          puts "created keyspace #{options[:keyspace]}"
        rescue CassandraThrift::Cassandra::Client::TransportException => e
           puts "Unable to connect to Cassandra.  Are you sure its running?"
        end

      end

    desc "columnfamilies", "creates appropriate column families in the keyspace for Cassandra.  Assumes Cassadra is running"
    method_option :keyspace, :type => :string, :default => 'ChronologicTest', :required => true, :aliases => '-k', :banner => " Keyspace in Cassandra to create column families in"

        def columnfamilies
          begin
            schema = Chronologic::SchemaHelper.new(options[:keyspace])
            schema.create_column_families
            puts "created column families in keyspace #{options[:keyspace]}"
          rescue CassandraThrift::Cassandra::Client::TransportException => e
             puts "Unable to connect to Cassandra.  Are you sure its running?"
          end

        end


    no_tasks do
      def verify_cassandra_connectivity
        Chronologic.connection.keyspaces
      end
      def verify_cassandra_schema
        [:Object, :Subscription, :Timeline, :Event].each do |cf|
          unless Chronologic.connection.column_families.keys.include?(cf.to_s)
            return false
          end
         return true
        end
      end
      def set_chronologic_defaults
        logger = Logger.new(STDOUT)
        logger.level = Logger::DEBUG
        Chronologic::Service::App.logger = logger
        Chronologic::Service::Schema.logger = logger
      end
    end

  end
end
