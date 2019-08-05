# fluent-plugin-port-to-service [![Build Status](https://travis-ci.org/cpedro/fluent-plugin-port-to-service.svg?branch=master)](https://travis-ci.org/cpedro/fluent-plugin-port-to-service)

## Overview

[Fluentd](http://fluentd.org/) filter plugin to map TCP/UDP ports to service
names. Values are stored in a SQLite3 database for simplicity.

## Requirements
| fluent-plugin-port-to-service | fluentd    | ruby   | sqlite3  |
| ----------------------------- | ---------- | ------ | -------- |
| > 0.0.9                       | >= v0.14.0 | >= 2.1 | >= 1.3.7 |

## Dependency

Before use, install dependant libraries, namely sqlite3.

```bash
# for RHEL/CentOS
$ sudo yum groupinstall "Development Tools"
$ sudo yum install sqlite sqlite-devel

# for Ubuntu/Debian
$ sudo apt-get install build-essential
$ sudo apt-get install sqlite3 libsqlite3-dev

# for MacOS
$ brew install sqlite3
```

## Installation

Use RubyGems to install sqlite3 first, then copy plugin over.
install with `gem` or td-agent provided command as:

```bash
# for fluentd
$ gem install sqlite3

# for td-agent
$ sudo fluent-gem install sqlite3

# for td-agent2
$ sudo td-agent-gem install sqlite3
```

## Configuration

```conf
<filter **>
  @type port_to_service

  # Required parameters
  path          /etc/td-agent/plugin/port_to_service.db

  # Optional parameters
  port_key      port
  protocol_key  protocol
  service_key   service
</filter>
```

If the following record is passed in:
```json
{"protocol": "tcp", "port": "22", "foo": "bar"}
```

The filtered record will be:
```json
{"protocol": "tcp", "port": "22", "service": "ssh", "foo": "bar"}
```

## SQLite3 Database Setup

The plugin requires a database to be built.  At this time, you will have to do
this manually.  You can follow the below steps.  For my implementation, I parsed
the `/etc/services` file on a Linux machine for into a block of `INSERT`
statements into the database.

At a future date, a script *might* be provided to build the database on
installation.

The table must be called `services` and the 3 fields must be:
* `port` - Integer
* `protocol` - Text
* `service` - Text

You can also add a primary key, `id`, but it's only required for posterity.

Example:
```bash
$ sqlite3 /etc/td-agent/plugin/port_to_service.db
sqlite> CREATE TABLE services(id INTEGER PRIMARY KEY, port INTEGER, protocol TEXT, service TEXT);
sqlite> INSERT INTO services(port, protocol, service) VALUES (22, 'tcp', 'ssh');
...
```

You can use the below script for now on a Linux server to parse `/etc/services`
and use the contents to create the database.
```bash
$ echo "CREATE TABLE services(id INTEGER PRIMARY KEY, port INTEGER, protocol TEXT, service TEXT);" > port_to_service.sql
$ egrep -v '^\s*$|^#' /etc/services | awk '{print $1 " " $2}' | sed 's/\// /g' | awk '{print "INSERT INTO services(port, protocol, service) VALUES (" $2 ", \"" $3 "\", \"" $1 "\");"}' >> port_to_service.sql

$ sqlite3 /etc/td-agent/plugin/port_to_service.db < port_to_service.sql
```

## Copyright
​
Copyright(c) 2019- [Chris Pedro](https://chris.thepedros.com/)

## License

[The Unlicense](https://unlicense.org/)
