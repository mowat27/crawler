['open-uri','set'].each {|lib| require lib}
def crawl(url,  max_depth = 10, current_depth = 0, linked_by = {})
  begin page = open(url)
  rescue Exception => ex; return linked_by; end # ignore bad links etc
  links_found = page.inject(Set.new) do |found, line| 
    line.scan(/href *= *[\"']([^'"]+)[\"']/) {|m| found << $1 if $1.start_with?("http")} 
    found
  end
  links_found.each do |link|
    if(linked_by[link]) 
      linked_by[link] << url
    else
      linked_by[link] = [url]
      linked_by = crawl(link, max_depth, current_depth + 1, linked_by) unless current_depth >= max_depth
    end
  end
  linked_by
end
puts "#{crawl(ARGV[0] || 'http://localhost:4567', ARGV[1].to_i || 2)}"