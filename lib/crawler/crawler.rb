['uri','open-uri'].each {|lib| require lib}
def crawl(url, max_depth, current_depth = 0, linked_by = {})
  uri = URI.parse(url)
  begin page = open(url)
  rescue Exception => ex; return linked_by; end # ignore bad links
  page.read.scan(/href\s*=\s*[\"']([^'"]+)[\"']/)  do 
    link = $1.start_with?("http") ? $1 : "#{uri.scheme}://#{uri.host}:#{uri.port}#{$1}"
    case 
      when !linked_by[link].nil?; linked_by[link] << url
      else linked_by[link] = [url]; crawl(link, max_depth, current_depth + 1, linked_by) unless current_depth >= max_depth
    end
  end
  linked_by
end
puts crawl(ARGV[0] || 'http://localhost:4567', ARGV[1].to_i || 3) if $0 == __FILE__