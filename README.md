# Chronologic: You put your feeds in it

Chronologic is a service for storing and generatin activity feeds, new
feeds, timelines, and other forms of aggregated, reverse-sorted data.
Chronologic includes a small model layer that applications can use to
map their domain to Chronologic types. This model layer talks to a
Chronologic REST service. Said service uses an underlying database for
storage. Currently storage is Cassandra-only, but that's a temporary
condtion, you dig?

## Overview

Chronologic exposes four kinds of data:

* **Events** are the items that appear in your feeds. These are your
  statuses, checkins, commits, changes, etc. Feeds are often a social
  thing, therefore they reference objects...
* **Objects** are the things that events happen to. These are your
  users, spots, projects, documents, etc.
* **Timelines** are the endpoints where activity feeds appear. They
  contain any number of events. Every event is written to one or more
  target timelines. Timelines fan events out based on subscriptions...
* **Subscriptions** connect timelines to other timelines. To make events
  posted to your user timeline appear in the site-wide timeline, you
  would subscribe the site-wide timeline to your use timeline.


# Getting Started

First, you'll need to install and run Cassandra.  This is best done by installing from source. The version 0.12.3 found at https://github.com/mwhagedorn/cassandra.git
addresses the thrift client issue you may encounter.  The latest gem has a bad thrift client version reference.

```sh
$ git clone https://github.com/mwhagedorn/cassandra.git
$ cd cassandra
$ rake install
```

Now boot the Cassandra database

```sh
$ cassandra_helper cassandra
```


# Installing the Chronologic Server

Next you need to install the cassandra server.   The fork found at https://github.com/mwhagedorn/chronologic.git includes
some handy bootstrapping helpers.   Get the code and do a build.


```sh
$ git clone https://github.com/mwhagedorn/chronologic.git
$ cd chronologic
$ rake install
```

Then use the bootstrapping functions to build out the needed Cassandra back end data structures.

```sh
$ chronologic keyspace -k MyKeyspace
```

This will create the keyspace "MyKeyspace" in Cassandra (default is 'ChronologicTest').  Similiarly you can create the

needed column families (i.e. tables in relational-speak) by using the columnfamilies command

```sh
$ chronologic columnfamilies -c MyKeyspace
```

This will create the needed column families (i.e. Object,Event,Subscription,Timeline) in the MyKeyspace keyspace.

Finally you can boot the server.

```sh
$ chronologic server
```










Chronlogic will write its objects by default to a keyspace named "ChronologicTest".  Keyspaces are analogous to
databases in a relational type datastore.   To create this keyspace and the necessary objects within it, you can use the
examples/bootstrap.rb script.

To run both the Cassandra database and the Chronologic server you can use the foreman gem (gem install foreman if you
dont have this installed)

then type
    foreman start

 this will run your database and your Chronologic server.   Note that on startup the environment variable KEYSPACE is
 consulted to figure out which keyspace to connect to in Cassandra.  This is defaulted to "ChronologicTest"


 then type
    ruby examples/bootstrap.rb

 This will create the Chronologic keyspace, and the necessary Column Families (i.e. Tables in a relational store)



## Running Chronologic

Instructions on running Chronologic and idea about deploying it go here.

## Contributing

The way you contribute to the development of Chronologic goes here.

## License

Copyright 2010-2011 Gowalla Incorporated. Chronologic is MIT licensed.

