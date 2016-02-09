#! usr/bin/env ruby
# open warning
$-w = true

# require 'wombat'
require 'xmlsimple'
require "bio"

class NCBIquery

    def initialize(keyword, filename)

        @keyword = format_query(keyword)
        @filename = filename
        @ncbi = Bio::NCBI::REST

    end

    def format_query(keyword)

        query_keyword = keyword.strip
        if query_keyword.include? " "
            query_keyword.gsub!(/\s/, "&")
        end
        return query_keyword

    end


    def submit_query

        # measure time
        start = Time.now
        query_table = {"db" => "pubmed", "retmode" => "xml", "retmax" => 2000000, "rettype" => "medline"}
        pubmed_count = @ncbi.esearch(format_query(@keyword), query_table)
        # puts "pubmed id of publications #{pubmed_count.to_s} have been found"
        puts "Total query: #{pubmed_count.length}"
        mid = Time.now
        puts "Time cost => #{mid - start}"
        pubmed_data = @ncbi.efetch(pubmed_count)
        puts "Data retrieved..."
        mid2 = Time.now
        puts "Time cost => #{mid2 - mid}"
        begin
            infile = File.new(@filename, "w+")
            infile.puts(pubmed_data, query_table)
            infile.close
        rescue Exception => e
            raise "Error, the file could not be created"
        end
        puts "File created..."
        puts "Time cost => #{Time.now - mid2}"

    end

end



