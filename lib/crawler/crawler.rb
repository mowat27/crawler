require 'open-uri'
def crawl(url, max_depth, current_depth = 0, linked_by = {})
  begin page = open(url)
  rescue Exception => ex; return linked_by; end # ignore bad links etc
  page.read.scan(/href\s*=\s*[\"']([^'"]+)[\"']/)  do  
    case 
      when !$1.start_with?("http"); next
      when !linked_by[$1].nil?; linked_by[$1] << url
      else linked_by[$1] = [url]; crawl($1, max_depth, current_depth + 1, linked_by) unless current_depth >= max_depth
    end
  end
  linked_by
end
puts crawl(ARGV[0] || 'http://localhost:4567', ARGV[1].to_i || 3) if $0 == __FILE__