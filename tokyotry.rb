#!/usr/bin/env ruby

require 'tokyocabinet'
include TokyoCabinet

hdb = HDB::new
hdb.open("has-db.tch", HDB::OWRITER | HDB::OCREAT)
hdb.put("this-is-a-key","this-is-a-value")
puts hdb.get("this-is-a-key")
