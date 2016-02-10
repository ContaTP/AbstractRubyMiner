#! usr/bin/env ruby
require "./PubMedFetch.rb"


query1 = NCBIquery.new("herbal therapy gene", "E:/Github\ Practice/MAMSDunett/data/result1.txt")
query1.submit_query()
query1.get_mesh()