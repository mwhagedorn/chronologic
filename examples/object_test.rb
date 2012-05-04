require './boilerplate'
connection = Chronologic::Client::Connection.new('http://localhost:7979')

connection.record("author_1", {"name" => "Adam"})
connection.record("author_2", {"name" => "Fred Derp"})