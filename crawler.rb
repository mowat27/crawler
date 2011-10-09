['open-uri'].each {|lib| require lib}
def crawl(url,  max_depth = 10, current_depth = 0, linked_by = {})
  begin page = open(url)
  rescue Exception => ex; return linked_by; end # ignore bad links etc
  page.string.scan(/href *= *[\"']([^'"]+)[\"']/)  do  
    case 
      when !$1.start_with?("http"); next
      when !linked_by[$1].nil?; linked_by[$1] << url
      else linked_by[$1] = [url]; crawl($1, max_depth, current_depth + 1, linked_by) unless current_depth >= max_depth
    end
  end
  linked_by
end
new_version = crawl(ARGV[0] || 'http://localhost:4567', ARGV[1].to_i || 2)

expected = {"http://localhost:4567/page1"=>["http://localhost:4567", "http://localhost:4567/page1", "http://localhost:4567/page2", "http://localhost:4567"], "http://localhost:4567/page2"=>["http://localhost:4567/page1", "http://localhost:4567"], "http://localhost:4567/page3"=>["http://localhost:4567/page2"], "http://localhost:4567/page99"=>["http://localhost:4567/page2"]}

if(expected == new_version)
  puts "Test Passed"
else
  puts "Test failed"
  puts "expected: #{expected}"
  puts "new_version: #{new_version}"
end
