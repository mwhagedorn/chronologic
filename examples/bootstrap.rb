require 'rubygems'
require 'cassandra'



class Bootstrap
  attr_accessor :keyspace

  COLUMN_FAMILIES = [:Object, :Subscription, :Timeline, :Event]
  def initialize(base_keyspace = "ChronologicTest")
    @db = Cassandra.new("system")
    @keyspace = base_keyspace
  end

  def keyspace_exists?(keyspace)
   @db.keyspaces.include?(keyspace) 
  end

  def column_family_exists?(column_family_name)
    @db.column_families.keys.include?(column_family_name)
  end

  def create_keyspace
    unless keyspace_exists?(@keyspace)
      ksdef = Cassandra::Keyspace.new(:name=>@keyspace, :strategy_class=>"org.apache.cassandra.locator.NetworkTopologyStrategy",:strategy_options=>{"datacenter1"=>"1"},:cf_defs=>[])
      @db.add_keyspace(ksdef)
     end
     @db.keyspace=@keyspace
  end

  def create_column_families
    COLUMN_FAMILIES.each do |cf|
      unless column_family_exists?(cf.to_s)
        cfdef = Cassandra::ColumnFamily.new(:keyspace=>@keyspace,:name=>cf.to_s)
        @db.add_column_family(cfdef)
      end
    end
  end

  def truncate_column_family(cf_name)
    @db.truncate!(cf)
  end

  def connection
    @db
  end


end

b = Bootstrap.new("mytest")

b.create_keyspace
b.create_column_families
puts "Chronologic is now bootstrapped! for keyspace:#{b.keyspace}"
puts "Keyspace: #{b.keyspace}"
puts "Column Families:"
b.connection.column_families.keys.each do |cf|
  puts cf
end


