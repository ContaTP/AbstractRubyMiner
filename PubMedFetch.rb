#! usr/bin/env ruby
# open warning
$-w = true

# require 'wombat'
require "rubygems"
require "bio"
require "nokogiri"

class NCBIquery

    def initialize(keyword, filename, **kwargs)

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
        # start = Time.now
        query_table = {"db" => "pubmed", "retmode" => "xml", "retmax" => 2000000, "rettype" => "medline"}
        pubmed_count = @ncbi.esearch(format_query(@keyword), query_table)
        # puts "pubmed id of publications #{pubmed_count.to_s} have been found"
        puts "Total query: #{pubmed_count.length}"

        # mid = Time.now
        # puts "Time cost => #{mid - start}"
        @pubmed_data = @ncbi.efetch(pubmed_count, query_table)
        puts "Data retrieved..."
        # mid2 = Time.now
        #puts "Time cost => #{mid2 - mid}"
        begin
            infile = File.new(@filename, "w+")
            infile.puts(@pubmed_data)
            infile.close
        rescue Exception => e
            raise "Error:the file could not be created"
        end
        puts "File created..."
        #puts "Time cost => #{Time.now - mid2}"

    end

    def get_abstract

        begin
            data = Nokogiri::XML(@pubmed_data)
        rescue
            raise "Error: query data not obtained"
        end
        f1, f2 = @filename.split(".", 2)
        newfilename = "#{f1}.abstract.#{f2}"

        outfile = File.new(newfilename, "w+")
        outfile.puts(data.xpath("//PubmedArticle//Abstract"))
        outfile.close
        puts "Abstract extracted..."
    end

    def get_mesh

        begin
            data = Nokogiri::XML(@pubmed_data)
        rescue
            raise "Error: query data not obtained"
        end
        f1, f2 = @filename.split(".", 2)
        newfilename = "#{f1}.mesh.#{f2}"

        article = data.xpath("//PubmedArticle").select do|article_node|
            article_node.xpath("//PMID")
            article_node.xpath("//MeshHeadingList")
        end

        outfile = File.new(newfilename, "w+")
        outfile.puts(article)
        outfile.close
    end


    def close_query

        remove_class_variable(@pubmed_data)

    end
end



