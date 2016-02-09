#! usr/bin/env ruby
require "./PubMedFetch.rb"


query1 = NCBIquery.new("herbal therapy", "x:/xxxx/result1.txt")
query1.submit_query()
